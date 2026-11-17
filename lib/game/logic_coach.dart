import 'sudoku_game.dart';
import 'sudoku_generator.dart';

// ============================================================
// Sudoku Sagax — logic coach (pure Dart, no Flutter)
// ============================================================
//
// Finds the next step a person could take, with the simplest named
// technique that works, so a hint can explain it instead of just filling a
// cell. Candidates are 9-bit masks, as in the generator: bit (d - 1) set
// means digit d is still possible.

/// The techniques the coach explains, from the simplest to the hardest.
enum CoachTechnique {
  /// A digit fits in only one cell of a row, column or box.
  hiddenSingle,

  /// A cell can hold only one digit.
  nakedSingle,

  /// In a box, a digit fits only in one row or column, so it is ruled out
  /// in the rest of that row or column.
  pointingPair,

  /// In a row or column, a digit fits only in one box, so it is ruled out
  /// in the rest of that box.
  boxLineReduction,

  /// Two cells of a unit can hold only the same two digits.
  nakedPair,

  /// Two digits fit only in the same two cells of a unit.
  hiddenPair,

  /// Three cells of a unit can hold only the same three digits.
  nakedTriple,

  /// In two rows (or columns), a digit fits only in the same two columns
  /// (or rows).
  xWing,

  /// A digit the player entered is wrong (not a technique: fixed first).
  mistake,

  /// None of the techniques above helps: a digit from the solution.
  fromSolution,
}

enum UnitKind { row, column, box }

/// A row, column or box, numbered 0 to 8.
class UnitRef {
  const UnitRef(this.kind, this.index);

  final UnitKind kind;
  final int index;

  /// The 9 cells, from the generator's [units] (rows, then columns, boxes).
  List<int> get cells {
    final first = switch (kind) {
      UnitKind.row => 0,
      UnitKind.column => 9,
      UnitKind.box => 18,
    };
    return units[first + index];
  }
}

UnitRef rowRefOf(int cell) => UnitRef(UnitKind.row, rowOf(cell));
UnitRef columnRefOf(int cell) => UnitRef(UnitKind.column, colOf(cell));
UnitRef boxRefOf(int cell) => UnitRef(UnitKind.box, boxOf(cell));

/// All 27 units, boxes first: people scan boxes most easily.
final List<UnitRef> _allUnits = [
  for (int i = 0; i < 9; i++) UnitRef(UnitKind.box, i),
  for (int i = 0; i < 9; i++) UnitRef(UnitKind.row, i),
  for (int i = 0; i < 9; i++) UnitRef(UnitKind.column, i),
];

/// One use of an elimination technique: candidates it rules out.
class Elimination {
  const Elimination({
    required this.technique,
    required this.digits,
    required this.patternCells,
    required this.units,
    required this.removals,
  });

  final CoachTechnique technique;

  /// The digit or digits of the pattern, in increasing order.
  final List<int> digits;

  /// The cells that form the pattern.
  final List<int> patternCells;

  /// The units involved; the first is where the pattern is found. For an
  /// X-Wing: the two base lines, then the two crossing lines.
  final List<UnitRef> units;

  /// Ruled-out candidates: cell → digits mask.
  final Map<int, int> removals;
}

/// A placement found by a single, with the unit for a hidden single.
class _Single {
  const _Single(this.technique, this.cell, this.digit, [this.unit]);

  final CoachTechnique technique;
  final int cell;
  final int digit;
  final UnitRef? unit;
}

/// The next step for the player: the digit for [cell], and how to find it.
class CoachStep {
  const CoachStep({
    required this.cell,
    required this.digit,
    required this.singleTechnique,
    required this.candidates,
    this.singleUnit,
    this.eliminations = const [],
    this.wrongDigit = 0,
  });

  /// The cell to fill (or to correct, for a mistake).
  final int cell;

  /// Its correct digit.
  final int digit;

  /// How the digit is found once the eliminations are made:
  /// [CoachTechnique.hiddenSingle], [CoachTechnique.nakedSingle],
  /// [CoachTechnique.mistake] or [CoachTechnique.fromSolution].
  final CoachTechnique singleTechnique;

  /// The unit of a hidden single.
  final UnitRef? singleUnit;

  /// The eliminations needed before the single, in order (often none).
  final List<Elimination> eliminations;

  /// The wrong digit in [cell], for a mistake.
  final int wrongDigit;

  /// The candidates of every cell before the step (0 for filled cells).
  final List<int> candidates;

  /// The technique the hint is named after: the hardest one used.
  CoachTechnique get technique {
    var hardest = singleTechnique;
    for (final e in eliminations) {
      if (e.technique.index > hardest.index) hardest = e.technique;
    }
    return hardest;
  }

  /// Where the player should look first.
  UnitRef get lookAt {
    if (eliminations.isNotEmpty) return eliminations.first.units.first;
    return singleUnit ?? boxRefOf(cell);
  }

  /// All the candidates the step rules out: cell → digits mask.
  Map<int, int> get removals {
    final all = <int, int>{};
    for (final e in eliminations) {
      e.removals.forEach((c, mask) => all[c] = (all[c] ?? 0) | mask);
    }
    return all;
  }

  /// The units the explanation talks about, as one set of cells.
  Set<int> get areaCells => {
    ...lookAt.cells,
    for (final e in eliminations)
      for (final unit in e.units) ...unit.cells,
    ...?singleUnit?.cells,
  };

  /// The cells of the patterns, and the cell to fill.
  Set<int> get focusCells => {
    for (final e in eliminations) ...e.patternCells,
    cell,
  };

  /// The cells that lose candidates.
  Set<int> get removedCells => removals.keys.toSet();

  /// Candidates to show while explaining: the pattern cells as they were,
  /// and the cell to fill once the eliminations are made.
  Map<int, int> get candidatesToShow {
    if (singleTechnique == CoachTechnique.mistake ||
        singleTechnique == CoachTechnique.fromSolution) {
      return const {};
    }
    final shown = <int, int>{
      for (final e in eliminations)
        for (final c in e.patternCells) c: candidates[c],
    };
    final removed = removals[cell] ?? 0;
    shown[cell] = candidates[cell] & ~removed;
    return shown;
  }
}

// --- Helpers ---

int bitCount(int mask) {
  var count = 0;
  for (var m = mask; m != 0; m &= m - 1) {
    count++;
  }
  return count;
}

/// The digits in [mask], in increasing order.
List<int> digitsOf(int mask) => [
  for (int d = 1; d <= 9; d++)
    if (mask & (1 << (d - 1)) != 0) d,
];

int _bit(int digit) => 1 << (digit - 1);

/// The candidates of every cell from the digits on the board (0 for filled
/// cells).
List<int> candidateGrid(List<int> values) => [
  for (int i = 0; i < 81; i++)
    if (values[i] != 0) 0 else _candidatesOf(values, i),
];

int _candidatesOf(List<int> values, int i) {
  var mask = 0x1FF;
  for (final p in peers[i]) {
    if (values[p] != 0) mask &= ~_bit(values[p]);
  }
  return mask;
}

// --- Singles ---

/// Every single on the grid: hidden singles (boxes, rows, columns), then
/// naked singles.
List<_Single> _allSingles(List<int> cand) {
  final found = <_Single>[];
  for (final unit in _allUnits) {
    for (int d = 1; d <= 9; d++) {
      final cells = unit.cells.where((c) => cand[c] & _bit(d) != 0).toList();
      if (cells.length == 1) {
        found.add(_Single(CoachTechnique.hiddenSingle, cells.first, d, unit));
      }
    }
  }
  for (int i = 0; i < 81; i++) {
    if (bitCount(cand[i]) == 1) {
      found.add(
        _Single(CoachTechnique.nakedSingle, i, digitsOf(cand[i]).first),
      );
    }
  }
  return found;
}

/// The first single, preferring one for the [preferred] cell.
_Single? _findSingle(List<int> cand, int? preferred) {
  final singles = _allSingles(cand);
  if (singles.isEmpty) return null;
  for (final s in singles) {
    if (s.cell == preferred) return s;
  }
  return singles.first;
}

// --- Eliminations ---

/// In a box, a digit only in one row or column: out of the rest of it.
List<Elimination> _pointing(List<int> cand) {
  final found = <Elimination>[];
  for (int b = 0; b < 9; b++) {
    final box = UnitRef(UnitKind.box, b);
    for (int d = 1; d <= 9; d++) {
      final cells = box.cells.where((c) => cand[c] & _bit(d) != 0).toList();
      if (cells.length < 2 || cells.length > 3) continue;
      for (final line in [rowRefOf(cells.first), columnRefOf(cells.first)]) {
        if (!cells.every((c) => line.cells.contains(c))) continue;
        final removals = {
          for (final c in line.cells)
            if (boxOf(c) != b && cand[c] & _bit(d) != 0) c: _bit(d),
        };
        if (removals.isEmpty) continue;
        found.add(
          Elimination(
            technique: CoachTechnique.pointingPair,
            digits: [d],
            patternCells: cells,
            units: [box, line],
            removals: removals,
          ),
        );
      }
    }
  }
  return found;
}

/// In a row or column, a digit only in one box: out of the rest of the box.
List<Elimination> _boxLine(List<int> cand) {
  final found = <Elimination>[];
  for (final line in _allUnits.where((u) => u.kind != UnitKind.box)) {
    for (int d = 1; d <= 9; d++) {
      final cells = line.cells.where((c) => cand[c] & _bit(d) != 0).toList();
      if (cells.length < 2 || cells.length > 3) continue;
      final box = boxRefOf(cells.first);
      if (!cells.every((c) => boxOf(c) == box.index)) continue;
      final removals = {
        for (final c in box.cells)
          if (!line.cells.contains(c) && cand[c] & _bit(d) != 0) c: _bit(d),
      };
      if (removals.isEmpty) continue;
      found.add(
        Elimination(
          technique: CoachTechnique.boxLineReduction,
          digits: [d],
          patternCells: cells,
          units: [line, box],
          removals: removals,
        ),
      );
    }
  }
  return found;
}

/// Two cells of a unit with the same two candidates: out of the others.
List<Elimination> _nakedPairs(List<int> cand) {
  final found = <Elimination>[];
  for (final unit in _allUnits) {
    final cells = unit.cells;
    for (int a = 0; a < 9; a++) {
      final mask = cand[cells[a]];
      if (bitCount(mask) != 2) continue;
      for (int b = a + 1; b < 9; b++) {
        if (cand[cells[b]] != mask) continue;
        final pair = [cells[a], cells[b]];
        final removals = {
          for (final c in cells)
            if (!pair.contains(c) && cand[c] & mask != 0) c: cand[c] & mask,
        };
        if (removals.isEmpty) continue;
        found.add(
          Elimination(
            technique: CoachTechnique.nakedPair,
            digits: digitsOf(mask),
            patternCells: pair,
            units: [unit],
            removals: removals,
          ),
        );
      }
    }
  }
  return found;
}

/// Two digits only in the same two cells of a unit: those cells hold
/// nothing else.
List<Elimination> _hiddenPairs(List<int> cand) {
  final found = <Elimination>[];
  for (final unit in _allUnits) {
    // For each digit, the cells of the unit where it fits (index 0 unused).
    final cellsWith = [
      for (int d = 0; d <= 9; d++)
        d == 0
            ? const <int>[]
            : unit.cells.where((c) => cand[c] & _bit(d) != 0).toList(),
    ];
    for (int a = 1; a <= 9; a++) {
      final cellsA = cellsWith[a];
      if (cellsA.length != 2) continue;
      for (int b = a + 1; b <= 9; b++) {
        final cellsB = cellsWith[b];
        if (cellsB.length != 2 ||
            cellsB[0] != cellsA[0] ||
            cellsB[1] != cellsA[1]) {
          continue;
        }
        final keep = _bit(a) | _bit(b);
        final removals = {
          for (final c in cellsA)
            if (cand[c] & ~keep != 0) c: cand[c] & ~keep,
        };
        if (removals.isEmpty) continue;
        found.add(
          Elimination(
            technique: CoachTechnique.hiddenPair,
            digits: [a, b],
            patternCells: cellsA,
            units: [unit],
            removals: removals,
          ),
        );
      }
    }
  }
  return found;
}

/// Three cells of a unit whose candidates are the same three digits: out
/// of the others.
List<Elimination> _nakedTriples(List<int> cand) {
  final found = <Elimination>[];
  for (final unit in _allUnits) {
    final open = unit.cells.where((c) {
      final n = bitCount(cand[c]);
      return n == 2 || n == 3;
    }).toList();
    for (int a = 0; a < open.length; a++) {
      for (int b = a + 1; b < open.length; b++) {
        for (int c = b + 1; c < open.length; c++) {
          final triple = [open[a], open[b], open[c]];
          final mask = cand[open[a]] | cand[open[b]] | cand[open[c]];
          if (bitCount(mask) != 3) continue;
          final removals = {
            for (final cell in unit.cells)
              if (!triple.contains(cell) && cand[cell] & mask != 0)
                cell: cand[cell] & mask,
          };
          if (removals.isEmpty) continue;
          found.add(
            Elimination(
              technique: CoachTechnique.nakedTriple,
              digits: digitsOf(mask),
              patternCells: triple,
              units: [unit],
              removals: removals,
            ),
          );
        }
      }
    }
  }
  return found;
}

/// In two rows a digit only in the same two columns (or the other way
/// round): out of the rest of those columns.
List<Elimination> _xWings(List<int> cand) {
  final found = <Elimination>[];
  for (final base in [UnitKind.row, UnitKind.column]) {
    final cross = base == UnitKind.row ? UnitKind.column : UnitKind.row;
    // The position of a cell along a base line: its column or its row.
    int crossIndex(int cell) =>
        base == UnitKind.row ? colOf(cell) : rowOf(cell);
    for (int d = 1; d <= 9; d++) {
      // For each base line where d fits in exactly two cells: those cells.
      final lines = <int, List<int>>{};
      for (int i = 0; i < 9; i++) {
        final cells = UnitRef(
          base,
          i,
        ).cells.where((c) => cand[c] & _bit(d) != 0).toList();
        if (cells.length == 2) lines[i] = cells;
      }
      final indexes = lines.keys.toList();
      for (int a = 0; a < indexes.length; a++) {
        for (int b = a + 1; b < indexes.length; b++) {
          final first = lines[indexes[a]]!;
          final second = lines[indexes[b]]!;
          if (crossIndex(first[0]) != crossIndex(second[0]) ||
              crossIndex(first[1]) != crossIndex(second[1])) {
            continue;
          }
          final pattern = [...first, ...second];
          final crossLines = [
            UnitRef(cross, crossIndex(first[0])),
            UnitRef(cross, crossIndex(first[1])),
          ];
          final removals = {
            for (final line in crossLines)
              for (final c in line.cells)
                if (!pattern.contains(c) && cand[c] & _bit(d) != 0) c: _bit(d),
          };
          if (removals.isEmpty) continue;
          found.add(
            Elimination(
              technique: CoachTechnique.xWing,
              digits: [d],
              patternCells: pattern,
              units: [
                UnitRef(base, indexes[a]),
                UnitRef(base, indexes[b]),
                ...crossLines,
              ],
              removals: removals,
            ),
          );
        }
      }
    }
  }
  return found;
}

/// The elimination techniques, simplest first.
final List<List<Elimination> Function(List<int>)> _eliminationFinders = [
  _pointing,
  _boxLine,
  _nakedPairs,
  _hiddenPairs,
  _nakedTriples,
  _xWings,
];

/// Every use of the elimination [technique] on the candidates [cand]. Also
/// used by the tests, with candidates made up by hand.
List<Elimination> eliminationsFor(CoachTechnique technique, List<int> cand) =>
    switch (technique) {
      CoachTechnique.pointingPair => _pointing(cand),
      CoachTechnique.boxLineReduction => _boxLine(cand),
      CoachTechnique.nakedPair => _nakedPairs(cand),
      CoachTechnique.hiddenPair => _hiddenPairs(cand),
      CoachTechnique.nakedTriple => _nakedTriples(cand),
      CoachTechnique.xWing => _xWings(cand),
      _ => const [],
    };

List<int> _apply(List<int> cand, Iterable<Elimination> eliminations) {
  final result = List.of(cand);
  for (final e in eliminations) {
    e.removals.forEach((c, mask) => result[c] &= ~mask);
  }
  return result;
}

/// Eliminations made one after another with [finders] (the first one found
/// by the simplest finder each time) until a single opens; then cut down to
/// the ones the single needs. Null when no single opens.
List<Elimination>? _chainToSingle(
  List<int> cand,
  List<List<Elimination> Function(List<int>)> finders,
  int? target,
) {
  final chain = <Elimination>[];
  var work = cand;
  for (int round = 0; round < 60; round++) {
    Elimination? next;
    for (final finder in finders) {
      final found = finder(work);
      if (found.isNotEmpty) {
        next = found.first;
        break;
      }
    }
    if (next == null) return null;
    chain.add(next);
    work = _apply(work, [next]);
    if (_findSingle(work, target) != null) {
      // Leave out the links the single doesn't need.
      for (final link in List.of(chain)) {
        final without = chain.where((e) => e != link).toList();
        if (_findSingle(_apply(cand, without), target) != null) {
          chain.remove(link);
        }
      }
      return chain;
    }
  }
  return null;
}

// --- The next step ---

/// The next step for [game], or null when the grid is solved. Prefers a
/// step for the [preferred] cell (the one the player selected).
///
/// A wrong digit comes first: logic from a wrong grid would mislead. Then
/// a single; then, technique by technique from the simplest, one
/// elimination that leads to a single or a chain of them, cut down to the
/// ones that matter. When nothing works, a digit from the solution.
CoachStep? findCoachStep(SudokuGame game, {int? preferred}) {
  final values = game.values;

  final wrong = [
    for (int i = 0; i < 81; i++)
      if (game.isWrong(i)) i,
  ];
  if (wrong.isNotEmpty) {
    final cell = wrong.contains(preferred) ? preferred! : wrong.first;
    return CoachStep(
      cell: cell,
      digit: game.solution[cell],
      singleTechnique: CoachTechnique.mistake,
      wrongDigit: values[cell],
      candidates: candidateGrid(values),
    );
  }
  if (!values.contains(0)) return null;

  final cand = candidateGrid(values);
  final target = preferred != null && values[preferred] == 0 ? preferred : null;
  CoachStep stepFor(_Single single, List<Elimination> eliminations) =>
      CoachStep(
        cell: single.cell,
        digit: single.digit,
        singleTechnique: single.technique,
        singleUnit: single.unit,
        eliminations: eliminations,
        candidates: cand,
      );

  // 1. A single.
  final single = _findSingle(cand, target);
  if (single != null) return stepFor(single, const []);

  // 2. Technique by technique, simplest first: one elimination of it that
  // opens a single, else a chain that uses nothing harder. So the hardest
  // technique explained is never more than the grid needs.
  for (int tier = 0; tier < _eliminationFinders.length; tier++) {
    for (final e in _eliminationFinders[tier](cand)) {
      final s = _findSingle(_apply(cand, [e]), target);
      if (s != null) return stepFor(s, [e]);
    }
    final chain = _chainToSingle(
      cand,
      _eliminationFinders.sublist(0, tier + 1),
      target,
    );
    if (chain != null) {
      return stepFor(_findSingle(_apply(cand, chain), target)!, chain);
    }
  }

  // 3. Nothing the coach knows: the open cell with the fewest candidates.
  var cell = target;
  if (cell == null) {
    for (int i = 0; i < 81; i++) {
      if (values[i] != 0) continue;
      if (cell == null || bitCount(cand[i]) < bitCount(cand[cell])) cell = i;
    }
  }
  return CoachStep(
    cell: cell!,
    digit: game.solution[cell],
    singleTechnique: CoachTechnique.fromSolution,
    candidates: cand,
  );
}

// --- Grading ---

/// The hardest technique needed to solve [givens] by logic, always using
/// the simplest technique that makes progress; null when the coach's
/// techniques can't finish it (or would need one harder than [limit]).
///
/// Any grid it finishes has a single solution, since every step is a sound
/// deduction. Used by the generator to grade the levels.
CoachTechnique? hardestTechnique(
  List<int> givens, {
  CoachTechnique limit = CoachTechnique.xWing,
}) {
  final values = List.of(givens);
  final cand = candidateGrid(values);
  var hardest = CoachTechnique.hiddenSingle;
  final finders = [
    for (final technique in _eliminationTechniques)
      if (technique.index <= limit.index) technique,
  ];

  void place(int cell, int digit) {
    values[cell] = digit;
    cand[cell] = 0;
    for (final p in peers[cell]) {
      cand[p] &= ~_bit(digit);
    }
  }

  var empty = values.where((v) => v == 0).length;
  while (empty > 0) {
    // A cell left without candidates: the grid has no solution.
    for (int i = 0; i < 81; i++) {
      if (values[i] == 0 && cand[i] == 0) return null;
    }
    final singles = _allSingles(cand);
    if (singles.isNotEmpty) {
      for (final single in singles) {
        if (values[single.cell] != 0) continue;
        if (cand[single.cell] & _bit(single.digit) == 0) return null;
        place(single.cell, single.digit);
        empty--;
        if (single.technique.index > hardest.index) {
          hardest = single.technique;
        }
      }
      continue;
    }
    // No single: the simplest elimination that applies, everywhere.
    var progress = false;
    for (final technique in finders) {
      final found = eliminationsFor(technique, cand);
      if (found.isEmpty) continue;
      for (final e in found) {
        e.removals.forEach((c, mask) => cand[c] &= ~mask);
      }
      if (technique.index > hardest.index) hardest = technique;
      progress = true;
      break;
    }
    if (!progress) return null;
  }
  return hardest;
}

/// The elimination techniques, simplest first (as [_eliminationFinders]).
const _eliminationTechniques = [
  CoachTechnique.pointingPair,
  CoachTechnique.boxLineReduction,
  CoachTechnique.nakedPair,
  CoachTechnique.hiddenPair,
  CoachTechnique.nakedTriple,
  CoachTechnique.xWing,
];

/// The hardest techniques a level of [technique] accepts, as (simplest,
/// hardest): its puzzles need one of them and nothing harder.
(CoachTechnique, CoachTechnique) techniqueRange(SudokuTechnique technique) =>
    switch (technique) {
      SudokuTechnique.singles => (
        CoachTechnique.hiddenSingle,
        CoachTechnique.nakedSingle,
      ),
      SudokuTechnique.lockedCandidates => (
        CoachTechnique.pointingPair,
        CoachTechnique.boxLineReduction,
      ),
      SudokuTechnique.pairs => (
        CoachTechnique.nakedPair,
        CoachTechnique.hiddenPair,
      ),
      SudokuTechnique.triples => (
        CoachTechnique.nakedTriple,
        CoachTechnique.nakedTriple,
      ),
      SudokuTechnique.xWing => (CoachTechnique.xWing, CoachTechnique.xWing),
    };

/// Whether a puzzle whose [hardest] technique is this (null: beyond the
/// coach) fits a level of [technique].
bool meetsLevel(SudokuTechnique technique, CoachTechnique? hardest) {
  if (hardest == null) return false;
  final (simplest, hardestAllowed) = techniqueRange(technique);
  return hardest.index >= simplest.index &&
      hardest.index <= hardestAllowed.index;
}
