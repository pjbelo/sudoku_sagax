import 'logic_coach.dart';
import 'sudoku_game.dart';
import 'sudoku_generator.dart';

// ============================================================
// Sudoku Sagax — guided lessons (pure Dart, no Flutter)
// ============================================================
//
// One lesson per technique of the logic coach, played on a board taken
// from a real game at the moment that technique is the next step.

/// The lessons, in the order they are shown and learnt.
const lessonTechniques = [
  CoachTechnique.hiddenSingle,
  CoachTechnique.nakedSingle,
  CoachTechnique.pointingPair,
  CoachTechnique.boxLineReduction,
  CoachTechnique.nakedPair,
  CoachTechnique.hiddenPair,
  CoachTechnique.nakedTriple,
  CoachTechnique.xWing,
];

/// The first level that needs each technique (see [sudokuLevels]).
const lessonLevel = {
  CoachTechnique.hiddenSingle: 1,
  CoachTechnique.nakedSingle: 1,
  CoachTechnique.pointingPair: 6,
  CoachTechnique.boxLineReduction: 6,
  CoachTechnique.nakedPair: 7,
  CoachTechnique.hiddenPair: 7,
  CoachTechnique.nakedTriple: 8,
  CoachTechnique.xWing: 9,
};

/// The lessons a level brings in for the first time (none for most).
List<CoachTechnique> lessonsIntroducedAt(int level) => [
  for (final technique in lessonTechniques)
    if (lessonLevel[technique] == level) technique,
];

/// A lesson: a board where [step] is the next move, using [technique].
class Lesson {
  const Lesson({
    required this.technique,
    required this.puzzle,
    required this.step,
  });

  final CoachTechnique technique;

  /// The board of the lesson: every digit already placed is a given.
  final SudokuPuzzle puzzle;

  /// The move the player has to find.
  final CoachStep step;

  /// Whether the board shows the candidates as notes: the eliminations
  /// can't be seen without them, and the singles would be given away.
  bool get showsCandidates => step.eliminations.isNotEmpty;
}

final Map<CoachTechnique, Lesson> _lessons = {};

/// The lesson for [technique]. Found by playing graded games with the
/// coach until it takes that technique alone (the same board every time,
/// since the games are seeded), then kept for later.
Lesson lessonFor(CoachTechnique technique) =>
    _lessons[technique] ??= _findLesson(technique);

Lesson _findLesson(CoachTechnique technique) {
  // Naked singles are rare in the easy levels, where the coach finds a
  // hidden single first: they come up more often from level 6.
  final first = technique == CoachTechnique.nakedSingle
      ? 6
      : lessonLevel[technique]!;
  // Levels from the technique's own one up, so the board is no harder than
  // it needs to be; then the others.
  final levels = [
    for (int level = first; level <= 9; level++) level,
    for (int level = 1; level < first; level++) level,
  ];
  for (final level in levels) {
    for (int seed = 0; seed < 200; seed++) {
      final game = SudokuGame(generatePuzzle(level, seed: seed));
      while (true) {
        final step = findCoachStep(game);
        if (step == null) break;
        if (_teaches(step, technique)) {
          final puzzle = SudokuPuzzle(
            level: level,
            givens: List.of(game.values),
            solution: game.solution,
          );
          // The same step again, now on the lesson's own board.
          return Lesson(
            technique: technique,
            puzzle: puzzle,
            step: findCoachStep(SudokuGame(puzzle))!,
          );
        }
        game.applyHint(step.cell, noteRemovals: step.removals);
      }
    }
  }
  throw StateError('No board for a ${technique.name} lesson');
}

/// Whether [step] shows [technique] on its own: a single with nothing
/// before it, or exactly one elimination of that technique.
bool _teaches(CoachStep step, CoachTechnique technique) {
  if (step.technique != technique) return false;
  final singles = [CoachTechnique.hiddenSingle, CoachTechnique.nakedSingle];
  if (singles.contains(technique)) return step.eliminations.isEmpty;
  return step.eliminations.length == 1;
}
