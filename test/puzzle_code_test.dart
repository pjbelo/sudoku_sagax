import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_sagax/game/puzzle_code.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';

void main() {
  test('every level round-trips through its code', () {
    for (final spec in sudokuLevels) {
      for (int seed = 0; seed < 5; seed++) {
        final puzzle = generatePuzzle(spec.level, seed: seed);
        final code = puzzleCode(puzzle);
        final back = puzzleFromCode(code);
        expect(back, isNotNull, reason: code);
        expect(back!.level, spec.level);
        expect(back.givens, puzzle.givens);
        expect(back.solution, puzzle.solution);
      }
    }
  });

  test('a code starts with its level and is grouped in fours', () {
    final code = puzzleCode(generatePuzzle(7, seed: 1));
    expect(code, startsWith('7-'));
    final groups = code.split('-');
    for (final group in groups.sublist(1, groups.length - 1)) {
      expect(group.length, 4);
    }
    expect(code, matches(RegExp(r'^[0-9A-HJKMNP-TV-Z-]+$')));
  });

  test('case, dashes, spaces and look-alike letters are forgiven', () {
    final puzzle = generatePuzzle(6, seed: 3);
    final code = puzzleCode(puzzle);
    final variants = [
      code.toLowerCase(),
      code.replaceAll('-', ''),
      code.replaceAll('-', ' '),
      code.replaceAll('0', 'O').replaceAll('1', 'l'),
    ];
    for (final text in variants) {
      expect(puzzleFromText(text)?.givens, puzzle.givens, reason: text);
    }
  });

  test('the code is found inside a whole message', () {
    final puzzle = generatePuzzle(8, seed: 2);
    final message =
        'I solved this puzzle in 12:34. Can you do better?\n\n'
        'Code: ${puzzleCode(puzzle)}\n\nhttps://sudoku.sagax-games.com';
    expect(puzzleFromText(message)?.givens, puzzle.givens);
  });

  test('a typo is caught', () {
    final code = puzzleCode(generatePuzzle(9, seed: 4));
    // Change one character of the body, then swap two neighbours.
    final i = code.length ~/ 2;
    final changed = code[i] == 'A' ? 'B' : 'A';
    final typo = code.substring(0, i) + changed + code.substring(i + 1);
    expect(puzzleFromCode(typo), isNull);
    final chars = code.replaceAll('-', '').split('');
    final j = chars.indexWhere((c) => c != chars[5], 5);
    final swapped = [...chars]
      ..[5] = chars[j]
      ..[j] = chars[5];
    // Only adjacent swaps are guaranteed; this one is adjacent when j == 6.
    if (j == 6) expect(puzzleFromCode(swapped.join()), isNull);
  });

  test('text without a code gives nothing', () {
    for (final text in ['', 'hello', '6-', '0-ABCD-EFGH', 'Code: 12:34']) {
      expect(puzzleFromText(text), isNull, reason: text);
    }
  });

  test('a grid without a unique solution is refused', () {
    // A real code for a grid with only 16 givens: valid format, not a puzzle.
    final solution = generatePuzzle(1, seed: 0).solution;
    final givens = [for (int i = 0; i < 81; i++) i < 16 ? solution[i] : 0];
    final code = puzzleCode(
      SudokuPuzzle(level: 1, givens: givens, solution: solution),
    );
    expect(puzzleFromCode(code), isNull);
  });
}
