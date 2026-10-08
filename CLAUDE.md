# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Sudoku Sagax is a Flutter sudoku game published under the **Sagax Games** brand (developer: Tekinsight). It mirrors the architecture, theme and conventions of its sister apps `../slidox` and `../memorex`. Targets iOS and Android; identifiers are `com.tekinsight.sudokusagax`.

## Commands

```bash
flutter pub get          # install dependencies
flutter run --release    # run on a connected device
flutter analyze          # static analysis (flutter_lints)
flutter test             # unit + widget tests (generator, game model, services, UI flows)
flutter gen-l10n         # regenerate localizations after editing .arb
```

Release signing (Android) reads the gitignored `android/key.properties` + upload keystore; without them release builds fall back to the debug key (fine for `flutter run --release`, rejected by Play). Device testing and store publishing steps are in README.md (`## Testing`, `## Publishing`).

## Architecture

- **`lib/game/`** is pure Dart, with no Flutter imports, and fully unit-tested.
  - `sudoku_generator.dart`: bitmask backtracking solver (`countSolutions`, `solve`), a human-style `solvableWithSingles`, and `generatePuzzle(level, {seed})`. **`sudokuLevels` is the source of truth** for the 9 levels (clue target, band, required `SudokuTechnique`). The level selector reads it directly. Generation takes milliseconds, so it runs synchronously.
  - `sudoku_game.dart`: `SudokuGame` holds values, notes (9-bit masks), hinted/locked cells, mistakes, and undo snapshots. Hints are never undone: `undo()` re-applies hinted cells.
- **`lib/services/`**: singletons, each loaded once in `main()` before `runApp`.
  - `SettingsService` (ChangeNotifier) holds the options and language. Defaults: sound ON, timer ON, show errors OFF, hints ON. The root `MaterialApp` rebuilds on it for locale changes.
  - `ScoreboardService` keeps the top 10 `ScoreEntry`s per level, as JSON in shared_preferences.
  - `AudioService` owns one music player and one SFX player. It plays only when `SettingsService.sound` is on and the device isn't silent. Players are created in `init()`; until then, as in tests, every call is a no-op.
- **`lib/screens/`**: Home → Game / Scoreboard / Options / Info. `GameScreen` owns timing (ticks even when the clock is hidden; +`hintPenaltySeconds` per hint), pause (user and app lifecycle), the win bar and the `_WinSummaryScreen` flow, copied from Slidox.
- **`lib/widgets/`**: `SudokuBoard` (one GestureDetector maps taps to cells; a CustomPainter draws the grid), `NumberPad` (row, or 3×3 in landscape), `LevelSelector`, `SudokuLogo`, `showConfirmDialog`, `fadeRoute`.

## Conventions

- All user-facing strings go through `AppLocalizations.of(context)!`, in 5 locales (en, pt, es, fr, de). `app_en.arb` is the template. Generated `app_localizations*.dart` files are committed; never hand-edit them.
- Use `AppColors` and `sagaxTheme` (`lib/sagax_theme.dart`) rather than new colours. `errorRed` and `hintAmber` are the game's additions.
- Fonts are bundled in `google_fonts/` and runtime fetching is disabled. Only Exo2 400/600/700 and Inter 300/400/500/700 exist; any other weight falls back and logs an exception.
- Fire-and-forget async calls (audio) are wrapped in `unawaited(...)`.
- Some section comments are in Portuguese, as in the sister apps; mirror the surrounding language.
- The Info screen's benefit texts and references must stay within what `docs/research.md` supports (verified citations; associations, not causal claims).

## Firebase

Project `sudoku-sagax-games` (Android + iOS). `main()` initialises Core, Crashlytics (collection off in debug) and Analytics **only on Android/iOS**; desktop and web skip Firebase. Log events with `AnalyticsService.instance.log(name, {…})`, never with `FirebaseAnalytics.instance` directly. It is a no-op until `init()`, which keeps widget tests Firebase-free. Parameter values must be `String`/`num` (bools as 0/1). Regenerate config with `flutterfire configure --project=sudoku-sagax-games --platforms=android,ios`; don't hand-edit `firebase_options.dart`.
