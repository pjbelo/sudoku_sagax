import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_sagax/game/logic_coach.dart';
import 'package:sudoku_sagax/game/puzzle_bank.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';

/// True when [grid] is a complete, valid sudoku solution.
bool isValidSolution(List<int> grid) {
  for (final unit in units) {
    final digits = {for (final i in unit) grid[i]};
    if (digits.length != 9 || digits.contains(0)) return false;
  }
  return true;
}

void main() {
  group('geometry', () {
    test('every cell has 20 peers', () {
      for (int i = 0; i < 81; i++) {
        expect(peers[i], hasLength(20));
        expect(peers[i], isNot(contains(i)));
      }
    });

    test('27 units of 9 cells', () {
      expect(units, hasLength(27));
      for (final u in units) {
        expect(u.toSet(), hasLength(9));
      }
    });
  });

  group('solver', () {
    // A well-known puzzle with a unique solution.
    const puzzle =
        '530070000600195000098000060800060003400803001700020006060000280000419005000080079';

    List<int> parse(String s) => [for (final ch in s.split('')) int.parse(ch)];

    test('solves a classic puzzle', () {
      final solution = solve(parse(puzzle));
      expect(solution, isNotNull);
      expect(isValidSolution(solution!), isTrue);
      expect(solution.take(9).join(), '534678912');
    });

    test('counts solutions up to the limit', () {
      expect(countSolutions(parse(puzzle)), 1);
      expect(countSolutions(List.filled(81, 0)), 2);
    });

    test('detects contradictions', () {
      final bad = parse(puzzle)..[1] = 5; // two 5s in the first row
      expect(countSolutions(bad), 0);
      expect(solve(bad), isNull);
    });

    test('singles solver handles an easy puzzle', () {
      expect(solvableWithSingles(parse(puzzle)), isTrue);
      expect(solvableWithSingles(List.filled(81, 0)), isFalse);
    });
  });

  group('generator', () {
    test('there are 9 levels with decreasing clue counts', () {
      expect(sudokuLevels, hasLength(9));
      for (int i = 1; i < sudokuLevels.length; i++) {
        expect(sudokuLevels[i].clues, lessThan(sudokuLevels[i - 1].clues));
        expect(sudokuLevels[i].level, i + 1);
      }
    });

    for (final spec in sudokuLevels) {
      test('level ${spec.level}: unique, ${spec.clues} clues, '
          '${spec.technique.name} and nothing harder', () {
        for (int seed = 0; seed < 5; seed++) {
          final p = generatePuzzle(spec.level, seed: seed);
          expect(p.level, spec.level);
          expect(isValidSolution(p.solution), isTrue);
          expect(p.clueCount, spec.clues);
          expect(countSolutions(p.givens), 1);
          for (int i = 0; i < 81; i++) {
            if (p.givens[i] != 0) expect(p.givens[i], p.solution[i]);
          }
          expect(
            meetsLevel(spec.technique, hardestTechnique(p.givens)),
            isTrue,
            reason: 'seed $seed: ${hardestTechnique(p.givens)?.name}',
          );
        }
      });
    }

    test('the bank: every puzzle fits its level', () {
      for (final MapEntry(key: level, value: puzzles) in puzzleBank.entries) {
        final spec = sudokuLevels[level - 1];
        expect(spec.technique, isNot(SudokuTechnique.singles));
        expect(puzzles.toSet(), hasLength(puzzles.length)); // no repeats
        for (final text in puzzles) {
          final givens = [for (final ch in text.split('')) int.parse(ch)];
          expect(givens, hasLength(81));
          expect(givens.where((v) => v != 0), hasLength(spec.clues));
          expect(
            meetsLevel(spec.technique, hardestTechnique(givens)),
            isTrue,
            reason: 'level $level: $text',
          );
        }
      }
      expect(puzzleBank.keys.toSet(), {6, 7, 8, 9});
    });

    test('shuffling keeps a puzzle valid, unique and as hard', () {
      final rng = Random(5);
      for (int level = 6; level <= 9; level++) {
        final p = generatePuzzle(level, seed: 1);
        final hardest = hardestTechnique(p.givens);
        final q = shufflePuzzle(p, rng);
        expect(isValidSolution(q.solution), isTrue);
        expect(q.clueCount, p.clueCount);
        expect(countSolutions(q.givens), 1);
        expect(solve(q.givens), q.solution);
        expect(hardestTechnique(q.givens), hardest);
        expect(q.givens, isNot(p.givens));
      }
    });

    test('same seed gives the same puzzle', () {
      final a = generatePuzzle(5, seed: 42);
      final b = generatePuzzle(5, seed: 42);
      expect(a.givens, b.givens);
    });
  });
}
