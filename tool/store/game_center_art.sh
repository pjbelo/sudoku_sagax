#!/bin/sh
# Regenerates the achievement images: docs/app-store/game-center/<key>.png
# (1024×1024, Game Center) and docs/google-play/play-games/<key>.png
# (512×512, Google Play Games). Both stores want them without an alpha
# channel, so each render is flattened with macOS `sips` (PNG → JPEG → PNG).
set -e
cd "$(dirname "$0")/../.."

flutter test tool/store/game_center_art_test.dart --update-goldens

for f in docs/app-store/game-center/*.png; do
  tmp="${f%.png}.tmp.jpg"
  sips -s format jpeg -s formatOptions best "$f" --out "$tmp" >/dev/null
  sips -s format png "$tmp" --out "$f" >/dev/null
  rm "$tmp"
done

mkdir -p docs/google-play/play-games
for f in docs/app-store/game-center/*.png; do
  sips -Z 512 "$f" --out "docs/google-play/play-games/$(basename "$f")" >/dev/null
done

file docs/app-store/game-center/*.png docs/google-play/play-games/*.png
