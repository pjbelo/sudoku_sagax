#!/bin/sh
# Regenerates the app icon: renders the layers into assets/icons/, writes the
# iOS and Android launcher icons, and the 512×512 Google Play store icon.
set -e
cd "$(dirname "$0")/../.."

flutter test tool/store/app_icon_test.dart --update-goldens
dart run flutter_launcher_icons
# flutter_launcher_icons 0.14 wrongly rewrites this boolean Xcode setting
# with the icon-set name; put it back.
sed -i '' 's/ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = AppIcon;/ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;/' \
  ios/Runner.xcodeproj/project.pbxproj

mkdir -p docs/google-play
sips -z 512 512 assets/icons/icon.png --out docs/google-play/icon-512.png >/dev/null
file docs/google-play/icon-512.png
