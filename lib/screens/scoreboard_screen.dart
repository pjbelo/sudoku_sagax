import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../game/sudoku_game.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/games_service.dart';
import '../services/scoreboard_service.dart';
import '../services/statistics_service.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/level_selector.dart';

/// Best times and statistics per level: a switch between the two views and
/// a level picker on top, the top 10 or the statistics below.
class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({
    super.key,
    this.initialLevel = 1,
    this.showStatistics = false,
  });

  final int initialLevel;

  /// Opens on the statistics instead of the best times.
  final bool showStatistics;

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  late int _level = widget.initialLevel;
  final _scores = ScoreboardService.instance;
  final _statistics = StatisticsService.instance;
  final _audio = AudioService.instance;

  /// Statistics instead of the best times.
  late bool _showStatistics = widget.showStatistics;

  static const _medals = ['🥇', '🥈', '🥉'];

  void _click() =>
      unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.85));

  Future<void> _clear() async {
    final l10n = AppLocalizations.of(context)!;
    _click();
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.clearScoresTitle,
      message: l10n.clearScoresMessage,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed) return;
    AnalyticsService.instance.log('scoreboard_cleared');
    await _scores.clear();
    if (mounted) setState(() {});
  }

  Future<void> _clearStatistics() async {
    final l10n = AppLocalizations.of(context)!;
    _click();
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.clearStatsTitle,
      message: l10n.clearStatsMessage,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed) return;
    AnalyticsService.instance.log('statistics_cleared');
    await _statistics.clear();
    if (mounted) setState(() {});
  }

  void _showView({required bool statistics}) {
    if (statistics == _showStatistics) return;
    _click();
    if (statistics) {
      AnalyticsService.instance.log('statistics_viewed', {'level': _level});
    }
    setState(() => _showStatistics = statistics);
  }

  void _selectLevel(int level) {
    if (level == _level) return;
    unawaited(_audio.playSfx(AudioService.levelSelectSfx, volume: 0.75));
    setState(() => _level = level);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = uiScaleOf(context);
    final compact = isCompactHeight(context);
    final listWidth = 560 * scale;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scoreboardTitle), centerTitle: true),
      body: SafeArea(
        child: TwoPaneLayout(
          firstFlex: 2,
          secondFlex: 3,
          // The levels as a 3×3 box beside the list.
          first: CenteredPane(
            maxWidth: 480 * scale,
            padding: compact ? 8 : 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildViewSwitch(l10n),
                SizedBox(height: compact ? 8 : 16),
                LevelSelector(
                  selected: _level,
                  chipSize: (compact ? 52 : 64) * scale,
                  onSelected: _selectLevel,
                ),
                SizedBox(height: compact ? 8 : 16),
                _buildSummary(l10n),
                SizedBox(height: compact ? 4 : 16),
                _buildFooter(l10n),
              ],
            ),
          ),
          second: _buildContent(l10n, maxWidth: listWidth),
          // The levels in one row above the list.
          single: Column(
            children: [
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: listWidth + 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildViewSwitch(l10n),
                ),
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                // 32 is the selector's own side padding, so that the row of
                // chips lines up with the list.
                constraints: BoxConstraints(maxWidth: listWidth + 32),
                child: LevelSelector(
                  selected: _level,
                  chipSize: 64 * scale,
                  singleRow: true,
                  onSelected: _selectLevel,
                ),
              ),
              _buildSummary(l10n),
              const SizedBox(height: 12),
              Expanded(child: _buildContent(l10n, maxWidth: listWidth)),
              _buildFooter(l10n),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  /// Best times | Statistics.
  Widget _buildViewSwitch(AppLocalizations l10n) {
    final colors = AppColors.of(context);
    final primary = Theme.of(context).primaryColor;
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<bool>(
        segments: [
          // Shrunk to one line in a narrow window, rather than wrapped.
          ButtonSegment(value: false, label: _oneLine(l10n.bestTimes)),
          ButtonSegment(value: true, label: _oneLine(l10n.statistics)),
        ],
        selected: {_showStatistics},
        onSelectionChanged: (selection) =>
            _showView(statistics: selection.first),
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          foregroundColor: colors.muted,
          selectedForegroundColor: colors.onPrimary,
          selectedBackgroundColor: primary,
          side: BorderSide(color: primary.withValues(alpha: 0.6)),
          textStyle: GoogleFonts.exo2(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _oneLine(String text) {
    return FittedBox(fit: BoxFit.scaleDown, child: Text(text, maxLines: 1));
  }

  Widget _buildContent(AppLocalizations l10n, {required double maxWidth}) {
    return _showStatistics
        ? _buildStatistics(l10n, maxWidth: maxWidth)
        : _buildList(l10n, maxWidth: maxWidth);
  }

  /// The day streaks, then the counters of the level, at most [maxWidth]
  /// wide. Like the list, it fills its pane so the margins scroll too.
  Widget _buildStatistics(AppLocalizations l10n, {required double maxWidth}) {
    final colors = AppColors.of(context);
    final stats = _statistics.levelStats(_level);
    final locale = Localizations.localeOf(context).languageCode;
    String time(int? seconds) => seconds == null ? '–' : formatTime(seconds);
    final percent = stats.solvedPercent;
    final solved = percent == null
        ? '${stats.solved}'
        : '${stats.solved} · '
              '${NumberFormat.percentPattern(locale).format(percent / 100)}';

    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        padding: EdgeInsets.fromLTRB(
          max(24, (constraints.maxWidth - maxWidth) / 2),
          0,
          max(24, (constraints.maxWidth - maxWidth) / 2),
          12,
        ),
        children: [
          _StatTiles(
            tiles: [
              (
                l10n.streakCurrent,
                l10n.streakDays(_statistics.currentStreak(DateTime.now())),
              ),
              (l10n.streakBest, l10n.streakDays(_statistics.bestStreak)),
            ],
          ),
          Text(
            l10n.streakNote,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, color: colors.muted),
          ),
          const SizedBox(height: 20),
          Text(
            '${l10n.levelLabel} $_level',
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 10),
          _StatTiles(
            tiles: [
              (l10n.statPlayed, '${stats.started}'),
              (l10n.statSolved, solved),
              (l10n.statBestTime, time(stats.bestSeconds)),
              (l10n.statAverageTime, time(stats.averageSeconds)),
              (l10n.statNoHints, '${stats.solvedWithoutHints}'),
              (l10n.statNoMistakes, '${stats.solvedWithoutMistakes}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(AppLocalizations l10n) {
    final colors = AppColors.of(context);
    return Text(
      '${l10n.levelLabel} $_level · ${levelSummary(l10n, _level)}',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(fontSize: 15, color: colors.muted),
    );
  }

  /// The top 10 of the level, at most [maxWidth] wide. It fills its pane so
  /// the drag also works in the empty margins of a large screen.
  Widget _buildList(AppLocalizations l10n, {required double maxWidth}) {
    final primary = Theme.of(context).primaryColor;
    final entries = _scores.scoresFor(_level);
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    );

    if (entries.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 56 * uiScaleOf(context),
                color: primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.noScores,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) => ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: max(24, (constraints.maxWidth - maxWidth) / 2),
        ),
        itemCount: entries.length,
        itemBuilder: (context, i) => _ScoreRow(
          rank: i + 1,
          medal: i < _medals.length ? _medals[i] : null,
          entry: entries[i],
          date: dateFormat.format(entries[i].date),
          hintsLabel: l10n.hintsAndMistakes(
            entries[i].hints,
            entries[i].mistakes,
          ),
        ),
      ),
    );
  }

  /// Game Center's (or Play Games') own leaderboards and achievements,
  /// once the player is signed in.
  Widget _buildGamesButtons(AppLocalizations l10n) {
    final games = GamesService.instance;
    return ListenableBuilder(
      listenable: games,
      builder: (context, _) {
        if (!games.isAvailable) return const SizedBox.shrink();
        final primary = Theme.of(context).primaryColor;
        Widget button(IconData icon, String label, VoidCallback onPressed) {
          return TextButton.icon(
            onPressed: () {
              _click();
              onPressed();
            },
            icon: Icon(icon, color: primary),
            label: Text(
              label,
              style: GoogleFonts.exo2(fontSize: 15, color: primary),
            ),
          );
        }

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            button(
              Icons.leaderboard_outlined,
              l10n.leaderboards,
              () => unawaited(games.showLeaderboards()),
            ),
            button(
              Icons.military_tech_outlined,
              l10n.achievements,
              () => unawaited(games.showAchievements()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClearButton(String label, VoidCallback onPressed) {
    final colors = AppColors.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.delete_outline, color: colors.error),
      label: Text(
        label,
        style: GoogleFonts.exo2(fontSize: 15, color: colors.error),
      ),
    );
  }

  /// Clear scoreboard or Reset statistics (once there is something to
  /// clear) and Back.
  Widget _buildFooter(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_showStatistics && !_scores.isEmpty)
          _buildClearButton(l10n.clearScores, _clear),
        if (_showStatistics && !_statistics.isEmpty)
          _buildClearButton(l10n.clearStats, _clearStatistics),
        _buildGamesButtons(l10n),
        TextButton(
          onPressed: () {
            _click();
            Navigator.pop(context);
          },
          child: Text(
            l10n.back,
            style: GoogleFonts.exo2(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.rank,
    required this.medal,
    required this.entry,
    required this.date,
    required this.hintsLabel,
  });

  final int rank;
  final String? medal;
  final ScoreEntry entry;
  final String date;
  final String hintsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final primary = Theme.of(context).primaryColor;
    final medal = this.medal;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: primary.withValues(alpha: rank == 1 ? 0.7 : 0.25),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40 * uiScaleOf(context),
            child: medal != null
                ? Text(medal, style: const TextStyle(fontSize: 24))
                : Text(
                    '#$rank',
                    style: GoogleFonts.exo2(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.muted,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: GoogleFonts.inter(fontSize: 14, color: colors.text),
                ),
                const SizedBox(height: 2),
                Text(
                  hintsLabel,
                  style: GoogleFonts.inter(fontSize: 12, color: colors.muted),
                ),
              ],
            ),
          ),
          Text(
            formatTime(entry.seconds),
            style: GoogleFonts.exo2(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: rank == 1 ? colors.hint : primary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Labelled values in two columns.
class _StatTiles extends StatelessWidget {
  const _StatTiles({required this.tiles});

  /// (label, value) pairs.
  final List<(String, String)> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < tiles.length; i += 2)
          Row(
            children: [
              Expanded(child: _tile(context, tiles[i])),
              const SizedBox(width: 10),
              Expanded(
                child: i + 1 < tiles.length
                    ? _tile(context, tiles[i + 1])
                    : const SizedBox(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _tile(BuildContext context, (String, String) tile) {
    final colors = AppColors.of(context);
    final (label, value) = tile;
    final primary = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          // One line, so that the two tiles of a row keep the same height.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: GoogleFonts.inter(fontSize: 13, color: colors.muted),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.exo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
