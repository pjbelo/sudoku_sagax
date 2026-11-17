import 'puzzle_bank.dart';
import 'sudoku_generator.dart';

// ============================================================
// Sudoku Sagax — the daily puzzle (pure Dart, no Flutter)
// ============================================================
//
// One puzzle a day, the same for everyone, made on the device from the
// date, so it works offline with no account.
//
// FROZEN: once shipped, a change here (or in puzzle_bank.dart) would give
// a different puzzle for the same day in another version of the app. That
// is why it has its own random numbers and its own shuffle instead of using
// dart:math's Random and the generator's, which may change. The golden test
// in test/daily_puzzle_test.dart fails if a day's puzzle changes.

/// The level of the puzzle of [day]: easier early in the week, harder at
/// the weekend.
int dailyLevel(DateTime day) => switch (day.weekday) {
  DateTime.monday => 3,
  DateTime.tuesday => 4,
  DateTime.wednesday => 5,
  DateTime.thursday => 6,
  DateTime.friday => 6,
  DateTime.saturday => 7,
  _ => 8, // Sunday
};

/// The puzzle of [day] (its date, in local time).
///
/// Levels 6 and up take a puzzle from [puzzleBank] and shuffle it. Easier
/// days take a level 6 puzzle, shuffle it and add digits from its solution
/// until it has the level's clues and can be solved with singles alone.
SudokuPuzzle dailyPuzzle(DateTime day) {
  final level = dailyLevel(day);
  final random = DailyRandom(dayNumber(day) * 7919 + 17);
  final bank = puzzleBank[level < 6 ? 6 : level]!;
  final text = bank[random.nextInt(bank.length)];
  final givens = [for (final ch in text.split('')) int.parse(ch)];
  // The bank's puzzles have one solution, so any solver finds the same.
  final solution = solve(givens)!;

  final shuffled = _shuffle(givens, solution, random);
  var puzzleGivens = shuffled.$1;
  if (level < 6) {
    puzzleGivens = _easier(
      puzzleGivens,
      shuffled.$2,
      sudokuLevels[level - 1].clues,
      random,
    );
  }
  return SudokuPuzzle(
    level: level,
    givens: puzzleGivens,
    solution: shuffled.$2,
  );
}

/// Days from 1 January 2026 to the date of [day].
int dayNumber(DateTime day) => DateTime.utc(
  day.year,
  day.month,
  day.day,
).difference(DateTime.utc(2026)).inDays;

/// Small random numbers that never change between versions: a linear
/// congruential generator, the classic `next = (a × state + c) mod m`.
class DailyRandom {
  DailyRandom(int seed) : _state = seed & 0x7fffffff;

  int _state;

  /// A number from 0 to [max] - 1.
  int nextInt(int max) {
    _state = (_state * 1103515245 + 12345) & 0x7fffffff;
    // The low bits of this generator repeat quickly; the high ones don't.
    return (_state >> 8) % max;
  }

  /// [list] in a random order (Fisher–Yates).
  List<T> shuffled<T>(List<T> list) {
    final result = List.of(list);
    for (int i = result.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final kept = result[i];
      result[i] = result[j];
      result[j] = kept;
    }
    return result;
  }
}

/// The puzzle seen differently, as [shufflePuzzle] does: digits renamed,
/// bands and the rows in them reordered, the same for columns, maybe turned
/// over its diagonal. Returns the new givens and solution.
(List<int>, List<int>) _shuffle(
  List<int> givens,
  List<int> solution,
  DailyRandom random,
) {
  final digits = random.shuffled([1, 2, 3, 4, 5, 6, 7, 8, 9]);

  List<int> lineOrder() => [
    for (final band in random.shuffled([0, 1, 2]))
      for (final line in random.shuffled([0, 1, 2])) band * 3 + line,
  ];

  final rows = lineOrder();
  final columns = lineOrder();
  final turn = random.nextInt(2) == 1;

  List<int> move(List<int> grid) => [
    for (int r = 0; r < 9; r++)
      for (int c = 0; c < 9; c++)
        _rename(
          turn
              ? grid[columns[c] * 9 + rows[r]]
              : grid[rows[r] * 9 + columns[c]],
          digits,
        ),
  ];

  return (move(givens), move(solution));
}

int _rename(int value, List<int> digits) => value == 0 ? 0 : digits[value - 1];

/// [givens] with digits of [solution] added, in a random order, until there
/// are at least [clues] of them and singles alone solve the puzzle.
List<int> _easier(
  List<int> givens,
  List<int> solution,
  int clues,
  DailyRandom random,
) {
  final result = List.of(givens);
  final empty = random.shuffled([
    for (int i = 0; i < 81; i++)
      if (result[i] == 0) i,
  ]);
  var count = 81 - empty.length;
  for (final cell in empty) {
    if (count >= clues && solvableWithSingles(result)) break;
    result[cell] = solution[cell];
    count++;
  }
  return result;
}
