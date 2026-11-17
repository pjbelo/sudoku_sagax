# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Sudoku Sagax is a Flutter sudoku game published under the **Sagax Games** brand (developer: Tekinsight). It mirrors the architecture, theme and conventions of its sister apps `../slidox` and `../memorex`. Targets iOS and Android; the store id (iOS bundle id and Android `applicationId`) is `com.tekinsight.sudoku`. The Android `namespace`, Kotlin package and the ringer `MethodChannel` keep the older `com.tekinsight.sudokusagax` — internal only, leave them. Google Play's first app record was burned on `com.tekinsight.sudoku_sagax`; Play uses a new app record for `com.tekinsight.sudoku`.

## Commands

```bash
flutter pub get          # install dependencies
flutter run --release    # run on a connected device
flutter analyze          # static analysis (flutter_lints)
flutter test             # unit + widget tests (generator, game model, services, UI flows)
flutter gen-l10n         # regenerate localizations after editing .arb
```

Release signing (Android) reads the gitignored `android/key.properties` + upload keystore; without them release builds fall back to the debug key (fine for `flutter run --release`, rejected by Play). Device testing, one-time store setup and the store-asset workflow live in `docs/publishing.md`; per-release steps in README.md, `## Publishing`.

## Architecture

- **`lib/game/`** is pure Dart, with no Flutter imports, and fully unit-tested.
  - `sudoku_generator.dart`: bitmask backtracking solver (`countSolutions`, `solve`), a human-style `solvableWithSingles`, and `generatePuzzle(level, {seed})`. **`sudokuLevels` is the source of truth** for the 9 levels (clue target, band, `SudokuTechnique`: the hardest technique the level needs, with nothing harder). The level selector reads it directly. Levels 1–5 (singles) are dug on the spot; levels 6–9 take a puzzle from `puzzle_bank.dart` and `shufflePuzzle` it (digits renamed, rows/columns/bands reordered, maybe transposed: the logic needed doesn't change). Both take under a few milliseconds, so generation runs synchronously.
  - `puzzle_bank.dart` is **generated** by `dart run tool/generate_puzzle_bank.dart [per level]` (graded with `hardestTechnique` and `meetsLevel`; level 9 takes about 10 s a puzzle, too slow for the app). Never hand-edit it, and keep it fixed once shipped: the daily puzzle (B5) will pick from it by date.
  - `sudoku_game.dart`: `SudokuGame` holds values, notes (9-bit masks), hinted/locked cells, mistakes, and undo/redo snapshots. Hints are never undone: `undo()` and `redo()` re-apply hinted cells; any new change (a hint too) empties the redo stack. `fillNotes()` writes `candidates(i)` into every empty cell as one undo step.
  - `logic_coach.dart`: the logic coach. `findCoachStep(game, preferred:)` returns the next `CoachStep`: a wrong digit first (logic from a wrong grid would mislead), else a hidden or naked single, else the simplest elimination that opens a single (pointing pair, box-line reduction, naked pair, hidden pair, naked triple, X-Wing, in that order), else a pruned chain of them, else a digit `fromSolution`. Candidates come from the digits on the board, never from the player's notes. `eliminationsFor(technique, candidates)` exposes each technique for tests and for level grading.
  - `game_review.dart`: `ReviewEvent` (a hint, or a mistake with the coach step that was available just before it) and `techniquesNeeded(puzzle)` (the coach's steps from the givens, counted by technique).
- **`lib/services/`**: singletons, each loaded once in `main()` before `runApp`.
  - `SettingsService` (ChangeNotifier) holds the options and language. Defaults: sound ON, timer ON, show errors OFF, hints ON, left-handed OFF, fill notes on easy levels OFF, vibration ON, mark conflicts ON. Fill notes is always offered from level 6 (`fillNotesAt`). The root `MaterialApp` rebuilds on it for locale changes.
  - `ScoreboardService` keeps the top 10 `ScoreEntry`s per level, as JSON in shared_preferences.
  - `SavedGameService` keeps the one game in progress (`SudokuGame.toJson()` + the clock, with a format `version`) as JSON in shared_preferences. `savedGame` returns a new copy on every read. The undo history is not saved; the review events are (an older save without them reads as none).
  - `StatisticsService` keeps a `LevelStats` per level (games started at the first move, solved, total and best time, wins without hints or mistakes) and the day streak (days in a row with a solved puzzle; it survives until the end of the day after the last win). Days are compared as UTC dates built from the local date, so daylight saving time doesn't matter.
  - `AudioService` owns one music player and one SFX player. It plays only when `SettingsService.sound` is on and the device isn't silent. Players are created in `init()`; until then, as in tests, every call is a no-op.
- **`lib/screens/`**: Home → Game / Scoreboard / Options / Info. `GameScreen` owns timing (ticks even when the clock is hidden; +`hintPenaltySeconds` per hint), pause (user and app lifecycle), the win bar and the `_WinSummaryScreen` flow, copied from Slidox.
  - Hints go through the logic coach: `CoachCard` (`lib/widgets/coach_card.dart`, which also builds the localised texts) covers the controls and keys at their size (`_buildEntryArea`, so nothing moves) in three stages: where to look, why (the board's `BoardHighlight`: area, pattern and target, cells losing candidates in red, the candidates shown in amber), then Apply. Only Apply costs `hintPenaltySeconds` and counts as a hint (`SudokuGame.applyHint`, which also takes the ruled-out candidates out of the notes). Entries wait while the card is open. In a scrolling side panel the card is capped to what is in view (`maxCardHeight`), so its buttons never sit below the screen.
  - Review: `GameScreen` records a `ReviewEvent` for every hint applied and every wrong digit (with `findCoachStep` run just before it), saves them with the game, and the win summary's Review button opens `ReviewScreen`.
  - Entry works both ways: a cell then a digit, or a digit first (`_activeDigit`, a lit key) then the cells; tapping the selected cell again lets go of it, and arrow keys go back to cell-first. In Notes mode the status line becomes the Fill notes button when `fillNotesAt(level)`. Vibration (`_vibrate`) follows the option; a wrong digit only vibrates (and sounds) differently with Show errors on.
  - Save and resume: `GameScreen` saves after every move, when the app goes to the background and on Back (so leaving needs no confirmation). It clears the save when a game is solved or a new one starts. Home shows Continue while there is a save: under Play in one column, under the brand in two panes. Play asks before replacing a save.
  - `ScoreboardScreen` switches between Best times and Statistics (`showStatistics`), with one level selector for both; each view has its own clear button.
- **`lib/widgets/`**: `SudokuBoard` (one GestureDetector maps taps to cells; a CustomPainter draws the grid; Mark conflicts outlines clashing cells with `SudokuGame.hasConflict`, an outline rather than Show errors' red fill), `NumberPad` (row, or 3×3 in landscape), `LevelSelector`, `SudokuLogo`, `showConfirmDialog`, `fadeRoute`.
- **Large screens** (`lib/widgets/adaptive_layout.dart`): every size comes from the window, not the device, so iPad Split View and Stage Manager get the layout that suits their space.
  - `uiScaleOf` is 1 on phones and iPhone Duo and grows to 1.3 on large tablets. `LargeScreenText` (`MaterialApp.builder`) applies it to all text, on top of the system text size; text sized from a shape (board, number pad, level chips) opts out with `MediaQuery.withNoTextScaling`.
  - `TwoPaneLayout` splits a screen around a fold or in a wide window, `CenteredPane` centres content and scrolls from the empty margins too, `TwoColumnCards` pairs cards. `isCompactHeight` tells screens to tighten up.
  - `GameScreen` sizes the board from the space left by the other rows, and the 3×3 keys fill the panel's height. In a wide window (`_sideBySide`, width > 1.1 × height) it drops the `AppBar` so the board gets the full height, and Back and Pause go to the top of the panel; the Left-handed option puts that panel on the left (also when the Duo is folded like a book).
- **iPhone Duo** (`lib/widgets/duo_layout.dart`, as in MasterCode): `FoldableProvider` (package `foldable`) wraps the app in `main.dart`; elsewhere it reports no hinge and nothing changes.
  - Where the safe area has a side strip (the outer display, and the inner one in landscape), `RailBar` holds Back, the stats and Pause on `GameScreen`, and Info and the language on `HomeScreen`, below the camera (`sideRailOf`), following Apple's "vertical controls".
  - While partly folded (`foldAcross`, which trusts the posture because a region can stay active just after laying flat), `FoldPanes` splits the game, home, scoreboard, options and win summary around the fold. Folded like a laptop (`isLaptopPose`), `GameScreen` drops the `AppBar` to give the board the whole upper half.
  - `bridgeMode: full` (iOS only; Android reports display features itself) keeps dialogs and bottom sheets on one side of the fold.
  - Real geometry (simulator): outer 466×678 pt (84 pt right strip, camera to y 174); inner 951×669 landscape / 669×951 portrait, fold 40 pt wide at the centre. `test/layout_test_helpers.dart` holds these windows and feeds the fold states through `FoldableProvider(debugData:)`. The simulator can't be folded from the command line (DeviceHub only).

## Conventions

- All user-facing strings go through `AppLocalizations.of(context)!`, in 5 locales (en, pt, es, fr, de). `app_en.arb` is the template. Generated `app_localizations*.dart` files are committed; never hand-edit them. iOS declares the same locales in `CFBundleLocalizations` (`ios/Runner/Info.plist`), which feeds the App Store's Languages list; add any new locale there too.
- Use `AppColors` and `sagaxTheme` (`lib/sagax_theme.dart`) rather than new colours. `errorRed` and `hintAmber` are the game's additions.
- Fonts are bundled in `google_fonts/` and runtime fetching is disabled. Only Exo2 400/600/700 and Inter 300/400/500/700 exist; any other weight falls back and logs an exception.
- Fire-and-forget async calls (audio) are wrapped in `unawaited(...)`.
- Some section comments are in Portuguese, as in the sister apps; mirror the surrounding language.
- The Info screen's benefit texts and references must stay within what `docs/research.md` supports (verified citations; associations, not causal claims).

## Firebase

Project `sudoku-sagax-games` (Android + iOS). `main()` initialises Core, Crashlytics (collection off in debug) and Analytics **only on Android/iOS**; desktop and web skip Firebase. Log events with `AnalyticsService.instance.log(name, {…})`, never with `FirebaseAnalytics.instance` directly. It is a no-op until `init()`, which keeps widget tests Firebase-free. Parameter values must be `String`/`num` (bools as 0/1). Regenerate config with `flutterfire configure --project=sudoku-sagax-games --platforms=android,ios`; don't hand-edit `firebase_options.dart`. The Xcode phase *FlutterFire: "flutterfire upload-crashlytics-symbols"* carries a hand patch (it checks `${SRCROOT}/../build/ios/SourcePackages` for Crashlytics' `run` script, needed for `flutter build ipa` with a custom DerivedData location); re-apply it after any `flutterfire configure`.

## Website (`website/`)

Static HTML/CSS/vanilla JS site for `sudoku.sagax-games.com`, structured like the Slidox/Memorex/MasterCode sites. It has one build step: `node website/tools/build.js` (no dependencies) writes a static page per language from `js/i18n.js`. The root `index.html`, `privacy.html` and `contact.html` are the English pages and the templates (`data-i18n*` attributes, dotted keys into arrays); `pt/`, `es/`, `fr/`, `de/` and `sitemap.xml` are generated, so never edit them: edit the templates or `i18n.js`, then rerun the build and upload `website/` to the Plesk document root. `js/i18n.js` is read only by the build and holds all strings for the 5 locales — benefit texts, evidence note, tagline, bands and game labels are copied from the `.arb` files, features from `docs/store-listing-texts.md`; keep them in sync. `LEVELS` in `tools/build.js` mirrors `sudokuLevels`. `js/sudoku.js` is a playable Beginner puzzle whose generator mirrors `lib/game/sudoku_generator.dart` (46 givens, singles-solvable, unique); it reads its strings from `script#demo-text`, written by the build. The privacy page must describe exactly the app's data collection (Firebase Analytics + Crashlytics; options, scores, statistics and the game in progress stay on device). The App Store id is `6820541123` (badge link and `apple-itunes-app` meta in `index.html`).

## App Store Guideline 4.3 (Spam)

Check this app against [Guideline 4.3](https://developer.apple.com/app-store/review/guidelines/) (and 4.2, Minimum Functionality) when planning features and before every submission; re-read the page, as Apple updates it.

- **4.3(a):** don't submit multiple Bundle IDs of the same app; put variations (locations, themes, levels) inside one app.
- **4.3(b):** apps "indistinguishable from what's already widely available" are rejected; crowded categories need "a meaningfully different or improved experience".
- **Why:** MasterCode (Sagax Games) was rejected under 4.3(a) on 2026-10-30 as too similar to existing code-breaking apps. It was resubmitted with a deduction coach and game review, guided lessons, a classic-variant skin, Game Center and iPhone Duo layouts. Sister apps share one architecture and look, so each must stand on its own features.
- **How:** ask what makes the app meaningfully different from what's already on the store, and say so if the answer is thin. Prefer visible differentiators (coaching, analysis of the player's play, original modes, accessibility, platform features, research-backed content), and make them prominent in the screenshots, the description and the App Review notes.

## My Preferences

Allways use english in code comments, but also in class names, methods names, functions, variables, so english team members can understand the project.

Allways use simple code that a beguinner developer could understand. If there is any situation you think more advanced code could improve very much code performance, say it and ask if you should implement it.

Never commit. When you think a commit should be done, suggest it and suggest a commit message (in english).
