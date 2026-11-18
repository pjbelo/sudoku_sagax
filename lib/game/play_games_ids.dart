import 'awards.dart';

// ============================================================
// Sudoku Sagax — Google Play Games IDs (Android)
// ============================================================
//
// Play Console generates its own IDs for each achievement and leaderboard
// (Play Games Services → Setup and management → Achievements / Leaderboards;
// "Get resources" lists them all). Paste them here, keyed by the Game
// Center IDs in awards.dart, and put the project ID in
// android/app/src/main/res/values/play_games.xml. While these maps are
// empty, Android never touches Play Games. docs/google-play/play-games.md
// has the setup steps.

/// Play Games achievement ID per [Award].
const playGamesAchievementIds = <Award, String>{};

/// Play Games leaderboard ID per Game Center leaderboard ID (the nine
/// levels' [levelLeaderboardId] and [dailyLeaderboardId]).
const playGamesLeaderboardIds = <String, String>{};

/// Whether every achievement and leaderboard has its Play Games ID.
bool get playGamesConfigured =>
    playGamesAchievementIds.length == Award.values.length &&
    playGamesLeaderboardIds.length == allLeaderboardIds.length;
