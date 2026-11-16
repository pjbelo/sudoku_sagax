# Competition analysis

How Sudoku Sagax 1.0.0 compares with the sudoku apps people already use on
the App Store and Google Play, and where it can be different. The
improvements that follow from this are listed in [todo.md](todo.md).

Checked on 2026-11-16. Store data changes often: re-check ratings, prices and
features before quoting them anywhere. Figures marked *(third party)* come
from review sites or trackers, not from the store page itself.

## Summary

- Sudoku is one of the most crowded genres on both stores. The leaders have
  millions of ratings and years of features behind them.
- **Today Sudoku Sagax is a clean, standard sudoku.** What it has that most
  competitors lack is no ads, puzzles that never need guessing on levels 1–5,
  a research-backed Info screen and layouts for tablets and iPhone Duo. That
  is a thin answer to App Store Guideline 4.3(b) ("indistinguishable from
  what's already widely available").
- It is also **missing things the leading apps have**: saving a game in
  progress, statistics, a daily puzzle and, in the best of them, hints that
  explain the logic.
- The best opening is the one the top apps do badly or not at all: **teaching
  the player to solve by logic**, with levels graded by technique, hints that
  explain, a review of the finished game, and no ads in the way. Good Sudoku
  proved players want this, but it is iPhone-only and rarely updated.
  A second opening is **accessibility**: mainstream sudoku apps largely
  ignore screen readers.

## The competitors

### Sudoku.com (Easybrain) — the market leader

- App Store (US): 4.8 from 1.9 million ratings, 267 MB, 17 languages. Free
  with ads; "No Ads" purchase listed at $14.99.
- Features: several difficulty levels, one solution per puzzle, notes that
  update when a cell is filled, hints, auto-check, duplicate highlighting,
  **Daily Challenges with trophies**, **seasonal events with medals**,
  statistics.
- What players complain about: ads in the middle of a game and ads that take
  several taps to close, the price of removing them, small tap targets, and
  defaults they dislike (instant right/wrong feedback, a three-mistake
  limit).
- Takeaway: wins on habit loops (daily challenge, events, trophies), loses
  on ads. Its store page says nothing about teaching the player.

### Sudoku by Brainium Studios

- App Store (US): 4.7 from 161 thousand ratings, 332 MB. Free with ads;
  "Remove Ads" listed at $11.99.
- Features: five levels, **hints that explain the logic behind the answer,
  with animations**, daily puzzle, statistics, achievements, global and
  friend leaderboards, grid styles and backdrops, light and dark themes,
  notes auto-fill and auto-clear, "number painting" (pick a digit, then tap
  cells), left- or right-handed landscape layout, iPad keyboard support.
- What players complain about: an update that weakened the hint engine (it
  now falls back to trial and error on hard puzzles), ads, and hints that
  name patterns without defining them.
- Takeaway: the strongest all-rounder. Its explained hints are its most
  praised feature, which shows what players value.

### Good Sudoku (Zach Gage, Jack Schlesinger) — the teaching app

- App Store (US): 4.2 from 1.3 thousand ratings, 198 MB. Free with ads;
  full unlock $4.99. Also on Apple Arcade as Good Sudoku+. iOS, iPadOS and
  Mac only. Last updated 2025-07-21.
- Features: **each difficulty level is tied to named techniques**, the
  player can practise a technique on its own and the app tracks which ones
  are learned, hints that adapt to the player's notes, three daily modes with
  global leaderboards, custom puzzle import, Game Center.
- What players complain about: the "Show Me" explanation disappears too
  quickly to learn from, audio bugs, dark mode behind the paywall, a buggy
  automatic candidate assistant, and (from experienced players) too many
  "crutch" features.
- Takeaway: the closest thing to a sudoku coach, and well reviewed by the
  press for it. Not on Android, and slow to fix its bugs.

### Andoku Sudoku 3 — the Android enthusiast's choice

- Google Play: about 2.2 million installs, 4.6 stars *(third party)*. Free
  with ads; a paid version removes them.
- Features: nine difficulty levels, several variants (X, Hyper, Percent,
  Colour), **step-by-step tutorials for solving techniques**, from hidden
  singles to XY-chains, unlimited undo and redo, cloud sync, entering your
  own puzzles, statistics.
- Takeaway: deep and respected, with a plain look. Its tutorials are a
  separate section rather than part of play.

### Others worth knowing

| App | Platform | What it does well | Weak point |
|---|---|---|---|
| Sudoku – The Clean One | Android | Slick, simple interface; auto-save; light and dark *(third party)* | Ads unless you pay; no teaching |
| NYT Games (Sudoku) | Both | Three hand-picked daily puzzles; auto-candidate mode | No statistics or archive for sudoku; the full app needs a subscription |
| Classic Sudoku (Cracking the Cryptic) | Both | 100 hand-made puzzles; hints written by the hosts; paid (about $4.99), no ads | Small, fixed set of puzzles |
| SudokuBlind, Accessible Sudoku, Blindfold Sudoku | iOS | Fully playable with VoiceOver | Niche apps with a basic look; nothing comparable found for TalkBack |

## Feature comparison

"Yes" is confirmed by the store page or the sources below. "Yes*" is how the
app is generally known to work but was not stated in those sources, so
confirm it in the app. "–" means the sources don't mention it; the app may
still have it.

| Feature | Sudoku Sagax 1.0 | Sudoku.com | Brainium | Good Sudoku | Andoku 3 |
|---|---|---|---|---|---|
| Unique solution | Yes | Yes | Yes | Yes | Yes |
| Levels | 9 | 6* | 5 | 5 | 9 |
| Levels graded by solving technique | Levels 1–5 only | – | – | Yes | – |
| Notes | Yes | Yes | Yes | Yes | Yes |
| Auto-fill notes | No | – | Yes | Yes | – |
| Digit-first input | No | Yes | Yes | – | Yes* |
| Undo / redo | Undo only | Undo* | Undo* | – | Both |
| **Save and resume a game** | **No** | Yes* | Yes* | Yes* | Yes |
| **Statistics** | Top 10 times only | Yes | Yes | – | Yes |
| **Daily puzzle** | **No** | Yes | Yes | Yes | – |
| Hints that explain the logic | No (fills a cell) | – | Yes | Yes | – |
| Technique lessons | No | – | – | Yes | Yes |
| Review of the finished game | No | – | – | – | – |
| Online leaderboards / achievements | No | Events | Yes | Yes | – |
| Screen-reader support | No | – | – | – | – |
| Light theme | No | Yes* | Yes | Paid | – |
| Tablet layout | Yes, and foldables | Yes | Yes | Yes | – |
| Research-backed brain-benefit content | Yes | – | – | – | – |
| Ads | **None** | Yes | Yes | Yes | Yes |
| Works offline, no account | Yes | – | – | – | – |
| Download size | 37 MB (iOS build) | 267 MB | 332 MB | 198 MB | – |

## What players complain about

Across store reviews and review round-ups, the same complaints repeat:

1. **Ads.** By far the most common: ads between and during games, ads that
   are hard to close, and ad removal that costs $12–15.
2. **Hints that give the answer, not the reason.** Players praise the apps
   that explain and criticise the ones that don't, or that explain too fast.
3. **Mis-taps counted as mistakes**, with small targets and a mistake limit
   that ends the game.
4. **Bugs left unfixed** in apps that are rarely updated.
5. **Heavy apps**: 200–330 MB for a number puzzle (Sudoku Sagax's iOS
   build is 37 MB).

Sudoku Sagax already avoids 1, 3 and 5. It does not yet answer 2.

## Where Sudoku Sagax stands

**Strengths**

- No ads and no purchases, so nothing interrupts play. (Google Play's
  metadata policy forbids saying "no ads" in the description; it can still
  be shown in screenshots and said on the App Store.)
- Levels 1–5 are generated so that single-step deductions always solve them.
  The player never has to guess.
- Works fully offline, with no account, in five languages.
- The Info screen explains what research says about number puzzles, with
  verified references. No competitor found does this.
- Layouts for tablets, split windows and iPhone Duo; keyboard play.
- No mistake limit, and error marking is off by default.

**Gaps against the standard of the genre**

- **A game in progress is lost** when the player leaves the screen or the
  system closes the app. Players expect a sudoku app to keep it.
- **No statistics** beyond the ten best times per level.
- **No daily puzzle**, the main reason players open the leading apps every
  day.
- **The hint only fills in a number.** It teaches nothing, and the app never
  explains the techniques that levels 7–9 require.
- **Levels 6–9 are graded by the number of clues only.** The generator
  checks that the solution is unique, but not which techniques are needed.
  A level 7 puzzle may need a technique far beyond the player, or in
  practice trial and error, which sits badly with "solved by logic alone".
- Entry is cell-first only, with no redo, no automatic notes and no haptic
  feedback.
- The board is drawn as one picture, so VoiceOver and TalkBack cannot read
  it. Errors are shown by colour alone.
- No online leaderboards or achievements (MasterCode added Game Center).

## Opportunities to be different

Ranked by how much they set the app apart, given what competitors do:

1. **A logic coach inside the game.** A solver that works like a person
   (singles, pairs, pointing, …) lets the hint say *why*: name the
   technique, light up the cells involved, and only then place the digit.
   Brainium and Good Sudoku are praised for this and criticised for doing it
   too quickly or unreliably, so doing it well is a visible advantage. It
   also fits the brand ("sharpen your mind") and the research-backed content.
2. **Levels graded by technique, with a real "no guessing" promise.** With
   the same solver, the generator can guarantee that each level needs the
   techniques it names and nothing harder. The level selector can then show
   what each level trains. Few apps make this promise for every level.
3. **A review of the finished game.** None of the competitors' store pages
   mentions one. After
   a win, show the techniques the puzzle needed, where the hints were used
   and what the logic was at that point. This mirrors the "game review" that
   helped MasterCode pass App Review.
4. **Guided lessons** for each technique, played on the board, with progress
   kept. Andoku and Good Sudoku have them; the two market leaders don't list
   any.
5. **Accessibility.** A board that VoiceOver and TalkBack can read, errors
   marked by shape as well as colour, and a high-contrast option. Mainstream
   sudoku apps largely skip this and the accessible ones are niche.
6. **A daily puzzle that works offline.** The same puzzle for everyone each
   day, generated on the device from the date, with a calendar and streak.
   This is a habit feature every leader has, done here without ads or an
   account.

## App Store Guideline 4.3

Sudoku is exactly the kind of well-established category 4.3(b) describes.
Version 1.0.0 is on the store, but an update or a stricter review can raise
the question again, as it did for MasterCode on 2026-10-30.

Asked plainly, "what does this app offer beyond a standard sudoku?", the
answer today is: no ads, a research-backed Info screen, and layouts for new
devices. That is thin. The coach, technique-graded levels, game review and
lessons above would make the answer strong, and they should lead the
screenshots, the description and the App Review notes once they exist.

## Sources

- [Sudoku.com on the App Store](https://apps.apple.com/us/app/sudoku-com-number-games/id1193508329)
- [Sudoku by Brainium on the App Store](https://apps.apple.com/us/app/sudoku/id418044512)
- [Good Sudoku on the App Store](https://apps.apple.com/us/app/good-sudoku-by-zach-gage/id1489118195)
- [Good Sudoku launch coverage, 9to5Mac](https://9to5mac.com/2020/07/23/good-sudoku-ios-app-launches-to-save-sudoku/)
- [Good Sudoku review, MacStories](https://www.macstories.net/reviews/game-day-good-sudoku/)
- [Andoku Sudoku 3, AppGoblin tracker](https://appgoblin.info/apps/com.andoku.three.gp)
- [Best sudoku apps for Android, Android Authority](https://www.androidauthority.com/best-sudoku-apps-android-97762)
- [NYT Games help: Sudoku](https://thenewyorktimeshelpcenter.helpjuice.com/30467696592148-Sudoku)
- [Classic Sudoku (Cracking the Cryptic) on the App Store](https://apps.apple.com/pl/app/classic-sudoku/id1488838275)
- [SudokuBlind on AppleVis](https://applevis.com/apps/ios/games/sudokublind)
- [Accessible Sudoku on AppleVis](https://www.applevis.com/apps/ios/games/accessible-sudoku)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

Google Play's own pages could not be read for this analysis, so the Android
figures come from third-party sources. Check them in the Play Store.
