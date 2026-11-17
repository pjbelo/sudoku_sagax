import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/logic_coach.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';

/// Localised name of a coach technique.
String techniqueName(AppLocalizations l10n, CoachTechnique technique) =>
    switch (technique) {
      CoachTechnique.hiddenSingle => l10n.techniqueHiddenSingle,
      CoachTechnique.nakedSingle => l10n.techniqueNakedSingle,
      CoachTechnique.pointingPair => l10n.techniquePointingPair,
      CoachTechnique.boxLineReduction => l10n.techniqueBoxLine,
      CoachTechnique.nakedPair => l10n.techniqueNakedPair,
      CoachTechnique.hiddenPair => l10n.techniqueHiddenPair,
      CoachTechnique.nakedTriple => l10n.techniqueNakedTriple,
      CoachTechnique.xWing => l10n.techniqueXWing,
      CoachTechnique.mistake => l10n.techniqueMistake,
      CoachTechnique.fromSolution => l10n.techniqueFromSolution,
    };

/// "Row 4", "Column 8", "Box 5" (numbered from 1).
String unitName(AppLocalizations l10n, UnitRef unit) => switch (unit.kind) {
  UnitKind.row => l10n.unitRow(unit.index + 1),
  UnitKind.column => l10n.unitColumn(unit.index + 1),
  UnitKind.box => l10n.unitBox(unit.index + 1),
};

/// Step 1: the technique's area, where the player should look.
String coachLookText(AppLocalizations l10n, CoachStep step) {
  final unit = unitName(l10n, step.lookAt);
  return switch (step.singleTechnique) {
    CoachTechnique.mistake => l10n.coachLookMistake(unit),
    CoachTechnique.fromSolution => l10n.coachLookFallback(unit),
    _ => l10n.coachLook(unit),
  };
}

/// Step 2: the deduction, one sentence per elimination, then the single.
String coachExplanation(AppLocalizations l10n, CoachStep step) {
  switch (step.singleTechnique) {
    case CoachTechnique.mistake:
      return l10n.coachMistake(step.wrongDigit);
    case CoachTechnique.fromSolution:
      return l10n.coachFallback;
    default:
      final sentences = [
        for (final e in step.eliminations) _eliminationText(l10n, e),
        if (step.singleTechnique == CoachTechnique.hiddenSingle)
          l10n.coachHiddenSingle(unitName(l10n, step.singleUnit!), step.digit)
        else
          l10n.coachNakedSingle(step.digit),
      ];
      return sentences.join(' ');
  }
}

String _eliminationText(AppLocalizations l10n, Elimination e) {
  final first = unitName(l10n, e.units.first);
  final digits = e.digits;
  switch (e.technique) {
    case CoachTechnique.pointingPair:
      return e.units[1].kind == UnitKind.row
          ? l10n.coachPointingRow(first, digits[0])
          : l10n.coachPointingColumn(first, digits[0]);
    case CoachTechnique.boxLineReduction:
      return l10n.coachBoxLine(first, digits[0]);
    case CoachTechnique.nakedPair:
      return l10n.coachNakedPair(first, digits[0], digits[1]);
    case CoachTechnique.hiddenPair:
      return l10n.coachHiddenPair(first, digits[0], digits[1]);
    case CoachTechnique.nakedTriple:
      return l10n.coachNakedTriple(first, digits[0], digits[1], digits[2]);
    case CoachTechnique.xWing:
      return e.units.first.kind == UnitKind.row
          ? l10n.coachXWingRows(digits[0])
          : l10n.coachXWingColumns(digits[0]);
    default:
      return '';
  }
}

/// Step 3: what the hint did.
String coachDoneText(AppLocalizations l10n, CoachStep step) =>
    step.singleTechnique == CoachTechnique.mistake
    ? l10n.coachCorrected(step.digit)
    : l10n.coachDone(step.digit);

/// The logic coach's explanation, shown in place of the controls and the
/// number keys: a title, a text that scrolls when it is long, then Close and
/// the button for the next step on one row, to leave the text more room.
class CoachCard extends StatefulWidget {
  const CoachCard({
    super.key,
    required this.title,
    required this.text,
    required this.buttonLabel,
    required this.onButton,
    required this.onClose,
    required this.closeLabel,
  });

  final String title;
  final String text;
  final String buttonLabel;
  final VoidCallback onButton;
  final VoidCallback onClose;
  final String closeLabel;

  @override
  State<CoachCard> createState() => _CoachCardState();
}

class _CoachCardState extends State<CoachCard> {
  /// For the scroll bar, shown whenever the text is longer than the card.
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 6),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.hintAmber.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.hintAmber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.exo2(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.hintAmber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Scrollbar(
              controller: _scroll,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scroll,
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  widget.text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.35,
                    color: AppColors.snowWhite,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Both shrink to fit a narrow pane rather than overflow.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TextButton(
                    onPressed: widget.onClose,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.softSlate,
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(widget.closeLabel),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ElevatedButton(
                    onPressed: widget.onButton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.hintAmber,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),
                      textStyle: GoogleFonts.exo2(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(widget.buttonLabel),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
