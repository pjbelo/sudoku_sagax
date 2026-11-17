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

  /// Rebuilds a game saved with [toJson]. Throws when the data is
  /// incomplete or damaged (a [FormatException] or a type error).
  factory SudokuGame.fromJson(Map<String, dynamic> json) {
    List<int> numbers(String key) {
      final list = List<int>.from(json[key] as List);
      if (list.length != 81) throw FormatException('$key needs 81 cells');
      return list;
    }

    final level = json['level'] as int;
    if (level < 1 || level > sudokuLevels.length) {
      throw FormatException('Unknown level $level');
    }
    final hinted = List<bool>.from(json['hinted'] as List);
    if (hinted.length != 81) throw const FormatException('hinted needs 81');

    final game = SudokuGame(
      SudokuPuzzle(
        level: level,
        givens: numbers('givens'),
        solution: numbers('solution'),
      ),
    );
    game.values.setAll(0, numbers('values'));
    game.notes.setAll(0, numbers('notes'));
    game.hinted.setAll(0, hinted);
    game.mistakes = json['mistakes'] as int;
    game.hintsUsed = json['hintsUsed'] as int;
    return game;
  }

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

  /// States undone, newest last, for redo. Any new change empties it.
  final List<_Snapshot> _redoHistory = [];

  List<int> get solution => puzzle.solution;

  bool isGiven(int i) => puzzle.givens[i] != 0;

  /// Givens and hinted cells cannot be edited.
  bool isLocked(int i) => isGiven(i) || hinted[i];

  bool isWrong(int i) => values[i] != 0 && values[i] != solution[i];

  bool hasNote(int i, int digit) => notes[i] & (1 << (digit - 1)) != 0;

  /// Whether the digit in cell [i] also appears in its row, column or box.
  /// Unlike [isWrong], it doesn't look at the solution.
  bool hasConflict(int i) {
    final digit = values[i];
    if (digit == 0) return false;
    for (final p in peers[i]) {
      if (values[p] == digit) return true;
    }
    return false;
  }

  bool get isFull => !values.contains(0);

  bool get isSolved {
    for (int i = 0; i < 81; i++) {
      if (values[i] != solution[i]) return false;
    }
    return true;
  }

  bool get canUndo => _history.isNotEmpty;

  bool get canRedo => _redoHistory.isNotEmpty;

  /// Whether the player has done anything yet: a digit, a note, a hint or a
  /// mistake. A game without progress isn't worth saving.
  bool get hasProgress {
    if (hintsUsed > 0 || mistakes > 0) return true;
    for (int i = 0; i < 81; i++) {
      if (values[i] != puzzle.givens[i] || notes[i] != 0) return true;
    }
    return false;
  }

  /// How many times [digit] appears on the board.
  int placedCount(int digit) => values.where((v) => v == digit).length;

  /// The digits not yet placed in the row, column and box of cell [i], as a
  /// bitmask like [notes]. Wrong entries count too: it is what the player
  /// sees on the board, not the solution.
  int candidates(int i) {
    var mask = 0x1FF; // all nine digits
    for (final p in peers[i]) {
      if (values[p] != 0) mask &= ~(1 << (values[p] - 1));
    }
    return mask;
  }

  /// Saves the state for undo, before a change. A new change also ends what
  /// redo could bring back.
  void _remember() {
    _history.add(_Snapshot(values, notes));
    _redoHistory.clear();
  }

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

  /// Writes every candidate of every empty, editable cell into its notes,
  /// replacing the notes that were there. One undo step. Returns whether
  /// anything changed.
  bool fillNotes() {
    final filled = [
      for (int i = 0; i < 81; i++)
        isLocked(i) || values[i] != 0 ? notes[i] : candidates(i),
    ];
    bool changed = false;
    for (int i = 0; i < 81; i++) {
      if (filled[i] != notes[i]) changed = true;
    }
    if (!changed) return false;
    _remember();
    notes.setAll(0, filled);
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
    applyHint(target);
    return target;
  }

  /// Fills cell [i] with its correct digit and locks it, as a hint. The
  /// candidates in [noteRemovals] (cell → digits mask), ruled out by the
  /// coach's step, are taken out of the notes too.
  void applyHint(int i, {Map<int, int> noteRemovals = const {}}) {
    noteRemovals.forEach((cell, mask) => notes[cell] &= ~mask);
    _fillCorrect(i);
    hintsUsed++;
    _redoHistory.clear(); // a hint is a new change too
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

  /// Reverts the last entry, note, erase or note filling. Hints are not
  /// undone: their time penalty is already paid, so hinted cells keep their
  /// digit.
  bool undo() {
    if (_history.isEmpty) return false;
    _redoHistory.add(_Snapshot(values, notes));
    _restore(_history.removeLast());
    return true;
  }

  /// Brings back the last change that [undo] reverted. Mistakes aren't
  /// counted again.
  bool redo() {
    if (_redoHistory.isEmpty) return false;
    _history.add(_Snapshot(values, notes));
    _restore(_redoHistory.removeLast());
    return true;
  }

  void _restore(_Snapshot snap) {
    values.setAll(0, snap.values);
    notes.setAll(0, snap.notes);
    for (int i = 0; i < 81; i++) {
      if (hinted[i]) _fillCorrect(i);
    }
  }

  /// The game as JSON-friendly data, to keep it on the device. The undo and
  /// redo history is left out, so a resumed game starts with an empty one.
  Map<String, Object> toJson() => {
    'level': puzzle.level,
    'givens': puzzle.givens,
    'solution': puzzle.solution,
    'values': values,
    'notes': notes,
    'hinted': hinted,
    'mistakes': mistakes,
    'hintsUsed': hintsUsed,
  };
}
