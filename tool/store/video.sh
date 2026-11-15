#!/bin/bash
# Records the store preview video on a simulator or emulator, for every language.
#
#   tool/store/video.sh iphone         # App Store app preview, iPhone and iPhone Duo (886×1920)
#   tool/store/video.sh ipad           # App Store app preview, iPad 13" (1200×1600)
#   tool/store/video.sh pixel          # Google Play promo video, phone (1080×1920, portrait)
#   tool/store/video.sh pixel-tablet   # Google Play promo video, tablet (1920×1080, landscape)
#   tool/store/video.sh iphone en,pt   # only some languages
#
# integration_test/store_video_test.dart plays a scripted session and prints
# timed cues; this script records the screen meanwhile, then
# tool/store/compose_video.dart adds captions, the cut, music and sounds.
# Output (gitignored):
#   docs/app-store/videos/<iphone|ipad>/<lang>.mp4
#   docs/google-play/videos/<pixel|pixel-tablet>/<lang>.mp4
# Google Play takes one video per language, as a YouTube link.
#
# Android: uses the first emulator (AVD) whose name contains "Pixel_9_Pro" or
# "Pixel_Tablet", or the one named in $AVD, booting it with the host GPU if it
# isn't running. It records with the device's own `screenrecord`, at a
# reduced size ($rec_size). Close the iOS simulator first, and vice versa:
# the two together are too much for a computer with 8 GB of memory.
#
# Needs ffmpeg (brew install ffmpeg). Each language takes about 3 minutes.
set -eo pipefail
cd "$(dirname "$0")/../.."

target=${1:?usage: $0 <iphone|ipad|pixel|pixel-tablet> [langs]}
langs=${2:-en,pt,es,fr,de}

case $target in
  iphone)       platform=ios;     sim="iPhone 17 Pro" ;;  # 6.3", the required App Store size
  ipad)         platform=ios;     sim="iPad Pro 13-inch (M5)" ;;
  # rec_size: the emulator's encoder can't record the full screen, and the
  # smaller the size, the smoother the footage (more frames per second).
  pixel)        platform=android; avd_match="Pixel_9_Pro";  rec_size=720x1606 ;;
  pixel-tablet) platform=android; avd_match="Pixel_Tablet"; rec_size=1280x800 ;;
  *) echo "unknown target: $target" >&2; exit 1 ;;
esac
command -v ffmpeg >/dev/null || { echo "ffmpeg not found (brew install ffmpeg)" >&2; exit 1; }

# The simulator/emulator can't write to every volume (e.g. external drives),
# so record into the local temp dir and move it.
rec="${TMPDIR:-/tmp}/sudoku-sagax-video-$target.mp4"

if [ $platform = ios ]; then
  build_mode=--debug  # the simulator runs only debug builds
  pidfile="$rec.pid"
  device=$(xcrun simctl list devices available | grep -F "$sim (" | head -1 | grep -oE '[0-9A-F-]{36}')
  xcrun simctl boot "$device" 2>/dev/null || true
  xcrun simctl bootstatus "$device" -b >/dev/null
  open "$(xcode-select -p)/Applications/Simulator.app" 2>/dev/null || true  # optional: just to watch

  start_recording() {
    xcrun simctl io "$device" recordVideo --codec=h264 --force "$rec" >/dev/null 2>&1 &
    echo $! > "$pidfile"
  }
  stop_recording() {
    kill -INT "$(cat "$pidfile")" 2>/dev/null || true
  }
  # Stops the recorder if the test died early, and lets it finish writing.
  finish_recording() {
    local pid; pid=$(cat "$pidfile")
    kill -INT "$pid" 2>/dev/null || true
    while kill -0 "$pid" 2>/dev/null; do sleep 0.5; done
    rm -f "$pidfile"
  }
else
  # A debug build is too slow on the emulator: taps lag and the scenes run
  # long. Profile mode runs at full speed.
  build_mode=--profile
  device_rec=/sdcard/sudoku-sagax-video.mp4
  pidfile="$rec.pid"
  adb=$(command -v adb || echo "${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb")
  emulator=$(command -v emulator || echo "$(dirname "$(dirname "$adb")")/emulator/emulator")
  avd=${AVD:-$("$emulator" -list-avds | grep -m1 "$avd_match" || true)}
  [ -n "$avd" ] || { echo "no Android emulator (AVD) matching $avd_match; set AVD=<name>" >&2; exit 1; }

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
    # -gpu host: "auto" may pick software rendering (SwiftShader), which
    # draws a couple of frames per second and slows the whole run down.
    "$emulator" -avd "$avd" -no-boot-anim -gpu host >/dev/null 2>&1 &
    until device=$(find_device) && [ -n "$device" ]; do sleep 3; done
  fi
  until [ "$("$adb" -s "$device" shell getprop sys.boot_completed </dev/null | tr -d '\r')" = 1 ]; do sleep 2; done
  # Keep notifications from popping up over the footage.
  "$adb" -s "$device" shell settings put global heads_up_notifications_enabled 0 </dev/null

  # `</dev/null`: these run inside the loop that reads flutter's output, and
  # adb would otherwise swallow it.
  start_recording() {
    "$adb" -s "$device" shell screenrecord --size "$rec_size" \
      --bit-rate 20000000 --time-limit 180 "$device_rec" </dev/null >/dev/null 2>&1 &
    echo $! > "$pidfile"
  }
  stop_recording() {
    "$adb" -s "$device" shell pkill -INT screenrecord </dev/null >/dev/null 2>&1 || true
  }
  # Stops the recorder if the test died early, lets it finish writing, and
  # copies the recording from the device.
  finish_recording() {
    local pid; pid=$(cat "$pidfile")
    stop_recording
    while kill -0 "$pid" 2>/dev/null; do sleep 0.5; done
    rm -f "$pidfile"
    "$adb" -s "$device" pull "$device_rec" "$rec" </dev/null >/dev/null
    "$adb" -s "$device" shell rm -f "$device_rec" </dev/null
  }
fi

raw="build/store_video/raw/$target"
mkdir -p "$raw"

echo "Rendering captions"
flutter test tool/store/video_captions_test.dart --update-goldens >/dev/null

record() {
  local lang=$1
  : > "$raw/$lang.cues"
  flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/store_video_test.dart \
    --dart-define=LANG="$lang" \
    "$build_mode" \
    -d "$device" 2>&1 |
  while IFS= read -r line; do
    echo "$line"
    case "$line" in
      *CUE:*) echo "$line" >> "$raw/$lang.cues" ;;
    esac
    case "$line" in
      *CUE:*:ready) start_recording ;;
      *CUE:*:end)
        sleep 1
        stop_recording
        ;;
    esac
  done
  finish_recording
  mv "$rec" "$raw/$lang.mp4"
}

# Composing fails when something else moved on screen during the still
# pre-roll (the frames that line the cues up get lost), which happens now and
# then when the computer is busy. Then the language is simply recorded again.
for lang in ${langs//,/ }; do
  attempt=1
  echo "Recording $lang on $target ($device)"
  until record "$lang" && dart run tool/store/compose_video.dart "$target" "$lang"; do
    attempt=$((attempt + 1))
    if [ $attempt -gt 3 ]; then
      echo "Giving up on $lang after 3 attempts" >&2
      exit 1
    fi
    echo "Recording $lang on $target again (attempt $attempt of 3)"
  done
done
