import 'sudoku_generator.dart';

// ============================================================
// Sudoku Sagax — Game Center achievements and leaderboards (pure Dart)
// ============================================================
//
// The IDs must match App Store Connect exactly (docs/game-center.md has the
// titles, descriptions and points to enter there). An ID can never be
// reused once created, so never rename one.

/// A Game Center (and Google Play Games) achievement.
enum Award {
  /// Solve a puzzle of each level.
  level1('level_1'),
  level2('level_2'),
  level3('level_3'),
  level4('level_4'),
  level5('level_5'),
  level6('level_6'),
  level7('level_7'),
  level8('level_8'),
  level9('level_9'),

  /// Solve a level 6 or harder puzzle without a hint.
  noHints('no_hints'),

  /// Solve a puzzle on 7 days in a row (the statistics' day streak).
  sevenDays('seven_days'),

  /// Finish a lesson.
  firstLesson('first_lesson'),

  /// Finish every lesson.
  allLessons('all_lessons'),

  /// Solve a daily puzzle.
  daily('daily');

  const Award(this.key);

  final String key;

  String get id => 'sudokusagax.achievement.$key';
}

/// The award for solving a puzzle of [level]: the first nine awards are
/// the levels, in order.
Award levelAward(int level) => Award.values[level - 1];

/// Leaderboard of the best time on [level] (lower is better).
String levelLeaderboardId(int level) => 'sudokusagax.leaderboard.level_$level';

/// Leaderboard of the best time on the daily puzzle (lower is better). In
/// Game Center it is a recurring leaderboard that starts again every day at
/// 00:00 UTC, when the daily puzzle changes.
const dailyLeaderboardId = 'sudokusagax.leaderboard.daily';

/// Every leaderboard: one per level, then the daily one.
final allLeaderboardIds = [
  for (final spec in sudokuLevels) levelLeaderboardId(spec.level),
  dailyLeaderboardId,
];

/// The level that [noHints] asks for, at least.
const noHintsFromLevel = 6;

/// What a solved level puzzle earns. [dayStreak] is the statistics' day
/// streak, this win included.
Set<Award> awardsForWin({
  required int level,
  required int hints,
  required int dayStreak,
}) => {
  levelAward(level),
  if (hints == 0 && level >= noHintsFromLevel) Award.noHints,
  if (dayStreak >= 7) Award.sevenDays,
};

/// What a solved daily puzzle earns.
Set<Award> awardsForDaily({required int dayStreak}) => {
  Award.daily,
  if (dayStreak >= 7) Award.sevenDays,
};

/// What the lessons earn: [done] of [total] finished.
Set<Award> awardsForLessons({required int done, required int total}) => {
  if (done >= 1) Award.firstLesson,
  if (done >= total) Award.allLessons,
};

/// What the progress stored on the device already earns, for players who
/// sign in after playing. [solvedByLevel] and [solvedWithoutHintsByLevel]
/// are keyed by level number.
Set<Award> awardsForProgress({
  required Map<int, int> solvedByLevel,
  required Map<int, int> solvedWithoutHintsByLevel,
  required int bestDayStreak,
  required int lessonsDone,
  required int lessonsTotal,
  required bool dailySolved,
}) => {
  for (final spec in sudokuLevels)
    if ((solvedByLevel[spec.level] ?? 0) > 0) levelAward(spec.level),
  for (final spec in sudokuLevels)
    if (spec.level >= noHintsFromLevel &&
        (solvedWithoutHintsByLevel[spec.level] ?? 0) > 0)
      Award.noHints,
  if (bestDayStreak >= 7) Award.sevenDays,
  ...awardsForLessons(done: lessonsDone, total: lessonsTotal),
  if (dailySolved) Award.daily,
};
