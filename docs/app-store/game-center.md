# Game Center setup (App Store Connect)

Sudoku Sagax reports to Game Center on iOS: a best-time leaderboard per
level (9), a daily-puzzle leaderboard and 14 achievements. Google Play Games
on Android has its own guide, [play-games.md](../google-play/play-games.md),
which reuses the names, texts, points and images below.

The IDs are hard-coded in [lib/game/awards.dart](../../lib/game/awards.dart)
and must match App Store Connect exactly. **An ID can never be reused once
created, even after deleting it**, so copy them as they are.

The app needs nothing else: the Game Center entitlement is in
`ios/Runner/Runner.entitlements` (linked from the Runner target), and
Xcode's automatic signing adds the capability to the App ID on the next
archive.

## 1. Turn Game Center on

1. App Store Connect → Sudoku Sagax → **Features → Game Center** → set up
   Game Center for the app (a single app, not a group).
2. In the **version being submitted** (iOS App → the new version), tick
   **Game Center** and add the 10 leaderboards and 14 achievements below.
   Items that aren't attached to a version stay invisible to players.

## 2. Leaderboards

The nine level leaderboards are **Classic**; the daily one is **Recurring**
(below). All use:

- **Score format type:** Elapsed Time – To the Second (the app sends whole
  seconds, hint penalties included; Game Center shows them as `12:34`).
- **Score submission type:** Best Score.
- **Sort order:** Low to High.
- **Score range:** 1 to 86400 (a day).
- No score suffix: the time format already reads as a time.

| Reference name | Leaderboard ID |
|---|---|
| Level 1 – best time | `sudokusagax.leaderboard.level_1` |
| Level 2 – best time | `sudokusagax.leaderboard.level_2` |
| Level 3 – best time | `sudokusagax.leaderboard.level_3` |
| Level 4 – best time | `sudokusagax.leaderboard.level_4` |
| Level 5 – best time | `sudokusagax.leaderboard.level_5` |
| Level 6 – best time | `sudokusagax.leaderboard.level_6` |
| Level 7 – best time | `sudokusagax.leaderboard.level_7` |
| Level 8 – best time | `sudokusagax.leaderboard.level_8` |
| Level 9 – best time | `sudokusagax.leaderboard.level_9` |
| Daily puzzle – best time | `sudokusagax.leaderboard.daily` |

**Daily puzzle** is a **Recurring** leaderboard: start date any day at
**00:00 UTC**, duration **1 day**, restarts **every day**. The app's daily
puzzle changes at 00:00 UTC too (`dailyToday()` in
`lib/game/daily_puzzle.dart`), so each occurrence ranks one puzzle.

### Localized names

Replace `N` with the level number (1–9).

| Language | Levels | Daily |
|---|---|---|
| English | Level N: Best Time | Daily Puzzle: Best Time |
| Portuguese | Nível N: melhor tempo | Puzzle diário: melhor tempo |
| Spanish | Nivel N: mejor tiempo | Puzle diario: mejor tiempo |
| French | Niveau N : meilleur temps | Grille du jour : meilleur temps |
| German | Level N: Bestzeit | Tagesrätsel: Bestzeit |

Use the Portuguese texts for both Portuguese localizations, the Spanish
ones for both Spanish localizations and the English ones for every English
localization. The leaderboard image is optional; leave it empty.

## 3. Achievements

None are hidden, and none can be earned more than once. Points add up to
330 (the limit is 1000, which leaves room for more later). The images are
in [game-center/](game-center/), named after the key (1024×1024, no alpha;
regenerate with `tool/store/game_center_art.sh`). Each localization needs
the image, so attach the same one in every language.

| Reference name | Achievement ID | Points | Image |
|---|---|---|---|
| Level 1 Solved | `sudokusagax.achievement.level_1` | 5 | `level_1.png` |
| Level 2 Solved | `sudokusagax.achievement.level_2` | 5 | `level_2.png` |
| Level 3 Solved | `sudokusagax.achievement.level_3` | 10 | `level_3.png` |
| Level 4 Solved | `sudokusagax.achievement.level_4` | 10 | `level_4.png` |
| Level 5 Solved | `sudokusagax.achievement.level_5` | 15 | `level_5.png` |
| Level 6 Solved | `sudokusagax.achievement.level_6` | 20 | `level_6.png` |
| Level 7 Solved | `sudokusagax.achievement.level_7` | 30 | `level_7.png` |
| Level 8 Solved | `sudokusagax.achievement.level_8` | 40 | `level_8.png` |
| Level 9 Solved | `sudokusagax.achievement.level_9` | 50 | `level_9.png` |
| Pure Logic | `sudokusagax.achievement.no_hints` | 30 | `no_hints.png` |
| Seven Days in a Row | `sudokusagax.achievement.seven_days` | 40 | `seven_days.png` |
| First Lesson | `sudokusagax.achievement.first_lesson` | 10 | `first_lesson.png` |
| Lessons Learned | `sudokusagax.achievement.all_lessons` | 50 | `all_lessons.png` |
| Puzzle of the Day | `sudokusagax.achievement.daily` | 15 | `daily.png` |

Each localization asks for a title, a pre-earned description and an earned
description. The descriptions below work for both; paste the same text
twice. Use the same language mapping as for the leaderboards. For the nine
levels, replace `N` with the level number.

### English

| ID key | Title | Description |
|---|---|---|
| level_N | Level N Solved | Solve a puzzle on level N. |
| no_hints | Pure Logic | Solve a puzzle of level 6 or harder without a hint. |
| seven_days | Seven Days in a Row | Solve a puzzle on 7 days in a row. |
| first_lesson | First Lesson | Finish a lesson. |
| all_lessons | Lessons Learned | Finish all the lessons. |
| daily | Puzzle of the Day | Solve a daily puzzle. |

### Portuguese

| ID key | Title | Description |
|---|---|---|
| level_N | Nível N resolvido | Resolver um puzzle do nível N. |
| no_hints | Lógica pura | Resolver um puzzle do nível 6 ou superior sem ajudas. |
| seven_days | Sete dias seguidos | Resolver um puzzle em 7 dias seguidos. |
| first_lesson | Primeira lição | Concluir uma lição. |
| all_lessons | Lições concluídas | Concluir todas as lições. |
| daily | Puzzle do dia | Resolver um puzzle diário. |

For Portuguese (Brazil), the same texts work.

### Spanish

| ID key | Title | Description |
|---|---|---|
| level_N | Nivel N resuelto | Resolver un puzle del nivel N. |
| no_hints | Lógica pura | Resolver un puzle del nivel 6 o superior sin pistas. |
| seven_days | Siete días seguidos | Resolver un puzle 7 días seguidos. |
| first_lesson | Primera lección | Completar una lección. |
| all_lessons | Lecciones completadas | Completar todas las lecciones. |
| daily | Puzle del día | Resolver un puzle diario. |

### French

| ID key | Title | Description |
|---|---|---|
| level_N | Niveau N résolu | Résoudre une grille du niveau N. |
| no_hints | Logique pure | Résoudre une grille du niveau 6 ou plus sans indice. |
| seven_days | Sept jours d'affilée | Résoudre une grille 7 jours d'affilée. |
| first_lesson | Première leçon | Terminer une leçon. |
| all_lessons | Leçons terminées | Terminer toutes les leçons. |
| daily | Grille du jour | Résoudre une grille du jour. |

### German

| ID key | Title | Description |
|---|---|---|
| level_N | Level N gelöst | Löse ein Rätsel in Level N. |
| no_hints | Reine Logik | Löse ein Rätsel ab Level 6 ohne Tipp. |
| seven_days | Sieben Tage in Folge | Löse an 7 Tagen in Folge ein Rätsel. |
| first_lesson | Erste Lektion | Schließe eine Lektion ab. |
| all_lessons | Alle Lektionen | Schließe alle Lektionen ab. |
| daily | Rätsel des Tages | Löse ein Tagesrätsel. |

## 4. How the app uses them

- At launch the app signs in to Game Center, which shows its own sheet when
  needed. If the player declines, or Game Center is unavailable, the game
  carries on without it.
- On sign-in it sends what the device already has: the best time per level
  (from the scoreboard), today's daily time, and the achievements the
  stored statistics, lessons and daily puzzles earn. Earlier players don't
  lose credit.
- After each solved level puzzle: its time (hint penalties included) goes to
  the level's leaderboard, and its achievements are unlocked: the level,
  Pure Logic (level 6 or harder, no hint), Seven Days in a Row (the
  statistics' day streak).
- After each solved daily puzzle: its time goes to the daily leaderboard,
  and Puzzle of the Day (and Seven Days in a Row) can unlock. A daily puzzle
  doesn't count for the level leaderboards or the level achievements.
- Finishing a lesson unlocks First Lesson; finishing all eight unlocks
  Lessons Learned.
- The scoreboard screen shows **Leaderboards** and **Achievements** buttons
  while signed in, which open Game Center's own screens.
- Clearing the in-app scoreboard or statistics doesn't touch Game Center.

## 5. Testing

Game Center needs a signed-in player. On a simulator or device, sign in
under Settings → Game Center (a Sandbox account works for development
builds). The leaderboards and achievements must exist in App Store Connect,
even before they are live; until then the calls fail quietly and are logged
as `Games services: …` in the debug console.

## 6. Privacy

Scores and achievements go to Apple, never to us. The privacy page on the
website says so (section 4, Third-Party Services). Data that only Apple's
Game Center receives isn't normally declared as collected by the
developer, but check the App Privacy answers in App Store Connect when
submitting.

## 7. App Review notes and store texts

Game Center is one of the features that set the app apart (Guideline 4.3):
mention the leaderboards and achievements in the App Review notes, and add
a Game Center line to the description's features
([store-listing-texts.md](../store-listing-texts.md)).
