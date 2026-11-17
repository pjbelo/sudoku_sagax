import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_sagax/game/awards.dart';
import 'package:sudoku_sagax/game/play_games_ids.dart';
import 'package:sudoku_sagax/services/games_service.dart';

void main() {
  test('IDs are unique and in Game Center form', () {
    final ids = [for (final a in Award.values) a.id, ...allLeaderboardIds];
    expect(ids.toSet(), hasLength(ids.length));
    for (final id in ids) {
      expect(
        id,
        matches(
          RegExp(r'^sudokusagax\.(achievement|leaderboard)\.[a-z0-9_]+$'),
        ),
      );
    }
    expect(allLeaderboardIds, hasLength(10)); // 9 levels + daily
  });

  test('the first nine awards are the levels, in order', () {
    for (int level = 1; level <= 9; level++) {
      expect(levelAward(level).key, 'level_$level');
    }
  });

  test('a win earns its level, no hints from level 6, a 7-day streak', () {
    expect(awardsForWin(level: 3, hints: 0, dayStreak: 1), {Award.level3});
    expect(awardsForWin(level: 6, hints: 0, dayStreak: 1), {
      Award.level6,
      Award.noHints,
    });
    expect(awardsForWin(level: 7, hints: 2, dayStreak: 7), {
      Award.level7,
      Award.sevenDays,
    });
  });

  test('the daily puzzle and the lessons', () {
    expect(awardsForDaily(dayStreak: 2), {Award.daily});
    expect(awardsForLessons(done: 0, total: 8), isEmpty);
    expect(awardsForLessons(done: 1, total: 8), {Award.firstLesson});
    expect(awardsForLessons(done: 8, total: 8), {
      Award.firstLesson,
      Award.allLessons,
    });
  });

  test('progress from before signing in', () {
    expect(
      awardsForProgress(
        solvedByLevel: {1: 4, 2: 0, 8: 1},
        solvedWithoutHintsByLevel: {1: 4, 8: 1},
        bestDayStreak: 9,
        lessonsDone: 3,
        lessonsTotal: 8,
        dailySolved: true,
      ),
      {
        Award.level1,
        Award.level8,
        Award.noHints,
        Award.sevenDays,
        Award.firstLesson,
        Award.daily,
      },
    );
    // No hints only counts from level 6.
    expect(
      awardsForProgress(
        solvedByLevel: {2: 1},
        solvedWithoutHintsByLevel: {2: 1},
        bestDayStreak: 1,
        lessonsDone: 0,
        lessonsTotal: 8,
        dailySolved: false,
      ),
      {Award.level2},
    );
  });

  test('Play Games IDs: all or none', () {
    final achievements = playGamesAchievementIds.length;
    final leaderboards = playGamesLeaderboardIds.length;
    expect(
      (achievements == 0 && leaderboards == 0) || playGamesConfigured,
      isTrue,
      reason: 'fill in every Play Games ID, or none (play_games_ids.dart)',
    );
    for (final id in playGamesLeaderboardIds.keys) {
      expect(allLeaderboardIds, contains(id));
    }
  });

  test('without sign-in every call is a no-op', () async {
    final games = GamesService.instance;
    expect(games.isAvailable, isFalse);
    await games.recordWin(level: 5, seconds: 300, hints: 0);
    await games.recordDaily(200);
    await games.recordLesson();
    await games.showLeaderboards();
    await games.showAchievements();
  });
}
