#!/bin/bash
# Records the store preview video on a simulator, for every language.
#
#   tool/store/video.sh iphone         # App Store app preview, iPhone 6.9" (886×1920)
#   tool/store/video.sh ipad           # App Store app preview, iPad 13" (1200×1600)
#   tool/store/video.sh iphone en,pt   # only some languages
#
# integration_test/store_video_test.dart plays a scripted session and prints
# timed cues; this script records the simulator screen meanwhile, then
# tool/store/compose_video.dart adds captions, the cut, music and sounds.
# Output: build/store_video/<iphone|ipad>/<lang>.mp4. The iPhone video also
# serves as the Google Play promo video (upload it to YouTube).
#
# Needs ffmpeg (brew install ffmpeg). Each language takes about 3 minutes.
set -eo pipefail
cd "$(dirname "$0")/../.."

target=${1:?usage: $0 <iphone|ipad> [langs]}
langs=${2:-en,pt,es,fr,de}

case $target in
  iphone) sim="iPhone 17 Pro Max" ;;
  ipad)   sim="iPad Pro 13-inch (M5)" ;;
  *) echo "unknown target: $target" >&2; exit 1 ;;
esac
command -v ffmpeg >/dev/null || { echo "ffmpeg not found (brew install ffmpeg)" >&2; exit 1; }

device=$(xcrun simctl list devices available | grep -F "$sim (" | head -1 | grep -oE '[0-9A-F-]{36}')
xcrun simctl boot "$device" 2>/dev/null || true
xcrun simctl bootstatus "$device" -b >/dev/null
open "$(xcode-select -p)/Applications/Simulator.app" 2>/dev/null || true  # optional: just to watch

raw="build/store_video/raw/$target"
mkdir -p "$raw"

echo "Rendering captions"
flutter test tool/store/video_captions_test.dart --update-goldens >/dev/null

# The simulator service can't write to every volume (e.g. external drives),
# so record into the local temp dir and move it.
rec="${TMPDIR:-/tmp}/sudoku-sagax-video.mp4"
pidfile="$rec.pid"

record() {
  local lang=$1
  : > "$raw/$lang.cues"
  flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/store_video_test.dart \
    --dart-define=LANG="$lang" \
    -d "$device" 2>&1 |
  while IFS= read -r line; do
    echo "$line"
    case "$line" in
      *CUE:*) echo "$line" >> "$raw/$lang.cues" ;;
    esac
    case "$line" in
      *CUE:*:ready)
        xcrun simctl io "$device" recordVideo --codec=h264 --force "$rec" >/dev/null 2>&1 &
        echo $! > "$pidfile"
        ;;
      *CUE:*:end)
        sleep 1
        kill -INT "$(cat "$pidfile")"
        ;;
    esac
  done
  # Stop the recorder if the test died early, and let it finish writing.
  local pid; pid=$(cat "$pidfile")
  kill -INT "$pid" 2>/dev/null || true
  while kill -0 "$pid" 2>/dev/null; do sleep 0.5; done
  rm -f "$pidfile"
  mv "$rec" "$raw/$lang.mp4"
}

for lang in ${langs//,/ }; do
  echo "Recording $lang on $target ($device)"
  record "$lang"
  dart run tool/store/compose_video.dart "$target" "$lang"
done
