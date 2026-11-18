import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/game_review.dart';
import '../game/logic_coach.dart';
import '../game/sudoku_game.dart';
import '../game/sudoku_generator.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/coach_card.dart';

/// After a win: the techniques the puzzle needed, then the player's hints
/// and mistakes, each mistake with the logic that was available instead.
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key, required this.puzzle, required this.events});

  final SudokuPuzzle puzzle;
  final List<ReviewEvent> events;

  /// "row 3, column 5" (numbered from 1).
  static String cellLabel(AppLocalizations l10n, int cell) =>
      l10n.cellName(rowOf(cell) + 1, colOf(cell) + 1);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final needed = techniquesNeeded(puzzle);
    final maxWidth = 560 * uiScaleOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewTitle), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            // As wide as the scoreboard list, and the margins scroll too.
            padding: EdgeInsets.symmetric(
              horizontal: max(24, (constraints.maxWidth - maxWidth) / 2),
              vertical: 16,
            ),
            children: [
              _SectionTitle(l10n.reviewNeeded),
              Text(
                l10n.reviewNeededNote,
                style: GoogleFonts.inter(fontSize: 14, color: colors.muted),
              ),
              const SizedBox(height: 12),
              for (final MapEntry(key: technique, value: count)
                  in needed.entries)
                _TechniqueRow(
                  name: techniqueName(l10n, technique),
                  count: count,
                ),
              const SizedBox(height: 24),
              _SectionTitle(l10n.reviewYourGame),
              if (events.isEmpty)
                Text(
                  l10n.reviewClean,
                  style: GoogleFonts.inter(fontSize: 16, color: colors.text),
                )
              else
                for (final event in events) _EventRow(event: event),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.back,
                    style: GoogleFonts.exo2(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.exo2(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colors.primary,
        ),
      ),
    );
  }
}

/// A technique and how many steps needed it.
class _TechniqueRow extends StatelessWidget {
  const _TechniqueRow({required this.name, required this.count});

  final String name;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.inter(fontSize: 16, color: colors.text),
            ),
          ),
          Text(
            '× $count',
            style: GoogleFonts.exo2(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.primary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// One hint (amber) or mistake (red); a mistake adds the logic that was
/// available at that moment.
class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});

  final ReviewEvent event;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final time = formatTime(event.seconds);
    final cell = ReviewScreen.cellLabel(l10n, event.cell);
    final isHint = event.kind == ReviewEventKind.hint;
    final fixesMistake = event.technique == CoachTechnique.mistake;

    final String main;
    String? available;
    if (isHint) {
      main = fixesMistake
          ? l10n.reviewHintFix(time, event.digit, cell)
          : l10n.reviewHint(
              time,
              techniqueName(l10n, event.technique),
              event.digit,
              cell,
            );
    } else {
      main = l10n.reviewMistake(time, event.digit, cell);
      final stepCell = ReviewScreen.cellLabel(l10n, event.stepCell);
      available = fixesMistake
          ? l10n.reviewAvailableFix(stepCell)
          : l10n.reviewAvailable(
              techniqueName(l10n, event.technique),
              event.stepDigit,
              stepCell,
            );
    }
    final color = isHint ? colors.hint : colors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isHint ? Icons.lightbulb_outline : Icons.error_outline,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  main,
                  style: GoogleFonts.inter(fontSize: 15, color: colors.text),
                ),
                if (available != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    available,
                    style: GoogleFonts.inter(fontSize: 14, color: colors.muted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
