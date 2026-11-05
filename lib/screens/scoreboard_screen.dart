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
import '../services/scoreboard_service.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/level_selector.dart';

/// Best times per level: a level picker on top, the top 10 below.
class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key, this.initialLevel = 1});

  final int initialLevel;

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  late int _level = widget.initialLevel;
  final _scores = ScoreboardService.instance;
  final _audio = AudioService.instance;

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
          second: _buildList(l10n, maxWidth: listWidth),
          // The levels in one row above the list.
          single: Column(
            children: [
              const SizedBox(height: 8),
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
              Expanded(child: _buildList(l10n, maxWidth: listWidth)),
              _buildFooter(l10n),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(AppLocalizations l10n) {
    return Text(
      '${l10n.levelLabel} $_level · ${levelSummary(l10n, _level)}',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(fontSize: 15, color: AppColors.softSlate),
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

  /// Clear scoreboard (once there is something to clear) and Back.
  Widget _buildFooter(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_scores.isEmpty)
          TextButton.icon(
            onPressed: _clear,
            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
            label: Text(
              l10n.clearScores,
              style: GoogleFonts.exo2(fontSize: 15, color: AppColors.errorRed),
            ),
          ),
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
    final primary = Theme.of(context).primaryColor;
    final medal = this.medal;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
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
                      color: AppColors.softSlate,
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
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.snowWhite,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hintsLabel,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.softSlate,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatTime(entry.seconds),
            style: GoogleFonts.exo2(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: rank == 1 ? AppColors.hintAmber : primary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
