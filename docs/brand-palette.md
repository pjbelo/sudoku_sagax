# Sagax Games palette: dark and light

The Sagax Games apps (Sudoku Sagax, Slidox, Memorex, MasterCode…) share one
look. It started dark only. Sudoku Sagax added the light version on
2026-11-18, planned for the whole brand so the sister apps can use the same
colours. The code is in [lib/sagax_theme.dart](../lib/sagax_theme.dart).

## The two palettes

Widgets ask for a colour by what it is for, not by its name, so the same
code works in both themes: `AppColors.of(context).text`, `.primary`, and so
on.

| Token | What for | Dark | Light |
|---|---|---|---|
| `background` | Behind everything | midnight navy `#0F172A` | mist white `#F1F5F9` |
| `card` | Cards, tiles, dialogs, the board | card dark `#1E293B` | paper white `#FFFFFF` |
| `primary` | Buttons, links, the player's digits, highlights | electric cyan `#38BDF8` | deep cyan `#0369A1` |
| `onPrimary` | Text and icons on a `primary` or `hint` fill | midnight navy `#0F172A` | paper white `#FFFFFF` |
| `text` | Main text, the puzzle's given digits | snow white `#F8FAFC` | midnight navy `#0F172A` |
| `muted` | Secondary text, thin lines, notes | soft slate `#94A3B8` | slate grey `#475569` |
| `error` | Wrong digits, clashes | error red `#EF4444` | deep red `#B91C1C` |
| `hint` | Hints, the coach's candidates | hint amber `#FFC107` | deep amber `#B45309` |

The light colours keep the dark ones' hues, darkened until they read well
on white. The bright cyan and amber of the dark theme can't be used for text
on white: electric cyan reaches only about 2:1 there.

## Contrast

These are WCAG contrast ratios. AA asks for 4.5:1 for normal text and 3:1
for large text.

| Light token | On card (white) | On background |
|---|---|---|
| `text` | 17.9 | 16.3 |
| `muted` | 7.6 | 6.9 |
| `primary` | 5.9 | 5.4 |
| `error` | 6.5 | 5.9 |
| `hint` | 5.0 | 4.6 |

White on `primary` is 5.9:1 and white on `hint` is 5.0:1.

In the dark theme, `error` red on a card is 3.9:1. That is enough for the
bold digits it colours, and wrong digits also carry an underline, so colour
is never the only signal.

## What stays dark

- **Launch screen.** Navy with the logo on both platforms. It is the brand's
  splash, and the app's first screen follows straight after.
- **Store art.** The app icon, the feature graphic and the Game Center
  images use `SagaxPalette`, the raw brand colours.
- **Screenshots and video.** `tool/store/screenshots.sh` and `video.sh` set
  the simulator or emulator to dark first.
  `APPEARANCE=light tool/store/screenshots.sh …` captures the light theme,
  for example for one store screenshot that shows it.

## Logo

The home screen logo has two renders from
[lib/widgets/sudoku_logo.dart](../lib/widgets/sudoku_logo.dart):

- `sudoku-sagax-transp.png` for dark, with white lettering;
- `sudoku-sagax-transp-light.png` for light, with navy lettering and white
  cells.

`flutter test tool/store/logo_test.dart --update-goldens` makes both. The
Sagax Games logo on the Info screen is a dark picture and stays as it is: it
reads as a badge on the light theme too.

## For a sister app

1. Copy `SagaxPalette`, `AppColors` and `_buildTheme` from `sagax_theme.dart`.
   Each app adds its own extra tokens next to these (Sudoku's `error` and
   `hint` started that way).
2. In `MaterialApp`, set `theme: sagaxLightTheme`, `darkTheme: sagaxTheme`
   and `themeMode: ThemeMode.system`. Add the `AnnotatedRegion` for the
   status bar from `main.dart`, for screens without an app bar.
3. Replace each `AppColors.<colour>` constant with the token for what it is
   for. Text on a cyan fill is `onPrimary`, not `background`.
4. Render a light version of the app's logo if its lettering is white.
5. Set the simulators to dark in the screenshot scripts.
