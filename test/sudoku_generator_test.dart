import 'package:flutter_test/flutter_test.dart';
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
          '${spec.technique.name}', () {
        for (int seed = 0; seed < 5; seed++) {
          final p = generatePuzzle(spec.level, seed: seed);
          expect(p.level, spec.level);
          expect(isValidSolution(p.solution), isTrue);
          expect(p.clueCount, spec.clues);
          expect(countSolutions(p.givens), 1);
          for (int i = 0; i < 81; i++) {
            if (p.givens[i] != 0) expect(p.givens[i], p.solution[i]);
          }
          switch (spec.technique) {
            case SudokuTechnique.singles:
              expect(solvableWithSingles(p.givens), isTrue);
            case SudokuTechnique.advanced:
              expect(solvableWithSingles(p.givens), isFalse);
            case SudokuTechnique.unique:
              break;
          }
        }
      });
    }

    test('same seed gives the same puzzle', () {
      final a = generatePuzzle(5, seed: 42);
      final b = generatePuzzle(5, seed: 42);
      expect(a.givens, b.givens);
    });
  });
}
