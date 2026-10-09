#!/bin/bash
# Captures store screenshots on a simulator/emulator, for every language.
#
#   tool/store/screenshots.sh iphone         # App Store, iPhone 6.9"
#   tool/store/screenshots.sh iphone-6.3     # App Store, iPhone 6.3" (and 6.1")
#   tool/store/screenshots.sh ipad           # App Store, iPad 13"
#   tool/store/screenshots.sh pixel          # Google Play, phone
#   tool/store/screenshots.sh pixel-tablet   # Google Play, tablet
#   tool/store/screenshots.sh iphone en,pt   # only some languages
#
# integration_test/store_screenshots_test.dart drives the app and prints
# `SHOT:<lang>_<name>` at each scene; this script grabs the real device screen
# (status bar set to 9:41, full battery) into docs/<store>/screenshots/.
set -eo pipefail
cd "$(dirname "$0")/../.."

target=${1:?usage: $0 <iphone|iphone-6.3|ipad|pixel|pixel-tablet> [langs]}
langs=${2:-en,pt,es,fr,de}

case $target in
  iphone)       platform=ios;     sim="iPhone 17 Pro Max";     out="docs/app-store/screenshots/iPhone 17 Pro Max" ;;
  iphone-6.3)   platform=ios;     sim="iPhone 17 Pro";         out="docs/app-store/screenshots/iPhone 17 Pro" ;;
  ipad)         platform=ios;     sim="iPad Pro 13-inch (M5)"; out="docs/app-store/screenshots/iPad Pro 13-inch" ;;
  pixel)        platform=android; avd=SudokuSagax_Pixel_9_Pro;   out="docs/google-play/screenshots/pixel-9-pro" ;;
  pixel-tablet) platform=android; avd=SudokuSagax_Pixel_Tablet;  out="docs/google-play/screenshots/pixel-tablet" ;;
  *) echo "unknown target: $target" >&2; exit 1 ;;
esac

if [ $platform = ios ]; then
  command -v ffmpeg >/dev/null || { echo "ffmpeg not found (brew install ffmpeg)" >&2; exit 1; }
  device=$(xcrun simctl list devices available | grep -F "$sim (" | head -1 | grep -oE '[0-9A-F-]{36}')
  open "$(xcode-select -p)/Applications/Simulator.app" 2>/dev/null || true  # optional: just to watch
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
    xcrun simctl status_bar "$device" override --time 9:41 \
      --dataNetwork wifi --wifiMode active --wifiBars 3 --cellularMode active \
      --cellularBars 4 --batteryState discharging --batteryLevel 100
  }
  # The simulator service can't write to every volume (e.g. external
  # drives), so capture into the local temp dir and move it.
  capture() {
    local tmp="${TMPDIR:-/tmp}/sudoku-sagax-shot.png" try
    for try in 1 2 3 4 5 6; do
      xcrun simctl io "$device" screenshot "$tmp" >/dev/null 2>&1
      if [ "$target" = ipad ] || ! island_visible "$tmp"; then break; fi
      echo "  (Dynamic Island in the shot, capturing again)"
      sleep 0.4
    done
    mv "$tmp" "$1"
  }
  # The iPhone simulator now and then draws the Dynamic Island into the
  # screenshot. The app's status bar area is plain navy, so the island shows
  # as a patch darker than the background beside it.
  island_visible() {
    local w island bg
    w=$(sips -g pixelWidth "$1" | awk '/pixelWidth/{print $2}')
    island=$(mean_gray "$1" "200:50:$((w / 2 - 100)):40")
    bg=$(mean_gray "$1" "100:50:$((w / 2 - 330)):40")
    [ "$island" -lt $((bg - 6)) ]
  }
  mean_gray() {
    ffmpeg -v error -i "$1" -vf "crop=$2,scale=1:1" -f rawvideo -pix_fmt gray - |
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
  "$adb" -s "$device" shell settings put global sysui_demo_allowed 1
  demo enter
  demo clock -e hhmm 0941
  demo battery -e level 100 -e plugged false
  demo network -e wifi show -e level 4 -e fully true
  demo network -e mobile show -e datatype none -e level 4 -e fully true
  demo notifications -e visible false
  capture() { "$adb" -s "$device" exec-out screencap -p > "$1"; }
fi

run() {
  flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/store_screenshots_test.dart \
    --dart-define=LANGS="$1" \
    -d "$device" 2>&1 |
  while IFS= read -r line; do
    echo "$line"
    case "$line" in
      *SHOT:*)
        shot=${line##*SHOT:}
        lang=${shot%%_*}
        mkdir -p "$out/$lang"
        capture "$out/$lang/${shot#*_}.png"
        echo "  -> $out/$lang/${shot#*_}.png"
        ;;
    esac
  done
}

echo "Capturing $langs on $target ($device) into $out"
if [ $platform = ios ]; then
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
