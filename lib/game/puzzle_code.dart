import 'sudoku_generator.dart';

// ============================================================
// Sudoku Sagax — Puzzle codes for sharing (pure Dart)
// ============================================================
//
// A code holds the puzzle itself (its level and its givens), so a friend's
// app rebuilds exactly the same grid, whatever version made it. It looks
// like `6-1A2B-3C4D-…-X`:
//
// - the level (1 to 9);
// - the givens, packed into one big number and written in base 32: which
//   of the 81 cells are given (81 bits), then the digit of each given cell;
// - a check character at the end, so a typo is caught instead of opening
//   a different puzzle.
//
// The letters are Crockford's base 32: no I, L, O or U, so a code can be
// read aloud and typed without mixing up 1 and I or 0 and O. Codes are
// read in upper or lower case, with or without the dashes.
//
// Never change this format once shipped: codes already shared must keep
// opening the same puzzle.

const _alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

/// Bits used for the cell mask: one per cell.
const _maskBits = 81;

/// The code of [puzzle], grouped in fours with dashes.
String puzzleCode(SudokuPuzzle puzzle) {
  // Which cells are given: bit i is cell i.
  var mask = BigInt.zero;
  // The given digits, one base-9 digit each (digit - 1), first cell first.
  var digits = BigInt.zero;
  for (int i = 0; i < 81; i++) {
    final value = puzzle.givens[i];
    if (value == 0) continue;
    mask |= BigInt.one << i;
    digits = digits * BigInt.from(9) + BigInt.from(value - 1);
  }
  final number = (digits << _maskBits) | mask;

  final body = '${puzzle.level}${_toBase32(number)}';
  final code = body + _checkChar(body);

  // "6" + "-" + groups of four characters.
  final groups = <String>[code[0]];
  for (int i = 1; i < code.length; i += 4) {
    groups.add(code.substring(i, i + 4 > code.length ? code.length : i + 4));
  }
  return groups.join('-');
}

/// The puzzle in [text], or null if there is no valid code in it.
///
/// [text] can be the code alone or a whole shared message: each word is
/// tried in turn, then the whole text with its spaces taken out (for a
/// code typed in groups with spaces).
SudokuPuzzle? puzzleFromText(String text) {
  for (final word in text.split(RegExp(r'\s+'))) {
    final puzzle = puzzleFromCode(word);
    if (puzzle != null) return puzzle;
  }
  return puzzleFromCode(text.replaceAll(RegExp(r'\s+'), ''));
}

/// The puzzle of [code], or null if it isn't a valid puzzle code.
SudokuPuzzle? puzzleFromCode(String code) {
  final clean = _normalize(code);
  if (clean == null || clean.length < 3) return null;

  final level = int.tryParse(clean[0]);
  if (level == null || level < 1 || level > sudokuLevels.length) return null;

  final body = clean.substring(0, clean.length - 1);
  if (_checkChar(body) != clean[clean.length - 1]) return null;

  final number = _fromBase32(body.substring(1));
  final mask = number & ((BigInt.one << _maskBits) - BigInt.one);
  var digits = number >> _maskBits;

  // The digits were added first cell first, so they come out last cell
  // first.
  final givens = List.filled(81, 0);
  for (int i = 80; i >= 0; i--) {
    if ((mask >> i) & BigInt.one == BigInt.zero) continue;
    givens[i] = (digits % BigInt.from(9)).toInt() + 1;
    digits = digits ~/ BigInt.from(9);
  }
  if (digits != BigInt.zero) return null; // digits left over: not a code

  if (!_isValidPuzzle(givens)) return null;
  return SudokuPuzzle(level: level, givens: givens, solution: solve(givens)!);
}

/// At least 17 givens (no sudoku has a unique solution with fewer), no
/// digit twice in a row, column or box, and exactly one solution.
bool _isValidPuzzle(List<int> givens) {
  if (givens.where((v) => v != 0).length < 17) return false;
  for (int i = 0; i < 81; i++) {
    if (givens[i] == 0) continue;
    for (final p in peers[i]) {
      if (givens[p] == givens[i]) return false;
    }
  }
  return countSolutions(givens) == 1;
}

/// [code] in upper case without dashes, with the letters that look like
/// digits read as those digits; null if it has any other character.
String? _normalize(String code) {
  final buffer = StringBuffer();
  for (final char in code.toUpperCase().split('')) {
    if (char == '-') continue;
    final fixed = switch (char) {
      'O' => '0',
      'I' || 'L' => '1',
      _ => char,
    };
    if (!_alphabet.contains(fixed)) return null;
    buffer.write(fixed);
  }
  return buffer.toString();
}

/// [number] in base 32, most significant character first.
String _toBase32(BigInt number) {
  if (number == BigInt.zero) return '0';
  final chars = <String>[];
  final base = BigInt.from(32);
  while (number > BigInt.zero) {
    chars.add(_alphabet[(number % base).toInt()]);
    number = number ~/ base;
  }
  return chars.reversed.join();
}

BigInt _fromBase32(String text) {
  var number = BigInt.zero;
  for (final char in text.split('')) {
    number = number * BigInt.from(32) + BigInt.from(_alphabet.indexOf(char));
  }
  return number;
}

/// A check character for [body]: each character's value times its
/// position, added up, modulo 32. A wrong or swapped character changes it.
String _checkChar(String body) {
  int sum = 0;
  for (int i = 0; i < body.length; i++) {
    sum += (i + 1) * _alphabet.indexOf(body[i]);
  }
  return _alphabet[sum % 32];
}
