# Sudoku Sagax — Publishing setup

One-time setup for publishing Sudoku Sagax on Google Play and the App Store,
how to test it on a physical device, and how the store assets are made. The steps for each new release (version
bump, build, upload) are in the [README](../README.md#publishing).

The store id is `com.tekinsight.sudoku` on both stores (iOS bundle id,
Android `applicationId`). The Android `namespace`, Kotlin package and ringer
`MethodChannel` keep the older `com.tekinsight.sudokusagax`; they are internal
and never reach a store. Google Play's first app record was burned on
`com.tekinsight.sudoku_sagax`, so Play uses a new app record for
`com.tekinsight.sudoku`.

## Testing on a physical device

Test a `--release` build on a real iPhone and Android phone before the first
upload (and before each release; see the README's checklist). List what
Flutter can see with `flutter devices`, then run with `-d <device-id>`. Use
**debug** (the default) while developing, for hot reload. Use `--release` to
judge real performance and sound, and to keep the app installed after you
unplug.

**Android**

1. On the phone: *Settings → About phone →* tap **Build number** 7 times, then
   *Settings → System → Developer options →* enable **USB debugging**.
   For a cable-free setup on Android 11+, enable **Wireless debugging** and
   pair with `adb pair <ip>:<port>`.
2. Connect it and accept the "Allow USB debugging?" prompt.
3. Run it:

   ```bash
   flutter run -d <device-id>              # debug, hot reload
   flutter run -d <device-id> --release    # release build
   ```

4. To hand an APK to a tester (they must allow installs from unknown
   sources):

   ```bash
   flutter build apk --release
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

**iOS** (needs a Mac with Xcode)

1. Open `ios/Runner.xcworkspace` in Xcode once. Under *Runner → Signing &
   Capabilities*, keep **Automatically manage signing** with team
   `RC95G6W642`. Xcode registers `com.tekinsight.sudoku` for development.
2. Connect the iPhone/iPad by cable and tap **Trust This Computer**. On iOS
   16+, enable *Settings → Privacy & Security → **Developer Mode*** (the
   device restarts).
3. Run it:

   ```bash
   flutter run -d <device-id> --release
   ```

   On iOS, debug builds can't be opened from the home screen once the device
   is disconnected. Use `--release` (or `--profile`) for standalone play.

**Simulators / emulators:** `open -a Simulator` (iOS) or
`flutter emulators --launch <id>` (Android), then `flutter run`.

**Worth checking by hand on a device:**

- sound with the mute switch on and off (iOS) and in silent mode (Android);
- that the timer pauses when the app goes to the background, and with the
  pause button;
- portrait phones and landscape tablets (in landscape the number pad becomes
  a 3×3 block);
- all 5 languages.

## Google Play (Android)

1. **Upload key.** Sudoku Sagax signs uploads with the company upload keystore
   shared with Memorex, Slidox and MasterCode, and it is already in place
   (`android/key.properties` and `android/app/upload-keystore.jks`, both
   gitignored, never commit them). With Play App Signing, Google holds a
   separate app-signing key for each app; the upload key only proves to
   Google that an upload comes from Tekinsight. On a new machine, copy both
   files from a sister project or the team password manager:

   ```bash
   cp ../slidox/android/app/upload-keystore.jks android/app/
   cp ../slidox/android/key.properties android/
   ```

   `android/key.properties` contains the following; `storeFile` is resolved
   relative to `android/app/`:

   ```properties
   storePassword=<store password>
   keyPassword=<key password>
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```

   [android/app/build.gradle.kts](../android/app/build.gradle.kts) reads it.
   Without it, release builds fall back to the debug key and Gradle warns
   `android/key.properties not found`. **Never upload such a build.** If the
   upload key is ever lost or leaked, the account owner can request an
   upload-key reset in Play Console.

   > Create a separate key for this app only if it may be sold or transferred
   > to another developer on its own:
   > `keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`.
2. In [Play Console](https://play.google.com/console): **Create app** → name
   *Sudoku Sagax: Number Puzzle* (the store name with its search term; see
   [store-listing-texts.md](store-listing-texts.md), ASO note), type *Game*, *Free*. Keep **Play App Signing** on (the
   default).
3. Complete **App content**:
   - privacy policy URL: <https://sudoku.sagax-games.com/privacy.html>
     (the website's privacy page; see the README, "Website");
   - ads: none;
   - content rating questionnaire;
   - target audience;
   - **Data safety**: declare what Firebase Analytics and Crashlytics collect:
     app interactions, crash logs and diagnostics, and app/device identifiers.
     This data is collected for analytics and crash reporting, not shared
     (Firebase acts as a service provider), and encrypted in transit. Options
     and scores never leave the device. Use Google's
     [Firebase data disclosure guide](https://firebase.google.com/docs/android/play-data-disclosure);
     Slidox uses the same SDKs plus Performance, so its answers are a superset.
4. Fill in the **Store listing** (texts from
   [store-listing-texts.md](store-listing-texts.md)):
   - category *Games › Puzzle*;
   - title, short and full description for each of the 8 listings (en-GB,
     en-US, pt-PT, pt-BR, es-ES, es-419, fr-FR, de-DE); add the languages
     beyond the default under *Manage translations → Add your own
     translations*;
   - 512×512 icon: `docs/google-play/icon-512.png`;
   - 1024×500 feature graphic: `docs/google-play/feature-graphic-<lang>.png`,
     one per language (en-US, pt-BR and es-419 use the `en`, `pt` and `es`
     files, as do their screenshots);
   - phone screenshots from `docs/google-play/screenshots/pixel-9-pro/<lang>/`
     and tablet ones from `docs/google-play/screenshots/pixel-tablet/<lang>/`;
   - optional promo video: a YouTube URL (see
     [Store preview video](#store-preview-video)).

> If the developer account is a **personal** account created after November
> 2023, Google requires a closed test with at least 12 testers for 14 days
> before you can apply for production access. Organisation accounts are exempt.

## App Store (iOS)

1. Apple Developer Program membership (team `RC95G6W642`, already set as
   `DEVELOPMENT_TEAM` in Xcode). The App ID `com.tekinsight.sudoku` must
   exist under *Certificates, Identifiers & Profiles → Identifiers*; Xcode's
   automatic signing usually creates it.
2. In [App Store Connect](https://appstoreconnect.apple.com): *Apps → **+** →
   New App*:
   - platform *iOS*;
   - name *Sudoku Sagax: Number Puzzle*, localised per language from
     [store-listing-texts.md](store-listing-texts.md) (store names must be
     unique; the device still shows *Sudoku Sagax*);
   - bundle ID `com.tekinsight.sudoku`;
   - SKU e.g. `sudokusagax`.
3. Complete:
   - **App Privacy**: declare the Firebase data (product interaction, crash
     data, performance and other diagnostic data, device ID), *not linked to
     the user* and *not used for tracking*. See
     [Firebase's App Store guide](https://firebase.google.com/docs/ios/app-store-data-collection),
     or reuse Slidox's answers;
   - **Age Rating**: 4+;
   - category *Games / Puzzle* (secondary *Games / Board*);
   - price *Free*;
   - privacy policy URL: <https://sudoku.sagax-games.com/privacy.html>.
   The app's App Store id is `6820541123`; the website's App Store badge and
   Smart App Banner use it (see the README, "Website").
   `ITSAppUsesNonExemptEncryption` is already `NO` in
   [Info.plist](../ios/Runner/Info.plist), so uploads skip the
   export-compliance question.
4. Fill in each localisation from
   [store-listing-texts.md](store-listing-texts.md): name, subtitle,
   promotional text, keywords and description. Add the localisations beyond
   the primary language from the language menu, using the table at the top
   of that file (es-419 is *Spanish (Mexico)*). On a live app the name,
   subtitle and keywords only change with a new version; the promotional
   text can change at any time.
5. Screenshots, per Apple's
   [screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications)
   (the app supports iPhone and iPad, `TARGETED_DEVICE_FAMILY = 1,2`):
   - **iPhone 6.9"** (1320×2868), **required**:
     `docs/app-store/screenshots/iPhone 17 Pro Max/<lang>/`;
   - **iPhone 6.1"/6.3"** (1206×2622), only if App Store Connect asks for
     it: `docs/app-store/screenshots/iPhone 17 Pro/<lang>/`;
   - **iPad 13"** (2064×2752), **required**:
     `docs/app-store/screenshots/iPad Pro 13-inch/<lang>/`.

   File names are the same in every folder, so check the folder before
   dragging. App previews (videos) are optional; see
   [Store preview video](#store-preview-video).
6. Optional, shown on iOS/iPadOS 27 and later: the **product page header**
   (21:9, 3840×1646) and **search results** asset (3:2, 3840×2560), from
   `docs/app-store/creative-assets/<lang>/header.png` and
   `search-results.png`. In App Store Connect, open the version, then
   *Product Page Information → Header and Search Results*, and upload them
   per localisation. Check them with *Preview* before submitting.
7. Fill in **App Review Information** (*Informações para a equipa de revisão
   de apps*) on the version page (see
   [App Review information](#app-review-information)): no sign-in required,
   so leave the demo account off; contact details, the notes and the screen
   recording.

### App Review information

The answers to App Review's six questions (screen recording, purpose and
audience, setup, external services, regional differences, regulated or
protected material), the steps for the screen recording and the ready-to-paste
*Notes* block live in
[store-listing-texts.md, "App Store Connect — App Review information"](store-listing-texts.md#app-store-connect--app-review-information).

## Store assets

Everything the store listings need, generated from the app's own widgets or
captured from the real app, so it stays in sync with the game.

| Asset | Where | Regenerate with |
|---|---|---|
| Listing texts (name, subtitle, descriptions, keywords, release notes), 8 listings in 5 languages | [docs/store-listing-texts.md](store-listing-texts.md) | by hand |
| Play icon, 512×512 | `docs/google-play/icon-512.png` | `tool/store/app_icon.sh` |
| Play feature graphic, 1024×500, per language | `docs/google-play/feature-graphic-<lang>.png` | `tool/store/feature_graphic.sh` |
| App Store header (3840×1646) and search results (3840×2560), per language | `docs/app-store/creative-assets/<lang>/` | `tool/store/app_store_assets.sh [en,pt,…]` |
| Screenshots, 6 per device and language | `docs/app-store/screenshots/`, `docs/google-play/screenshots/` | `tool/store/screenshots.sh <device> [langs]` |
| Preview video, ~28 s per language | `build/store_video/` (not committed) | `tool/store/video.sh <iphone\|ipad> [langs]` |

The listing texts keep the brain-benefit wording within
[docs/research.md](research.md), like the Info screen, follow the Google Play
Metadata policy note, and stay within each field's length limit (all listed
at the top of the file).

### Store artwork

[tool/store/feature_graphic_test.dart](../tool/store/feature_graphic_test.dart)
and [tool/store/app_store_assets_test.dart](../tool/store/app_store_assets_test.dart)
render the artwork as golden files: the logo, the tagline and a live board
mid-game, with entries, notes and a hint (`showcaseBoard()` in
[tool/store/store_art.dart](../tool/store/store_art.dart)), on the Sagax navy
grid with cyan and violet glows. The feature graphic adds a subline per
language (store copy only, kept in its test file). The shell scripts strip
the alpha channel, which Google Play and App Store Connect reject. Rerun them
after changing the logo, the tagline or the board's look.

The App Store crops its creative assets differently per device; everything
that matters sits inside the centred "Art Safe Area" of Apple's templates
(header 1646×661, search results 2168×1030), and the dimmed boards outside it
are backdrop.

### Store screenshots

[tool/store/screenshots.sh](../tool/store/screenshots.sh) captures six
screenshots per language on a simulator or emulator:

1. home;
2. a game in progress (entries, a hint, notes);
3. the solved grid;
4. the scoreboard;
5. options;
6. info.

```bash
tool/store/screenshots.sh iphone         # iPhone 17 Pro Max (6.9")  → docs/app-store/…
tool/store/screenshots.sh iphone-6.3     # iPhone 17 Pro (6.3")      → docs/app-store/…
tool/store/screenshots.sh ipad           # iPad Pro 13-inch (M5)     → docs/app-store/…
tool/store/screenshots.sh pixel          # Pixel 9 Pro (AVD SudokuSagax_Pixel_9_Pro)  → docs/google-play/…
tool/store/screenshots.sh pixel-tablet   # Pixel Tablet (AVD SudokuSagax_Pixel_Tablet, landscape) → docs/google-play/…
tool/store/screenshots.sh iphone en,pt   # only some languages
```

[integration_test/store_screenshots_test.dart](../integration_test/store_screenshots_test.dart)
plays the game through the real UI. At each scene it prints a marker, and the
script grabs the device screen with `simctl` or `adb`, so the status bar,
icons and emoji are real. The status bar is set to 9:41 with full battery.

Some details of the run:

- The scoreboard is seeded with five earlier results so it isn't empty. The
  game solved during the run takes about 2 minutes on purpose and becomes the
  new best time.
- Firebase and audio are not initialised, so the run is silent and logs
  nothing to Analytics.
- Each language takes about 2 minutes; a full device run takes about 10.
- Run one Android emulator at a time, because the script uses the first one
  `adb` lists.

### Store preview video

[tool/store/video.sh](../tool/store/video.sh) makes a ~28 s preview video per
language from real footage of the app:

```bash
tool/store/video.sh iphone         # App Store iPhone 6.9" app preview (886×1920)
tool/store/video.sh ipad           # App Store iPad 13" app preview (1200×1600)
tool/store/video.sh iphone en,pt   # only some languages
```

Output goes to `build/store_video/<iphone|ipad>/<lang>.mp4` (not committed:
the videos are ~10 MB each). Each language takes about 3 minutes. Needs
`ffmpeg` (`brew install ffmpeg`).

How it is made:

1. [integration_test/store_video_test.dart](../integration_test/store_video_test.dart)
   plays a scripted session: home, the nine levels, entries, notes, a hint,
   the last moves and the win, the new best time and the scoreboard. It
   prints timed cues for scenes, sounds and a jump cut. The cut skips most of
   the grid and lets the clock run, so the final time looks like a person's.
2. The script records the simulator screen with `simctl io recordVideo`.
3. [tool/store/video_captions_test.dart](../tool/store/video_captions_test.dart)
   renders one caption per scene in the app's fonts and colours. The captions
   are store copy in 5 languages; keep them within
   [docs/research.md](research.md) (Sudoku *engages* memory and
   attention, never "improves").
4. [tool/store/compose_video.dart](../tool/store/compose_video.dart) syncs the
   cues to the recording, crops the status bar, and puts the footage on the
   app's navy background under a violet caption band (store art, deliberately
   not the app's colours, so the captions stand out). It adds the jump cut,
   and the app's music and sounds at the app's own volumes (the test run
   itself is silent), normalised to -16 LUFS. The encoding follows Apple's
   app preview spec: 15–30 s, 30 fps, H.264, stereo 256 kbps AAC.

**App Store:** in the version page, under *Previews and Screenshots*, drag the
video into the iPhone 6.9" or iPad 13" slot of each localisation (up to 3 per
device and language). Pick a poster frame, for example the game in progress.

**Google Play:** upload the iPhone video to the Sagax Games YouTube channel
as public or unlisted, with ads off and embedding allowed. Paste the
`https://www.youtube.com/watch?v=…` URL into the store listing's *Video*
field, one per language. A vertical video under 3 minutes may be shown as a
YouTube Short; use the `watch?v=` form of the URL, not `/shorts/`.
