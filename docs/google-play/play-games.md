# Google Play Games setup (Play Console)

Sudoku Sagax reports to Google Play Games on Android: a best-time
leaderboard per level (9), a daily-puzzle leaderboard and 14 achievements,
the same as Game Center on iOS. The names, descriptions, points and images
are in [game-center.md](../app-store/game-center.md); this guide covers what
differs in Play Console.

**Android stays off until the Play Games IDs are filled in.** While
[lib/game/play_games_ids.dart](../../lib/game/play_games_ids.dart) is empty,
`GamesService` never calls Play Games, and `MainActivity` only starts the
Play Games SDK when `game_services_project_id` in
`android/app/src/main/res/values/play_games.xml` is set. (The library's own
start-up provider is removed in the manifest, so an unconfigured app never
touches Play Games.)

## 1. Create the Play Games project

1. Play Console → Sudoku Sagax → **Grow users → Play Games Services → Setup
   and management → Configuration** → *No, my game doesn't use Google APIs*
   → create a new Play Games Services project (or use the Google Cloud
   project that Firebase already created, `sudoku-sagax-games`).
2. **Properties:** display name Sudoku Sagax, category Puzzle, the same
   description and graphics as the store listing.
3. **Credentials → Add credential → Android:** package
   `com.tekinsight.sudoku`, and the **SHA-1 of the app signing key** (Play
   Console → Test and release → App integrity → App signing). Add a second
   Android credential with the **upload key's SHA-1**, and one with the
   **debug key's SHA-1**
   (`keytool -list -v -keystore ~/.android/debug.keystore -storepass android`)
   to test local builds. Without the right SHA-1, sign-in fails silently.
4. **Testers:** add your Google account(s). Until the Play Games project is
   published, only testers can sign in.

## 2. Leaderboards

The same ten as Game Center: name in English, then add the other languages
under each leaderboard's *Translations* (texts in
[game-center.md, section 2](../app-store/game-center.md#2-leaderboards)).

| Name (en) | Format | Ordering | Limits |
|---|---|---|---|
| Level 1: Best Time … Level 9: Best Time | Time | Smaller is better | none |
| Daily Puzzle: Best Time | Time | Smaller is better | none |

Play's **Time** format takes milliseconds; the app sends the time × 1000
(Game Center gets seconds). Leave the icon empty or use the app icon.

Play Games has no recurring leaderboards: Daily Puzzle is a normal one, and
players use its **Today** tab. That tab resets at midnight Pacific Time, not
at 00:00 UTC when the daily puzzle changes, so for a few hours it can mix
two days' puzzles.

## 3. Achievements

The 14 achievements of
[game-center.md, section 3](../app-store/game-center.md#3-achievements),
with the same names, descriptions (Play has one description per
achievement), points and order. Play wants 512×512 icons: use
[play-games/](play-games/) (the same images, made by
`tool/store/game_center_art.sh`). None are hidden or incremental.

## 4. Paste the IDs into the app

1. **Get resources** (Achievements or Leaderboards page) shows every ID, plus
   the project ID as `app_id`.
2. Put the project ID in `android/app/src/main/res/values/play_games.xml`
   (`game_services_project_id`).
3. Fill in [lib/game/play_games_ids.dart](../../lib/game/play_games_ids.dart):
   each `Award` with its Play achievement ID, and each Game Center
   leaderboard ID (`sudokusagax.leaderboard.level_1` … `level_9`, `.daily`)
   with its Play leaderboard ID. Fill in all of them or none:
   `test/awards_test.dart` checks it.
4. Build, sign in as a tester, solve a puzzle and open the scoreboard's
   Leaderboards and Achievements buttons.

## 5. Publish and declare

1. **Publish** the Play Games project (Setup and management → Publishing).
   Leaderboards and achievements can't be deleted once published.
2. **Data safety:** declare that, when the player signs in, game progress
   (scores, achievements) is shared with Google Play Games. The privacy
   policy on the website already says so.
3. Add a "Google Play Games" line to each Play listing's features
   ([store-listing-texts.md](../store-listing-texts.md)).
