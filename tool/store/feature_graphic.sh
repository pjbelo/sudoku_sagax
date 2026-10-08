#!/bin/sh
# Regenerates docs/google-play/feature-graphic-<lang>.png (1024×500) for all
# locales. Google Play wants a 24-bit PNG or JPEG with no alpha channel, so
# each render is flattened with macOS `sips` (PNG → JPEG → PNG).
set -e
cd "$(dirname "$0")/../.."

flutter test tool/store/feature_graphic_test.dart --update-goldens

for f in docs/google-play/feature-graphic-*.png; do
  tmp="${f%.png}.tmp.jpg"
  sips -s format jpeg -s formatOptions best "$f" --out "$tmp" >/dev/null
  sips -s format png "$tmp" --out "$f" >/dev/null
  rm "$tmp"
done

file docs/google-play/feature-graphic-*.png
