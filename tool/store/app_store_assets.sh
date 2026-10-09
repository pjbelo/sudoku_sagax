#!/bin/sh
# Regenerates the App Store creative assets (product page header 3840×1646
# and search results 3840×2560) into docs/app-store/creative-assets/<lang>/.
#
#   tool/store/app_store_assets.sh         # all locales
#   tool/store/app_store_assets.sh pt,en   # only some
#
# App Store Connect rejects images with an alpha channel, so each render is
# re-encoded as plain RGB (lossless) with ffmpeg.
set -e
cd "$(dirname "$0")/../.."

langs=${1:-en,pt,es,fr,de}
command -v ffmpeg >/dev/null || { echo "ffmpeg not found (brew install ffmpeg)" >&2; exit 1; }

flutter test tool/store/app_store_assets_test.dart --update-goldens \
  --dart-define=LANGS="$langs"

for lang in $(echo "$langs" | tr ',' ' '); do
  for f in docs/app-store/creative-assets/$lang/*.png; do
    tmp="${f%.png}.rgb.png"
    ffmpeg -v error -y -i "$f" -pix_fmt rgb24 "$tmp"
    mv "$tmp" "$f"
  done
  file docs/app-store/creative-assets/$lang/*.png
done
