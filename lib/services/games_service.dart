import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:games_services/games_services.dart';

import '../game/awards.dart';
import '../game/daily_puzzle.dart';
import '../game/lessons.dart';
import '../game/play_games_ids.dart';
import '../game/sudoku_generator.dart';
import 'daily_service.dart';
import 'lesson_service.dart';
import 'scoreboard_service.dart';
import 'statistics_service.dart';

/// Game Center (iOS) and Google Play Games (Android): a best-time
/// leaderboard per level and one for the daily puzzle, and achievements,
/// through the games_services package (as in MasterCode).
///
/// [init] signs the player in once at launch; until then, and in tests,
/// every call is a no-op. On Android it stays off until the Play Games IDs
/// are filled in (play_games_ids.dart).
class GamesService extends ChangeNotifier {
  GamesService._();
  static final instance = GamesService._();

  bool _signedIn = false;

  /// Whether the player is signed in (the scoreboard shows the Game Center
  /// buttons only then).
  bool get isAvailable => _signedIn;

  /// Signs in (Game Center or Play Games show their own sheet when needed)
  /// and then sends the progress already on the device. Call once after
  /// `runApp`.
  Future<void> init() async {
    if (kIsWeb) return;
    final supported = switch (defaultTargetPlatform) {
      TargetPlatform.iOS => true,
      TargetPlatform.android => playGamesConfigured,
      _ => false,
    };
    if (!supported) return;
    try {
      await GameAuth.signIn();
      _signedIn = await GameAuth.isSignedIn;
    } catch (e) {
      debugPrint('Games sign-in failed: $e');
      _signedIn = false;
    }
    notifyListeners();
    if (_signedIn) await _syncProgress();
  }

  /// Reports a solved level puzzle: its time on the level's leaderboard,
  /// and any achievements it earns.
  Future<void> recordWin({
    required int level,
    required int seconds,
    required int hints,
  }) async {
    if (!_signedIn) return;
    await _submit(levelLeaderboardId(level), seconds);
    await _unlock(
      awardsForWin(level: level, hints: hints, dayStreak: _dayStreak()),
    );
  }

  /// Reports a solved daily puzzle on the daily leaderboard. It doesn't
  /// count for the level leaderboards.
  Future<void> recordDaily(int seconds) async {
    if (!_signedIn) return;
    await _submit(dailyLeaderboardId, seconds);
    await _unlock(awardsForDaily(dayStreak: _dayStreak()));
  }

  /// Reports a finished lesson.
  Future<void> recordLesson() async {
    if (!_signedIn) return;
    await _unlock(
      awardsForLessons(done: _lessonsDone(), total: lessonTechniques.length),
    );
  }

  Future<void> showLeaderboards() => _call(Leaderboards.showLeaderboards);

  Future<void> showAchievements() => _call(Achievements.showAchievements);

  /// Best times and earned achievements from before the player signed in.
  /// Game Center keeps the best score and ignores repeated unlocks.
  Future<void> _syncProgress() async {
    final statistics = StatisticsService.instance;
    for (final spec in sudokuLevels) {
      final best = ScoreboardService.instance.scoresFor(spec.level);
      if (best.isNotEmpty) {
        await _submit(levelLeaderboardId(spec.level), best.first.seconds);
      }
    }
    final today = DailyService.instance.secondsFor(dailyToday());
    if (today != null) await _submit(dailyLeaderboardId, today);
    await _unlock(
      awardsForProgress(
        solvedByLevel: {
          for (final spec in sudokuLevels)
            spec.level: statistics.levelStats(spec.level).solved,
        },
        solvedWithoutHintsByLevel: {
          for (final spec in sudokuLevels)
            spec.level: statistics.levelStats(spec.level).solvedWithoutHints,
        },
        bestDayStreak: statistics.bestStreak,
        lessonsDone: _lessonsDone(),
        lessonsTotal: lessonTechniques.length,
        dailySolved: DailyService.instance.bestStreak > 0,
      ),
    );
  }

  int _dayStreak() => StatisticsService.instance.currentStreak(DateTime.now());

  int _lessonsDone() =>
      lessonTechniques.where(LessonService.instance.isDone).length;

  /// A time of [seconds] on [leaderboard]. Game Center's "Elapsed Time – To
  /// the Second" format takes seconds; Play Games' time format takes
  /// milliseconds.
  Future<void> _submit(String leaderboard, int seconds) => _call(
    () => Leaderboards.submitScore(
      score: Score(
        iOSLeaderboardID: leaderboard,
        androidLeaderboardID: playGamesLeaderboardIds[leaderboard],
        value: defaultTargetPlatform == TargetPlatform.android
            ? seconds * 1000
            : seconds,
      ),
    ),
  );

  Future<void> _unlock(Set<Award> awards) async {
    for (final award in awards) {
      await _call(
        () => Achievements.unlock(
          achievement: Achievement(
            iOSID: award.id,
            androidID: playGamesAchievementIds[award] ?? '',
            percentComplete: 100,
          ),
        ),
      );
    }
  }

  /// Game Center and Play Games errors (offline, IDs not set up yet) never
  /// reach the game.
  Future<void> _call(Future<Object?> Function() action) async {
    if (!_signedIn) return;
    try {
      await action();
    } catch (e) {
      debugPrint('Games services: $e');
    }
  }
}
