import 'logic_coach.dart';
import 'sudoku_game.dart';
import 'sudoku_generator.dart';

// ============================================================
// Sudoku Sagax — game review (pure Dart, no Flutter)
// ============================================================
//
// What the review screen shows after a win: the techniques the puzzle
// needed, and the player's hints and mistakes with the logic that was
// available at that moment.

enum ReviewEventKind { hint, mistake }

/// A hint or a mistake, recorded while playing.
class ReviewEvent {
  const ReviewEvent({
    required this.kind,
    required this.seconds,
    required this.cell,
    required this.digit,
    required this.technique,
    required this.stepCell,
    required this.stepDigit,
  });

  /// A hint taken: the coach's [step] placed its digit at [seconds].
  factory ReviewEvent.hint(CoachStep step, int seconds) => ReviewEvent(
    kind: ReviewEventKind.hint,
    seconds: seconds,
    cell: step.cell,
    digit: step.digit,
    technique: step.technique,
    stepCell: step.cell,
    stepDigit: step.digit,
  );

  /// A wrong [digit] entered in [cell] at [seconds], when the coach's
  /// [available] step was the logical move.
  factory ReviewEvent.mistake(
    int cell,
    int digit,
    int seconds,
    CoachStep available,
  ) => ReviewEvent(
    kind: ReviewEventKind.mistake,
    seconds: seconds,
    cell: cell,
    digit: digit,
    technique: available.technique,
    stepCell: available.cell,
    stepDigit: available.digit,
  );

  final ReviewEventKind kind;

  /// The game clock at that moment, hint penalties included.
  final int seconds;

  /// The cell of the hint, or of the wrong digit.
  final int cell;

  /// The digit the hint placed, or the wrong digit entered.
  final int digit;

  /// For a hint, its technique. For a mistake, the technique of the step
  /// that was available instead.
  final CoachTechnique technique;

  /// The step that was available: its cell and digit (for a hint, the same
  /// as [cell] and [digit]).
  final int stepCell;
  final int stepDigit;

  Map<String, Object> toJson() => {
    'kind': kind.name,
    'seconds': seconds,
    'cell': cell,
    'digit': digit,
    'technique': technique.name,
    'stepCell': stepCell,
    'stepDigit': stepDigit,
  };

  /// Throws when the data is damaged (an unknown name or a missing value).
  factory ReviewEvent.fromJson(Map<String, dynamic> json) => ReviewEvent(
    kind: ReviewEventKind.values.byName(json['kind'] as String),
    seconds: json['seconds'] as int,
    cell: json['cell'] as int,
    digit: json['digit'] as int,
    technique: CoachTechnique.values.byName(json['technique'] as String),
    stepCell: json['stepCell'] as int,
    stepDigit: json['stepDigit'] as int,
  );
}

/// How many times each technique is needed to solve [puzzle] from its
/// givens, one digit at a time, as the logic coach would solve it (each
/// step counted under its hardest technique). In technique order.
Map<CoachTechnique, int> techniquesNeeded(SudokuPuzzle puzzle) {
  final game = SudokuGame(puzzle);
  final counts = <CoachTechnique, int>{};
  while (true) {
    final step = findCoachStep(game);
    if (step == null) break;
    counts[step.technique] = (counts[step.technique] ?? 0) + 1;
    game.applyHint(step.cell, noteRemovals: step.removals);
  }
  return {
    for (final technique in CoachTechnique.values)
      if (counts.containsKey(technique)) technique: counts[technique]!,
  };
}
