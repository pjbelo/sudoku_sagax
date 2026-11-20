# To Do

## Agreed improvements

These come from the review of the game and of its competitors on 2026-11-16;
the reasons are in [competition.md](competition.md). All of them (A1–A4 and
B1–B9) were agreed on 2026-11-17 and are **done in the app**
(2026-11-17/18, each in its own commit on `develop`). B7 still needs the
store setup; see [Next release](#next-release) below.

Size is a rough guide: S is about a day, M a few days, L a week or more.

### Release plan

The plan was to split them into releases:

1. **Version 1.1:** A1–A4, B1, B2. A1–A4 catch up with the genre; the coach
   and graded levels give the app its identity (the answer to Guideline 4.3).
2. **Version 1.2:** B3, B4, B5. Review and lessons complete the coach; the
   daily puzzle brings players back.
3. **Later:** B6, B7, B8, B9.

All of them are now on `develop`, so the next release carries them all
unless some are held back. Decide which before the store work below: the
screenshots, texts and App Review notes should show what ships, with the
new features first (see [publishing.md](publishing.md)).

### A. Catch up with the genre

Things players expect from any sudoku app. They don't set the app apart, but
their absence is felt.

- ~~**A1. Save and resume (S–M).**~~ Done on 2026-11-17: the game is saved
  after every move, in the background and on Back (which no longer asks);
  Home shows Continue, and Play asks before replacing the saved game.
- ~~**A2. Statistics (S–M).**~~ Done on 2026-11-17, as a Statistics view
  beside Best times on the scoreboard screen: per level, games played (from
  the first move) and solved, best and average time, wins without hints or
  mistakes; and the current and best streak of days with a solved puzzle.
- ~~**A3. Easier entry (S each).**~~ Done on 2026-11-17: digit-first entry
  (a digit with no cell selected lights its key; tapping the selected cell
  again lets go of it); Redo beside Undo; Fill notes in Notes mode (the
  status line becomes the button), always from level 6 and on levels 1–5
  with an option (off by default); vibration on entries, errors (only with
  Show errors) and the win, with an option (on by default).
- ~~**A4. Mark conflicts (S).**~~ Done on 2026-11-17: the "Mark conflicts"
  option (on by default) outlines in red every cell of a clash, givens
  included; Show errors fills, so the two can be told apart when both are on.

### B. Set the app apart

What competitors do badly or not at all. These are also the answer to App
Store Guideline 4.3 ("what does this app offer beyond a standard sudoku?").

- ~~**B1. Logic coach: hints that explain (M–L).**~~ Done on 2026-11-17:
  `lib/game/logic_coach.dart` finds the next step with the simplest named
  technique (hidden and naked single, pointing pair, box-line reduction,
  naked and hidden pair, naked triple, X-Wing; a wrong digit first). The
  Hint button opens a card in place of the keys: where to look, why (cells
  highlighted, candidates shown), then Apply, the only step that costs
  time; it stays until closed. Every step places a digit (eliminations lead
  up to it).
- ~~**B2. Levels graded by technique (M, needs B1).**~~ Done on 2026-11-17:
  each level needs its technique and nothing harder (singles 1–5, pointing
  pairs 6, pairs 7, triples 8, X-Wing 9), so every level is solvable by
  logic, with steps the coach explains. Levels 6–9 come from a graded bank
  (`tool/generate_puzzle_bank.dart`, 100 puzzles a level), shuffled in the
  app. The level summary shows what each level trains ("Hard · pairs").
- ~~**B3. Game review (M, needs B1).**~~ Done on 2026-11-17: a Review
  button on the win summary opens a screen with the techniques the puzzle
  needed (the coach's steps, counted by technique), then each hint and
  mistake with its time and cell; a mistake shows the logical step that was
  available just before it. The events are saved with the game.
- ~~**B4. Guided lessons (M–L, needs B1).**~~ Done on 2026-11-17: eight
  lessons, one per coach technique, each on a real board where that
  technique is the next step. The lesson explains the technique and where
  to look; Show me (or a wrong move) brings the reasoning; the player makes
  the move. Finished lessons are ticked. Home's links open them, and a level
  offers its lesson the first time it is played.
- ~~**B5. Daily puzzle (S–M).**~~ Done on 2026-11-17: one puzzle a day,
  the same for everyone and offline (`lib/game/daily_puzzle.dart`, frozen,
  with a golden test), easier early in the week (Mon level 3 → Sun level 8).
  A Daily button beside Scoreboard opens today's puzzle, the daily streak
  and a month calendar of the days solved; its game is saved apart from
  Continue. To make room, Options moved to the row of small links (Info,
  Lessons, Options, language).
- ~~**B6. Accessibility (M).**~~ Done on 2026-11-17: VoiceOver and
  TalkBack read every cell ("row 3, column 5, 7, given"; "…, empty, notes 2
  4 7"; hint, wrong, conflict) and every key ("5, 3 left"); wrong digits are
  underlined, hints have a corner dot, conflicts an outline; a High contrast
  option (off by default, and on by itself when the system asks for more
  contrast) strengthens the grid lines, notes, highlights and keys. Still
  worth a pass on a real device with VoiceOver and TalkBack on.
- ~~**B7. Game Center and Google Play Games (M).**~~ Done in the app on
  2026-11-17: a best-time leaderboard per level and one for the daily
  puzzle (which now changes at 00:00 UTC, like Game Center's daily
  leaderboard), and 14 achievements (each level, Pure Logic, Seven Days in
  a Row, First Lesson, Lessons Learned, Puzzle of the Day), with images.
  **Still to do in the stores:** create them in App Store Connect
  ([game-center.md](app-store/game-center.md)) and in Play Console, then
  paste the Play IDs into the app
  ([play-games.md](google-play/play-games.md)); test with a Sandbox
  account and a Play tester; mention them in the store texts and the App
  Review notes.
- ~~**B8. Share a puzzle (S).**~~ Done on 2026-11-18: the win summary's
  Share button sends the time and a code that holds the puzzle itself
  (level and givens, base 32 with a check character: 34–48 characters, so
  made to be pasted rather than typed); Home's Code link opens a screen
  where the friend pastes the whole message. A shared puzzle counts in the
  statistics but not on the scoreboard or Game Center. Not done: a link
  that opens the app directly (Universal Links / App Links need files on
  the website and an entitlement), and a shorter code (it would need every
  game made from a frozen seed, like the daily puzzle).
- ~~**B9. Light theme (S–M).**~~ Done on 2026-11-18: a light theme and an
  Appearance option (System / Light / Dark, System by default). Widgets read
  colour tokens by role (`AppColors.of(context)`); the light palette keeps
  the brand's hues, darkened to at least 4.5:1 on white, and is written up
  for the sister apps in [brand-palette.md](brand-palette.md). Home has a
  light logo. The launch screen and store art stay navy; the screenshot and
  video scripts set the simulator to dark (`APPEARANCE=light` for light
  shots). Still to do: bring the palette to Slidox, Memorex and MasterCode.

## Next release

What is left before the agreed improvements reach the stores.

- ~~**Version number.**~~ Done on 2026-11-19: `pubspec.yaml` says
  `1.1.0+4`.
- **Game Center and Play Games setup (B7).** Create the leaderboards and
  achievements in App Store Connect
  ([game-center.md](app-store/game-center.md)) and Play Console, paste the
  Play IDs into the app ([play-games.md](google-play/play-games.md)), and
  test with a Sandbox account and a Play tester.
- **Test on real devices.** Things the tests can't show:
  - VoiceOver and TalkBack on the board, keys and coach card (B6);
  - the light theme and the Appearance option, including the status bar;
  - the share sheet, on iPhone and on iPad, where it must point at the
    button (B8);
  - Game Center and Play Games sign-in, scores and achievements (B7).
- ~~**Store texts and release notes.**~~ Done on 2026-11-19 in
  [store-listing-texts.md](store-listing-texts.md): subtitles, short
  descriptions, promotional texts, keywords and full descriptions in all 8
  listings lead with the logic coach, levels graded by technique, the
  lessons and the game review (Guideline 4.3); the What's new texts, the
  Play release notes block (1.1.0) and the App Review notes and recording
  steps are rewritten. Still to do: have a native speaker read the
  pt-BR, es-419, fr and de texts if possible; add the Play Games lines once
  Play Games is live; and when pasting in App Store Connect, change the
  subtitle and keywords too (they ship with the version).
- **Website features.** The site's features list (`features` in
  `website/js/i18n.js` and `website/index.html`) still describes 1.0 and
  says "free, no ads", and the page's `metaDescription` still reads
  "classic sudoku … notes, hints, a timer and a scoreboard". Bring both in
  line with the new store texts (the coach,
  graded levels, lessons, review, daily puzzle, sharing, accessibility,
  light theme), then rerun `node website/tools/build.js`.
- **Screenshots and video.** Redo them so they show the coach, the lessons
  and the daily puzzle first. Decide whether one screenshot shows the light
  theme (`APPEARANCE=light tool/store/screenshots.sh …`). Do the two items
  under [Store assets](#store-assets) (iPad landscape in every language, the
  old iPhone 17 Pro Max set) in the same pass.
- **Data safety and App Privacy.** Declare Game Center and Play Games
  progress where the stores ask (see the two setup guides).

## Other open items

- **Upload the website.** The privacy page now lists the statistics and the
  game in progress among the data kept on the device, and Game Center and
  Google Play Games among the third-party services (built on 2026-11-17),
  and Benefit 6 no longer claims "reduced stress" (2026-11-18). Upload
  `website/` to the Plesk document root with the next release, after the
  features from the new store texts are in (see Next release).

## Store assets

- **iPad landscape screenshots** (`7_landscape_game`, `8_landscape_home`)
  exist only in English. Run
  `tool/store/screenshots.sh ipad-landscape pt,es,fr,de` (the simulator has
  to be turned to landscape by hand in DeviceHub after each language), or
  drop the two English ones so every language has the same set.
- **iPhone 17 Pro Max screenshots** are the October set: no captions, old
  order. The slot is optional and that simulator isn't installed. Delete
  `docs/app-store/screenshots/iPhone 17 Pro Max/` so they aren't uploaded
  by mistake, or install the simulator and run
  `tool/store/screenshots.sh iphone`.
