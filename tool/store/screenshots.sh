#!/bin/bash
# Captures store screenshots on a simulator/emulator, for every language.
#
#   tool/store/screenshots.sh iphone         # App Store, iPhone 6.9" (optional)
#   tool/store/screenshots.sh iphone-6.3     # App Store, iPhone 6.3" and 6.1" (required)
#   tool/store/screenshots.sh ipad           # App Store, iPad 13"
#   tool/store/screenshots.sh duo-outer      # App Store, iPhone Duo outer display
#   tool/store/screenshots.sh duo-inner      # App Store, iPhone Duo inner display
#   tool/store/screenshots.sh ipad-landscape        # adds 2 landscape iPad shots
#   tool/store/screenshots.sh duo-inner-landscape   # adds 1 landscape Duo shot
#   tool/store/screenshots.sh pixel          # Google Play, phone
#   tool/store/screenshots.sh pixel-tablet   # Google Play, tablet
#   tool/store/screenshots.sh iphone en,pt   # only some languages
#   APPEARANCE=light tool/store/screenshots.sh iphone   # the light theme
#
# The app follows the system's light or dark setting. The store shots use
# the dark Sagax look unless APPEARANCE=light: the script sets the
# simulator or emulator to that appearance first.
#
# integration_test/store_screenshots_test.dart drives the app and prints
# `SHOT:<lang>_<name>` at each scene; this script grabs the real device screen
# (status bar set to 9:41, full battery) into build/store_screenshots/raw/.
# Then tool/store/screenshot_captions_test.dart puts a caption above each one,
# and the framed images go to docs/<store>/screenshots/ as plain RGB PNGs:
# both stores reject images with an alpha channel.
#
# iPhone Duo: the simulator can't be folded from the command line, so put it
# in the pose you want in DeviceHub (closed for duo-outer, open for
# duo-inner); the script waits until that display is on. A reboot closes the
# Duo again, so it runs every language without one: its status bar shows only
# the time, so the system language doesn't show. Each display is captured on
# its own, at the size App Store Connect expects (outer 1398×2034, inner
# 2007×2853, or rotated).
#
# The -landscape targets add the large-screen layouts after the six portrait
# shots (7_landscape_game, and 8_landscape_home on iPad). simctl can't rotate
# a simulator: turn it to landscape in DeviceHub when the script asks (after
# each language's reboot on iPad, once on iPhone Duo).
set -eo pipefail
cd "$(dirname "$0")/../.."

target=${1:?usage: $0 <iphone|iphone-6.3|ipad|duo-outer|duo-inner|ipad-landscape|duo-inner-landscape|pixel|pixel-tablet> [langs]}
langs=${2:-en,pt,es,fr,de}
appearance=${APPEARANCE:-dark}
case $appearance in dark|light) ;; *) echo "APPEARANCE must be dark or light" >&2; exit 1 ;; esac

case $target in
  iphone)       platform=ios;     sim="iPhone 17 Pro Max";     out="docs/app-store/screenshots/iPhone 17 Pro Max" ;;
  iphone-6.3)   platform=ios;     sim="iPhone 17 Pro";         out="docs/app-store/screenshots/iPhone 17 Pro" ;;
  ipad)         platform=ios;     sim="iPad Pro 13-inch (M5)"; out="docs/app-store/screenshots/iPad Pro 13-inch" ;;
  duo-outer)    platform=ios;     sim="iPhone Duo"; display_width=1398; out="docs/app-store/screenshots/iPhone Duo outer" ;;
  duo-inner)    platform=ios;     sim="iPhone Duo"; display_width=2007; out="docs/app-store/screenshots/iPhone Duo inner" ;;
  ipad-landscape)      platform=ios; sim="iPad Pro 13-inch (M5)"; landscape=game,home; out="docs/app-store/screenshots/iPad Pro 13-inch" ;;
  duo-inner-landscape) platform=ios; sim="iPhone Duo"; display_width=2007; landscape=game; out="docs/app-store/screenshots/iPhone Duo inner" ;;
  pixel)        platform=android; avd=SudokuSagax_Pixel_9_Pro;   out="docs/google-play/screenshots/pixel-9-pro" ;;
  pixel-tablet) platform=android; avd=SudokuSagax_Pixel_Tablet;  out="docs/google-play/screenshots/pixel-tablet" ;;
  *) echo "unknown target: $target" >&2; exit 1 ;;
esac

command -v ffmpeg >/dev/null || { echo "ffmpeg not found (brew install ffmpeg)" >&2; exit 1; }
raw="build/store_screenshots/raw/$target"
framed="build/store_screenshots/framed/$target"

# Saves a PNG as plain RGB (no alpha channel), losslessly.
save_rgb() {
  ffmpeg -nostdin -v error -y -i "$1" -pix_fmt rgb24 "$2"
}

if [ $platform = ios ]; then
  # A simulator that is already running comes first: it may have several
  # copies, and the iPhone Duo's pose is set on the one you have open.
  device=$(xcrun simctl list devices booted | grep -F "$sim (" | head -1 | grep -oE '[0-9A-F-]{36}' || true)
  if [ -z "$device" ]; then
    device=$(xcrun simctl list devices available | grep -F "$sim (" | head -1 | grep -oE '[0-9A-F-]{36}')
  fi
  # Optional, just to watch; needed on iPhone Duo to set the pose. DeviceHub
  # replaced Simulator in recent Xcode versions.
  open -a DeviceHub 2>/dev/null || open "$(xcode-select -p)/Applications/Simulator.app" 2>/dev/null || true
  # The iPad status bar shows the date in the system language, which simctl
  # can't override, so the simulator is switched to each language in turn.
  set_language() {
    local locale
    case $1 in
      en) locale=en_US ;; pt) locale=pt_PT ;; es) locale=es_ES ;;
      fr) locale=fr_FR ;; de) locale=de_DE ;; *) locale=$1 ;;
    esac
    xcrun simctl boot "$device" 2>/dev/null || true
    xcrun simctl bootstatus "$device" -b >/dev/null
    xcrun simctl spawn "$device" defaults write "Apple Global Domain" AppleLanguages -array "$1"
    xcrun simctl spawn "$device" defaults write "Apple Global Domain" AppleLocale -string "$locale"
    xcrun simctl shutdown "$device"
    xcrun simctl boot "$device"
    xcrun simctl bootstatus "$device" -b >/dev/null
    set_status_bar
    # A reboot turns the simulator back to portrait.
    if [ -n "$landscape" ]; then
      echo ">>> Turn the $sim to landscape in DeviceHub now; the run waits for it."
    fi
  }
  set_status_bar() {
    # The app follows the system's appearance (see APPEARANCE above).
    xcrun simctl ui "$device" appearance "$appearance"
    xcrun simctl status_bar "$device" override --time 9:41 \
      --dataNetwork wifi --wifiMode active --wifiBars 3 --cellularMode active \
      --cellularBars 4 --batteryState discharging --batteryLevel 100
  }
  # iPhone Duo: boots it if needed and waits until the display to capture is
  # on, which tells the pose (the other display is black).
  prepare_duo() {
    local tmp="${TMPDIR:-/tmp}/sudoku-sagax-pose.png"
    xcrun simctl boot "$device" 2>/dev/null || true
    xcrun simctl bootstatus "$device" -b >/dev/null
    set_status_bar
    echo "Put the iPhone Duo in DeviceHub $([ $target = duo-outer ] && echo closed || echo open)$([ -n "$landscape" ] && echo ", turned to landscape,") and keep it so until the end."
    until shoot "$tmp" && [ "$(mean_gray "$tmp" "iw:ih:0:0")" -gt 0 ]; do
      sleep 2
    done
    rm -f "$tmp"
    echo "The $target display is on, capturing."
  }
  # iPhone Duo: the display whose framebuffer is $display_width pixels wide.
  duo_display() {
    xcrun simctl io "$device" enumerate |
      awk -v w="$display_width" '/UUID:/{u=$2} /Default width:/{if ($3 == w) {print u; exit}}'
  }
  shoot() {
    if [ -n "$display_width" ]; then
      xcrun simctl io "$device" screenshot --display="$(duo_display)" "$1" >/dev/null 2>&1
    else
      xcrun simctl io "$device" screenshot "$1" >/dev/null 2>&1
    fi
  }
  # The simulator service can't write to every volume (e.g. external
  # drives), so capture into the local temp dir and move it.
  capture() {
    local tmp="${TMPDIR:-/tmp}/sudoku-sagax-shot.png" try
    for try in 1 2 3 4 5 6; do
      shoot "$tmp"
      if ! sensors_visible "$tmp"; then break; fi
      echo "  (Dynamic Island or camera in the shot, capturing again)"
      sleep 0.4
    done
    if [ -n "$display_width" ] && [ "$(mean_gray "$tmp" "iw:ih:0:0")" -eq 0 ]; then
      echo "  WARNING: the $target display is off; was the iPhone Duo's pose changed?"
    fi
    save_rgb "$tmp" "$1"
    rm "$tmp"
  }
  # The iPhone simulator now and then draws the Dynamic Island into the
  # screenshot, and the iPhone Duo its outer camera. The app's status bar
  # area is plain navy, so they show as a patch darker than the background
  # beside it.
  sensors_visible() {
    case $target in
      ipad|duo-inner|ipad-landscape|duo-inner-landscape) return 1 ;;
      duo-outer) camera_visible "$1" ;;
      *) island_visible "$1" ;;
    esac
  }
  camera_visible() {
    local camera bg
    camera=$(mean_gray "$1" "60:60:1225:115")
    bg=$(mean_gray "$1" "30:60:1155:115")
    [ "$camera" -lt $((bg - 6)) ]
  }
  island_visible() {
    local w island bg
    w=$(sips -g pixelWidth "$1" | awk '/pixelWidth/{print $2}')
    island=$(mean_gray "$1" "200:50:$((w / 2 - 100)):40")
    bg=$(mean_gray "$1" "100:50:$((w / 2 - 330)):40")
    [ "$island" -lt $((bg - 6)) ]
  }
  mean_gray() {
    # -nostdin: capture runs inside the loop reading flutter's output, which
    # ffmpeg would otherwise swallow.
    ffmpeg -nostdin -v error -i "$1" -vf "crop=$2,scale=1:1" -f rawvideo -pix_fmt gray - |
      od -An -tu1 | tr -d ' '
  }
else
  adb=$(command -v adb || echo "${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb")
  # The running emulator whose AVD is $avd (not just any emulator).
  find_device() {
    for d in $("$adb" devices | awk '/^emulator-/{print $1}'); do
      if "$adb" -s "$d" emu avd name 2>/dev/null | head -1 | tr -d '\r' | grep -qx "$avd"; then
        echo "$d"; return
      fi
    done
  }
  device=$(find_device)
  if [ -z "$device" ]; then
    flutter emulators --launch "$avd"
    until device=$(find_device) && [ -n "$device" ]; do sleep 3; done
  fi
  until [ "$("$adb" -s "$device" shell getprop sys.boot_completed | tr -d '\r')" = 1 ]; do sleep 2; done
  # SystemUI ignores demo-mode commands until it has fully started.
  sleep 20
  demo() { "$adb" -s "$device" shell am broadcast -a com.android.systemui.demo -e command "$@" >/dev/null; }
  # The app follows the system's appearance (see APPEARANCE above).
  "$adb" -s "$device" shell cmd uimode night "$([ "$appearance" = dark ] && echo yes || echo no)" >/dev/null
  "$adb" -s "$device" shell settings put global sysui_demo_allowed 1
  demo enter
  demo clock -e hhmm 0941
  demo battery -e level 100 -e plugged false
  demo network -e wifi show -e level 4 -e fully true
  demo network -e mobile show -e datatype none -e level 4 -e fully true
  demo notifications -e visible false
  capture() {
    local tmp="${TMPDIR:-/tmp}/sudoku-sagax-shot.png"
    "$adb" -s "$device" exec-out screencap -p > "$tmp"
    save_rgb "$tmp" "$1"
    rm "$tmp"
  }
fi

run() {
  flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/store_screenshots_test.dart \
    --dart-define=LANGS="$1" \
    --dart-define=LANDSCAPE="$landscape" \
    -d "$device" 2>&1 |
  while IFS= read -r line; do
    echo "$line"
    case "$line" in
      *WAITING_FOR_LANDSCAPE*)
        echo ">>> Turn the $sim to landscape in DeviceHub; the run goes on by itself."
        ;;
      *SHOT:*)
        shot=${line##*SHOT:}
        lang=${shot%%_*}
        mkdir -p "$raw/$lang"
        capture "$raw/$lang/${shot#*_}.png"
        echo "  -> $raw/$lang/${shot#*_}.png"
        ;;
    esac
  done
}

# Captions every raw capture of $langs and copies the framed images, without
# an alpha channel, to $out. Earlier screenshots of the same kind (portrait,
# or landscape) in those languages are removed first, so files of renamed
# scenes don't linger; the other kind is kept.
add_captions() {
  local f
  echo "Adding captions"
  flutter test tool/store/screenshot_captions_test.dart --update-goldens \
    --dart-define=TARGET="$target" --dart-define=LANGS="$langs"
  for lang in ${langs//,/ }; do
    mkdir -p "$out/$lang"
    for f in "${out:?}/${lang:?}"/*.png; do
      case $f in
        *_landscape_*) [ -z "$landscape" ] || rm -f "$f" ;;
        *) [ -n "$landscape" ] || rm -f "$f" ;;
      esac
    done
    for f in "$framed/$lang"/*.png; do
      save_rgb "$f" "$out/$lang/$(basename "$f")"
    done
    echo "  -> $out/$lang/"
  done
}

echo "Capturing $langs on $target ($device) into $out"
for lang in ${langs//,/ }; do
  rm -rf "${raw:?}/${lang:?}" "${framed:?}/${lang:?}"
done
if [ -n "$display_width" ]; then
  prepare_duo
  run "$langs"
elif [ $platform = ios ]; then
  for lang in ${langs//,/ }; do
    set_language "$lang"
    run "$lang"
  done
else
  run "$langs"
fi

if [ $platform = ios ]; then
  xcrun simctl status_bar "$device" clear
else
  demo exit
  "$adb" -s "$device" emu kill >/dev/null
fi

add_captions
