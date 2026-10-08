import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';

void main() {
  late SudokuGame game;
  late int empty; // first empty cell

  setUp(() {
    game = SudokuGame(generatePuzzle(3, seed: 7));
    empty = game.values.indexOf(0);
  });

  int wrongDigitFor(int i) => game.solution[i] % 9 + 1;

  test('formatTime', () {
    expect(formatTime(0), '0:00');
    expect(formatTime(65), '1:05');
    expect(formatTime(3600 + 62), '1:01:02');
  });

  test('givens are locked', () {
    final given = game.values.indexWhere((v) => v != 0);
    expect(game.isLocked(given), isTrue);
    expect(game.enterDigit(given, 1), EntryResult.ignored);
    expect(game.erase(given), isFalse);
    expect(game.canUndo, isFalse);
  });

  test('correct and wrong entries; mistakes counted', () {
    expect(game.enterDigit(empty, game.solution[empty]), EntryResult.correct);
    expect(game.isWrong(empty), isFalse);
    expect(game.mistakes, 0);

    expect(game.enterDigit(empty, wrongDigitFor(empty)), EntryResult.wrong);
    expect(game.isWrong(empty), isTrue);
    expect(game.mistakes, 1);
  });

  test('entering the same digit again clears the cell', () {
    final d = game.solution[empty];
    game.enterDigit(empty, d);
    expect(game.enterDigit(empty, d), EntryResult.cleared);
    expect(game.values[empty], 0);
  });

  test('notes toggle, and placing a digit clears it from peers', () {
    final peer = peers[empty].firstWhere((p) => game.values[p] == 0);
    final d = game.solution[empty];

    expect(game.toggleNote(peer, d), isTrue);
    expect(game.hasNote(peer, d), isTrue);
    game.toggleNote(empty, 1);
    game.toggleNote(empty, 2);

    game.enterDigit(empty, d);
    expect(game.notes[empty], 0, reason: 'own notes cleared');
    expect(game.hasNote(peer, d), isFalse, reason: 'peer note removed');

    // Filled cells take no notes.
    expect(game.toggleNote(empty, 3), isFalse);
  });

  test('erase clears the digit first, then the notes', () {
    game.toggleNote(empty, 4);
    expect(game.erase(empty), isTrue);
    expect(game.notes[empty], 0);
    expect(game.erase(empty), isFalse);
  });

  test('undo reverts entries and notes', () {
    game.toggleNote(empty, 5);
    game.enterDigit(empty, wrongDigitFor(empty));
    expect(game.undo(), isTrue);
    expect(game.values[empty], 0);
    expect(game.hasNote(empty, 5), isTrue);
    expect(game.undo(), isTrue);
    expect(game.notes[empty], 0);
    expect(game.undo(), isFalse);
  });

  test('hint fills the preferred cell and locks it', () {
    game.enterDigit(empty, wrongDigitFor(empty));
    expect(game.hint(preferred: empty), empty);
    expect(game.values[empty], game.solution[empty]);
    expect(game.isLocked(empty), isTrue);
    expect(game.hintsUsed, 1);
  });

  test('hint picks another cell when the preferred one is done', () {
    final given = game.values.indexWhere((v) => v != 0);
    final cell = game.hint(preferred: given, rng: Random(1));
    expect(cell, isNotNull);
    expect(cell, isNot(given));
    expect(game.puzzle.givens[cell!], 0);
  });

  test('undo keeps hinted cells', () {
    game.enterDigit(empty, wrongDigitFor(empty));
    game.hint(preferred: empty);
    game.undo(); // reverts the wrong entry made before the hint
    expect(game.values[empty], game.solution[empty]);
  });

  test('solving the whole grid', () {
    for (int i = 0; i < 81; i++) {
      if (!game.isLocked(i)) game.enterDigit(i, game.solution[i]);
    }
    expect(game.isFull, isTrue);
    expect(game.isSolved, isTrue);
    expect(game.hint(), isNull);
  });

  test('a full grid with a mistake is not solved', () {
    for (int i = 0; i < 81; i++) {
      if (!game.isLocked(i)) game.enterDigit(i, game.solution[i]);
    }
    game.enterDigit(empty, wrongDigitFor(empty));
    expect(game.isFull, isTrue);
    expect(game.isSolved, isFalse);
  });
}
