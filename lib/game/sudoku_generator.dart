import 'dart:math';

// ============================================================
// Sudoku Sagax — puzzle solver and generator (pure Dart, no Flutter)
// ============================================================
//
// A board is a flat List<int> of 81 cells, row by row; 0 means empty.
// Candidates are 9-bit masks: bit (d - 1) set means digit d is possible.

/// Difficulty band shown to the player; levels share a band in pairs.
enum SudokuBand { beginner, easy, medium, hard, expert }

/// How one of the 9 levels is generated.
class SudokuLevel {
  const SudokuLevel({
    required this.level,
    required this.clues,
    required this.band,
    required this.technique,
  });

  final int level;

  /// Target number of given digits. Fewer givens means a harder puzzle.
  final int clues;
  final SudokuBand band;
  final SudokuTechnique technique;
}

/// What it takes to solve a level, from the player's point of view.
enum SudokuTechnique {
  /// Solvable with naked and hidden singles alone: every step is
  /// "this cell can only be X" or "X can only go here".
  singles,

  /// Any puzzle with a unique solution.
  unique,

  /// Unique, but singles alone get stuck: the player needs candidate
  /// elimination (pairs, pointing, …) — notes become essential.
  advanced,
}

/// The 9 difficulty levels. The level→clues mapping is the source of truth
/// for both the generator and the level selector.
const sudokuLevels = <SudokuLevel>[
  SudokuLevel(
    level: 1,
    clues: 46,
    band: SudokuBand.beginner,
    technique: SudokuTechnique.singles,
  ),
  SudokuLevel(
    level: 2,
    clues: 42,
    band: SudokuBand.beginner,
    technique: SudokuTechnique.singles,
  ),
  SudokuLevel(
    level: 3,
    clues: 38,
    band: SudokuBand.easy,
    technique: SudokuTechnique.singles,
  ),
  SudokuLevel(
    level: 4,
    clues: 35,
    band: SudokuBand.easy,
    technique: SudokuTechnique.singles,
  ),
  SudokuLevel(
    level: 5,
    clues: 32,
    band: SudokuBand.medium,
    technique: SudokuTechnique.singles,
  ),
  SudokuLevel(
    level: 6,
    clues: 30,
    band: SudokuBand.medium,
    technique: SudokuTechnique.unique,
  ),
  SudokuLevel(
    level: 7,
    clues: 28,
    band: SudokuBand.hard,
    technique: SudokuTechnique.advanced,
  ),
  SudokuLevel(
    level: 8,
    clues: 26,
    band: SudokuBand.hard,
    technique: SudokuTechnique.advanced,
  ),
  SudokuLevel(
    level: 9,
    clues: 24,
    band: SudokuBand.expert,
    technique: SudokuTechnique.advanced,
  ),
];

/// A generated puzzle and its (unique) solution.
class SudokuPuzzle {
  const SudokuPuzzle({
    required this.level,
    required this.givens,
    required this.solution,
  });

  final int level;
  final List<int> givens;
  final List<int> solution;

  int get clueCount => givens.where((v) => v != 0).length;
}

// --- Geometry ---

int rowOf(int i) => i ~/ 9;
int colOf(int i) => i % 9;
int boxOf(int i) => (i ~/ 27) * 3 + (i % 9) ~/ 3;

/// The 27 units (9 rows, 9 columns, 9 boxes) as lists of cell indices.
final List<List<int>> units = [
  for (int r = 0; r < 9; r++) [for (int c = 0; c < 9; c++) r * 9 + c],
  for (int c = 0; c < 9; c++) [for (int r = 0; r < 9; r++) r * 9 + c],
  for (int b = 0; b < 9; b++)
    [
      for (int k = 0; k < 9; k++)
        ((b ~/ 3) * 3 + k ~/ 3) * 9 + (b % 3) * 3 + k % 3,
    ],
];

/// For each cell, the 20 other cells sharing its row, column or box.
final List<List<int>> peers = List.generate(81, (i) {
  return [
    for (int j = 0; j < 81; j++)
      if (j != i &&
          (rowOf(j) == rowOf(i) ||
              colOf(j) == colOf(i) ||
              boxOf(j) == boxOf(i)))
        j,
  ];
});

const _allDigits = 0x1FF;

int _bitCount(int m) {
  var n = 0;
  while (m != 0) {
    m &= m - 1;
    n++;
  }
  return n;
}

/// Digit (1–9) of a single-bit mask.
int _digitOf(int bit) {
  var d = 1;
  while (bit > 1) {
    bit >>= 1;
    d++;
  }
  return d;
}

// --- Exhaustive solver ---

/// Backtracking search over a board, keeping per-unit masks of used digits
/// and always branching on the cell with the fewest candidates.
class _Search {
  _Search(List<int> board) : cells = List.of(board) {
    for (int i = 0; i < 81; i++) {
      final v = cells[i];
      if (v == 0) continue;
      final bit = 1 << (v - 1);
      if ((rows[rowOf(i)] | cols[colOf(i)] | boxes[boxOf(i)]) & bit != 0) {
        valid = false;
      }
      _set(i, bit);
    }
  }

  final List<int> cells;
  final rows = List.filled(9, 0);
  final cols = List.filled(9, 0);
  final boxes = List.filled(9, 0);
  bool valid = true;

  void _set(int i, int bit) {
    rows[rowOf(i)] |= bit;
    cols[colOf(i)] |= bit;
    boxes[boxOf(i)] |= bit;
  }

  void _clear(int i, int bit) {
    rows[rowOf(i)] &= ~bit;
    cols[colOf(i)] &= ~bit;
    boxes[boxOf(i)] &= ~bit;
  }

  int _candidates(int i) =>
      _allDigits & ~(rows[rowOf(i)] | cols[colOf(i)] | boxes[boxOf(i)]);

  /// Empty cell with the fewest candidates, or -1 when the board is full.
  /// Returns -2 when some empty cell has no candidate at all (dead end).
  int _pickCell() {
    var best = -1;
    var bestCount = 10;
    for (int i = 0; i < 81; i++) {
      if (cells[i] != 0) continue;
      final n = _bitCount(_candidates(i));
      if (n == 0) return -2;
      if (n < bestCount) {
        best = i;
        bestCount = n;
        if (n == 1) break;
      }
    }
    return best;
  }

  /// Counts solutions, stopping once [limit] is reached.
  int count(int limit) {
    if (!valid) return 0;
    var found = 0;
    bool walk() {
      final i = _pickCell();
      if (i == -2) return false;
      if (i == -1) return ++found >= limit;
      var mask = _candidates(i);
      while (mask != 0) {
        final bit = mask & -mask;
        mask &= mask - 1;
        cells[i] = _digitOf(bit);
        _set(i, bit);
        final stop = walk();
        _clear(i, bit);
        cells[i] = 0;
        if (stop) return true;
      }
      return false;
    }

    walk();
    return found;
  }

  /// Fills the board in place, trying candidates in random order.
  /// Returns false when no solution exists.
  bool fill(Random rng) {
    if (!valid) return false;
    bool walk() {
      final i = _pickCell();
      if (i == -2) return false;
      if (i == -1) return true;
      final options = [
        for (int d = 1; d <= 9; d++)
          if (_candidates(i) & (1 << (d - 1)) != 0) d,
      ]..shuffle(rng);
      for (final d in options) {
        final bit = 1 << (d - 1);
        cells[i] = d;
        _set(i, bit);
        if (walk()) return true;
        _clear(i, bit);
        cells[i] = 0;
      }
      return false;
    }

    return walk();
  }
}

/// Number of solutions of [board], counting at most up to [limit].
int countSolutions(List<int> board, {int limit = 2}) =>
    _Search(board).count(limit);

/// The first solution found for [board], or null if it has none.
List<int>? solve(List<int> board) {
  final search = _Search(board);
  return search.fill(Random(0)) ? search.cells : null;
}

/// A random, completely filled valid grid.
List<int> randomSolvedGrid(Random rng) {
  final search = _Search(List.filled(81, 0));
  search.fill(rng);
  return search.cells;
}

// --- Human-style solver (singles only) ---

/// True when [board] can be completed using only naked singles (a cell with
/// one candidate) and hidden singles (a digit with one place in a unit).
///
/// Both are sound deductions, so a board this solves has a unique solution.
bool solvableWithSingles(List<int> board) {
  final cells = List.of(board);
  final cand = List.filled(81, 0);
  for (int i = 0; i < 81; i++) {
    if (cells[i] != 0) continue;
    var used = 0;
    for (final p in peers[i]) {
      if (cells[p] != 0) used |= 1 << (cells[p] - 1);
    }
    cand[i] = _allDigits & ~used;
    if (cand[i] == 0) return false;
  }

  void place(int i, int bit) {
    cells[i] = _digitOf(bit);
    cand[i] = 0;
    for (final p in peers[i]) {
      cand[p] &= ~bit;
    }
  }

  var empty = cells.where((v) => v == 0).length;
  var progress = true;
  while (empty > 0 && progress) {
    progress = false;

    // Naked singles
    for (int i = 0; i < 81; i++) {
      if (cells[i] != 0) continue;
      final m = cand[i];
      if (m == 0) return false;
      if (m & (m - 1) == 0) {
        place(i, m);
        empty--;
        progress = true;
      }
    }

    // Hidden singles
    for (final unit in units) {
      for (int bit = 1; bit <= 256; bit <<= 1) {
        var spot = -1;
        var spots = 0;
        var present = false;
        for (final i in unit) {
          if (cells[i] != 0) {
            if (1 << (cells[i] - 1) == bit) present = true;
          } else if (cand[i] & bit != 0) {
            spot = i;
            spots++;
          }
        }
        if (present) continue;
        if (spots == 0) return false;
        if (spots == 1) {
          place(spot, bit);
          empty--;
          progress = true;
        }
      }
    }
  }
  return empty == 0;
}

// --- Generator ---

/// Generates a puzzle for [level] (1–9). Pass [seed] for reproducible output.
///
/// Digs holes in a random solved grid, keeping each removal only if the
/// puzzle stays solvable the way the level demands (see [SudokuTechnique]).
/// If the clue target or technique isn't met, it retries with a new grid and
/// finally falls back to the closest puzzle found, so it always returns.
SudokuPuzzle generatePuzzle(int level, {int? seed}) {
  final spec = sudokuLevels[(level - 1).clamp(0, sudokuLevels.length - 1)];
  final rng = Random(seed);
  const maxAttempts = 40;

  SudokuPuzzle? best;
  var bestScore = 1 << 30;

  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    final solution = randomSolvedGrid(rng);
    final givens = List.of(solution);
    var clues = 81;

    final order = List.generate(81, (i) => i)..shuffle(rng);
    for (final i in order) {
      if (clues <= spec.clues) break;
      final kept = givens[i];
      givens[i] = 0;
      final ok = spec.technique == SudokuTechnique.singles
          ? solvableWithSingles(givens)
          : countSolutions(givens) == 1;
      if (ok) {
        clues--;
      } else {
        givens[i] = kept;
      }
    }

    final needsAdvanced = spec.technique == SudokuTechnique.advanced;
    final techniqueMet = !needsAdvanced || !solvableWithSingles(givens);
    final puzzle = SudokuPuzzle(
      level: spec.level,
      givens: givens,
      solution: solution,
    );
    if (clues <= spec.clues && techniqueMet) return puzzle;

    // Missing the technique weighs more than a couple of extra clues.
    final score = (clues - spec.clues) + (techniqueMet ? 0 : 10);
    if (score < bestScore) {
      best = puzzle;
      bestScore = score;
    }
  }
  return best!;
}
