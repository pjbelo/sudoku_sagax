# Sudoku Sagax

A Flutter sudoku game published under the **Sagax Games** brand (developer:
Tekinsight — Information Technologies). Nine difficulty levels, notes, timer,
hints, an options screen and a local scoreboard. It shares architecture, UI and
design with its sister games **Memorex** and **Slidox**.

Targets **iOS** and **Android**.

- App title: `Sudoku Sagax`
- Bundle id / applicationId: `com.tekinsight.sudokusagax`
- Version: see `version:` in [pubspec.yaml](pubspec.yaml) (currently `1.0.0+1`)

## Gameplay

- **9 levels** in 5 bands (Beginner → Expert), from 46 givens down to 24.
  Every puzzle is generated on the fly and has exactly **one solution**.
  Levels 1–5 can be solved with "singles" alone; levels 7–9 always need
  candidate elimination. See [docs/research.md](docs/research.md) for the
  rationale.
- Pick a cell, then a number. Entering the same number again clears the cell.
  Placing a number removes it from the notes in its row, column and box.
- **Notes** mode pencils in candidates as a 3×3 mini-grid in the cell.
- **Undo** and **Erase**. The number pad shows how many of each digit are left.
- **Timer** with pause. The clock also stops when the app goes to the background.
- **Hint** fills in a correct number (the selected cell, or a random open one)
  at a cost of **+30 s**.
- **Scoreboard**: the top 10 times per level, with hints and mistakes. Ranked by
  time, then hints, then mistakes.
- Keyboard play on desktop and tablets: digits, Backspace/Delete, arrow keys,
  `N` for notes.
- Portrait layout for phones; side-by-side layout with a 3×3 keypad in landscape.

### Options

| Option | Default | Effect |
|---|---|---|
| Sound | **ON** | Music and sound effects |
| Timer | **ON** | Shows the clock (time is always recorded for the scoreboard) |
| Show errors | **OFF** | Marks wrong numbers in red and shows a Mistakes counter |
| Hint button | **ON** | Shows the Hint (+30 s) button |

Options, the chosen language and the scoreboard persist across restarts
(`shared_preferences`).

## Getting started

```bash
flutter pub get
flutter run --release        # run on a connected device
flutter analyze              # static analysis (flutter_lints)
flutter test                 # unit + widget tests
```

Requires the Flutter stable channel with Dart SDK `^3.13.5` (developed against
Flutter 3.47.x).

## Project layout

```
lib/
  main.dart                    Loads settings/scoreboard/audio, then SudokuSagaxApp (locale from settings)
  sagax_theme.dart             AppColors palette + global dark sagaxTheme (shared with Slidox/Memorex)
  game/
    sudoku_generator.dart      Pure Dart: solver, singles solver, generator, the 9 `sudokuLevels`
    sudoku_game.dart           Game state: entries, notes, hints, mistakes, undo; formatTime
  services/
    audio_service.dart         Singleton: looping BGM + low-latency SFX, Sound option + silent mode
    settings_service.dart      Options + language (ChangeNotifier, persisted)
    scoreboard_service.dart    Top-10 times per level (persisted)
  screens/
    home_screen.dart           Logo, 3×3 level selector, Play, Scoreboard, Options, Info, language
    game_screen.dart           Board, stats, controls, number pad, pause, win bar + summary
    options_screen.dart        The four switches + Restore defaults
    scoreboard_screen.dart     Per-level best times
    info_screen.dart           How to play, Brain Benefits, scientific references, credits
  widgets/                     SudokuBoard, NumberPad, LevelSelector, SudokuLogo, confirm dialog, fade route
  l10n/                        .arb sources + generated AppLocalizations
assets/                        images (Sagax logo), musics, sounds
google_fonts/                  Bundled Exo 2 + Inter (no runtime font downloads)
docs/research.md               Scientific background and level-design notes
```

### Theming

Use the `AppColors` constants and `sagaxTheme` from
[lib/sagax_theme.dart](lib/sagax_theme.dart). Fonts come from `google_fonts`,
bundled in `google_fonts/`: **Exo 2** (Regular/SemiBold/Bold) for headings and
digits, **Inter** (Light/Regular/Medium/Bold) for body text. A new weight needs
its `.ttf` added there first.

The logo is drawn in code ([lib/widgets/sudoku_logo.dart](lib/widgets/sudoku_logo.dart))
until a designed PNG exists, like `slidox-transp.png`.

### Audio

[`AudioService`](lib/services/audio_service.dart) owns one music player and one
SFX player. Playback is gated on the **Sound** option and on silent mode. iOS
uses the `ambient` category (respects the mute switch). Android polls ringer
mode over `MethodChannel('com.tekinsight.sudokusagax/ringer')`, implemented in
[MainActivity.kt](android/app/src/main/kotlin/com/tekinsight/sudokusagax/MainActivity.kt).

## Localization

Uses Flutter's `gen-l10n` (configured by [l10n.yaml](l10n.yaml)).

- Source strings: `lib/l10n/app_<locale>.arb`; `app_en.arb` is the template.
- Supported locales: **en, pt, es, fr, de**.
- `app_localizations*.dart` are generated and committed. After editing any
  `.arb`, run `flutter gen-l10n`.

## Not yet done

- **Firebase** (Analytics/Crashlytics, as in Memorex/Slidox). There is no
  Firebase project for this app yet. Create one, run
  `flutterfire configure --project=<id>`, then wire it up in `main.dart`.
- **App icon** and logo PNG: the launcher icons are still Flutter's defaults.
- **Release signing** (`android/key.properties` + keystore), store listing
  copy (`docs/`, like `slidox/docs/slidox.md`) and the website.

## Credits

**Music** — *Solar Sail* by Vitalezzz —
<https://opengameart.org/content/solar-sail>

**Sounds** — *Digital Audio* by Kenney Vleugels (Kenney.nl) —
<https://kenney.nl/assets/digital-audio>

Audio license: Creative Commons CC0 1.0.

## Original design brief (prompt)

Create a sudoku game named "Sudoku Sagax". Analyse memorex and slidox games and use similar architecture, UI and design. Investigate what are the main scientific papers that aply to benefits of sudoku type games. The game should have 9 dificulty levels, should have a timer, should have "notes" option (when notting the user can write small numbers in a cell, representing the possible numbers). As options screen with: sound ON/off; timer ON/off; show error (true/FALSE) if a wrong number is inserted; hint button (ON/off) a button to insert a correct number; defaults in CAPS. The game should have a scoreboard.
