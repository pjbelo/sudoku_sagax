import 'dart:math';

import 'sudoku_generator.dart';

/// Seconds added to the clock for each hint used.
const hintPenaltySeconds = 30;

/// Formats [seconds] as `m:ss`, or `h:mm:ss` from one hour up.
String formatTime(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = (seconds % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
}

/// Outcome of entering a digit in value mode.
enum EntryResult { ignored, correct, wrong, cleared }

/// Snapshot of the editable state, pushed before every undoable change.
class _Snapshot {
  _Snapshot(List<int> values, List<int> notes)
    : values = List.of(values),
      notes = List.of(notes);

  final List<int> values;
  final List<int> notes;
}

/// The state of one game in progress: player entries, pencil notes, hints,
/// mistakes and undo history. Holds no timing or UI state.
class SudokuGame {
  SudokuGame(this.puzzle)
    : values = List.of(puzzle.givens),
      notes = List.filled(81, 0),
      hinted = List.filled(81, false);

  final SudokuPuzzle puzzle;

  /// Current digit per cell (0 = empty), givens included.
  final List<int> values;

  /// Pencil notes per cell as a bitmask: bit (d - 1) set means d is noted.
  final List<int> notes;

  /// Cells filled by a hint. They are locked like givens.
  final List<bool> hinted;

  int mistakes = 0;
  int hintsUsed = 0;

  final List<_Snapshot> _history = [];

  List<int> get solution => puzzle.solution;

  bool isGiven(int i) => puzzle.givens[i] != 0;

  /// Givens and hinted cells cannot be edited.
  bool isLocked(int i) => isGiven(i) || hinted[i];

  bool isWrong(int i) => values[i] != 0 && values[i] != solution[i];

  bool hasNote(int i, int digit) => notes[i] & (1 << (digit - 1)) != 0;

  bool get isFull => !values.contains(0);

  bool get isSolved {
    for (int i = 0; i < 81; i++) {
      if (values[i] != solution[i]) return false;
    }
    return true;
  }

  bool get canUndo => _history.isNotEmpty;

  /// How many times [digit] appears on the board.
  int placedCount(int digit) => values.where((v) => v == digit).length;

  void _remember() => _history.add(_Snapshot(values, notes));

  /// Value mode: writes [digit] into cell [i]. Entering the digit already in
  /// the cell clears it. Placing a digit removes it from the notes of every
  /// cell in the same row, column and box.
  EntryResult enterDigit(int i, int digit) {
    if (isLocked(i)) return EntryResult.ignored;
    _remember();
    if (values[i] == digit) {
      values[i] = 0;
      return EntryResult.cleared;
    }
    values[i] = digit;
    notes[i] = 0;
    final bit = 1 << (digit - 1);
    for (final p in peers[i]) {
      notes[p] &= ~bit;
    }
    if (digit != solution[i]) {
      mistakes++;
      return EntryResult.wrong;
    }
    return EntryResult.correct;
  }

  /// Notes mode: toggles [digit] as a candidate in cell [i]. Only empty,
  /// editable cells take notes. Returns whether anything changed.
  bool toggleNote(int i, int digit) {
    if (isLocked(i) || values[i] != 0) return false;
    _remember();
    notes[i] ^= 1 << (digit - 1);
    return true;
  }

  /// Clears the digit, or the notes if there is no digit, of cell [i].
  bool erase(int i) {
    if (isLocked(i) || (values[i] == 0 && notes[i] == 0)) return false;
    _remember();
    if (values[i] != 0) {
      values[i] = 0;
    } else {
      notes[i] = 0;
    }
    return true;
  }

  /// Fills one cell with its correct digit and locks it. Uses [preferred]
  /// when it is an editable cell that isn't already correct; otherwise picks
  /// a random empty or wrong cell. Returns the filled cell, or null if none.
  int? hint({int? preferred, Random? rng}) {
    int? target;
    if (preferred != null &&
        !isLocked(preferred) &&
        values[preferred] != solution[preferred]) {
      target = preferred;
    } else {
      final open = [
        for (int i = 0; i < 81; i++)
          if (!isLocked(i) && values[i] != solution[i]) i,
      ];
      if (open.isEmpty) return null;
      target = open[(rng ?? Random()).nextInt(open.length)];
    }
    _fillCorrect(target);
    hintsUsed++;
    return target;
  }

  void _fillCorrect(int i) {
    final digit = solution[i];
    values[i] = digit;
    notes[i] = 0;
    hinted[i] = true;
    final bit = 1 << (digit - 1);
    for (final p in peers[i]) {
      notes[p] &= ~bit;
    }
  }

  /// Reverts the last entry, note or erase. Hints are not undone: their
  /// time penalty is already paid, so hinted cells keep their digit.
  bool undo() {
    if (_history.isEmpty) return false;
    final snap = _history.removeLast();
    values.setAll(0, snap.values);
    notes.setAll(0, snap.notes);
    for (int i = 0; i < 81; i++) {
      if (hinted[i]) _fillCorrect(i);
    }
    return true;
  }
}
