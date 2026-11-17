// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sudoku Sagax';

  @override
  String get bySagaxGames => 'by Sagax Games';

  @override
  String get sagaxGames => 'Sagax Games';

  @override
  String get tagline => 'Fill the grid, sharpen your mind';

  @override
  String get selectLevel => 'Select level:';

  @override
  String levelSummary(String band, String technique) {
    return '$band · $technique';
  }

  @override
  String get bandBeginner => 'Beginner';

  @override
  String get bandEasy => 'Easy';

  @override
  String get bandMedium => 'Medium';

  @override
  String get bandHard => 'Hard';

  @override
  String get bandExpert => 'Expert';

  @override
  String get trainsSingles => 'singles';

  @override
  String get trainsLockedCandidates => 'pointing pairs';

  @override
  String get trainsPairs => 'pairs';

  @override
  String get trainsTriples => 'triples';

  @override
  String get trainsXWing => 'X-Wing';

  @override
  String get play => 'PLAY';

  @override
  String get info => 'Info';

  @override
  String get options => 'Options';

  @override
  String get scoreboard => 'Scoreboard';

  @override
  String get daily => 'Daily';

  @override
  String get dailyTitle => 'Daily puzzle';

  @override
  String get dailyIntro =>
      'One puzzle a day, the same for everyone. Easier early in the week, harder at the weekend.';

  @override
  String dailyToday(String date) {
    return 'Today · $date';
  }

  @override
  String get dailyPlay => 'Play today\'s puzzle';

  @override
  String get dailyContinue => 'Continue today\'s puzzle';

  @override
  String dailySolved(String time) {
    return 'Solved today in $time';
  }

  @override
  String get dailyStreak => 'Daily streak';

  @override
  String get dailyBestStreak => 'Best daily streak';

  @override
  String get dailyComeBack => 'Come back tomorrow for a new puzzle.';

  @override
  String get levelLabel => 'Level';

  @override
  String get timeLabel => 'Time';

  @override
  String get mistakesLabel => 'Mistakes';

  @override
  String get statusPlay => 'Pick a cell and a number, in either order';

  @override
  String get statusNotes => 'Notes: tap numbers to mark candidates';

  @override
  String get statusNotesFill => 'Notes · tap here to fill in every candidate';

  @override
  String statusDigit(int digit) {
    return '$digit: tap the cells that take it';
  }

  @override
  String statusDigitNotes(int digit) {
    return '$digit: tap cells to note it as a candidate';
  }

  @override
  String get statusFullWrong => 'The grid is full, but something is not right';

  @override
  String get solved => 'Solved!';

  @override
  String get paused => 'Paused';

  @override
  String get resume => 'Resume';

  @override
  String get pause => 'Pause';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get erase => 'Erase';

  @override
  String get notes => 'Notes';

  @override
  String hint(int seconds) {
    return 'Hint +${seconds}s';
  }

  @override
  String get techniqueHiddenSingle => 'Hidden single';

  @override
  String get techniqueNakedSingle => 'Naked single';

  @override
  String get techniquePointingPair => 'Pointing pair';

  @override
  String get techniqueBoxLine => 'Box-line reduction';

  @override
  String get techniqueNakedPair => 'Naked pair';

  @override
  String get techniqueHiddenPair => 'Hidden pair';

  @override
  String get techniqueNakedTriple => 'Naked triple';

  @override
  String get techniqueXWing => 'X-Wing';

  @override
  String get techniqueMistake => 'Mistake';

  @override
  String get techniqueFromSolution => 'From the solution';

  @override
  String unitRow(int n) {
    return 'Row $n';
  }

  @override
  String unitColumn(int n) {
    return 'Column $n';
  }

  @override
  String unitBox(int n) {
    return 'Box $n';
  }

  @override
  String coachLook(String unit) {
    return 'Where to look: $unit.';
  }

  @override
  String coachLookMistake(String unit) {
    return 'One of your digits is wrong. Where to look: $unit.';
  }

  @override
  String coachLookFallback(String unit) {
    return 'None of the coach\'s techniques works here. Where to look: $unit.';
  }

  @override
  String coachHiddenSingle(String unit, int digit) {
    return '$unit: the $digit fits in only one cell.';
  }

  @override
  String coachNakedSingle(int digit) {
    return 'The highlighted cell already sees every digit but $digit in its row, column and box, so it must be $digit.';
  }

  @override
  String coachPointingRow(String box, int digit) {
    return '$box: the $digit only fits in the highlighted cells, all in one row. So it can\'t go in the red cells of that row.';
  }

  @override
  String coachPointingColumn(String box, int digit) {
    return '$box: the $digit only fits in the highlighted cells, all in one column. So it can\'t go in the red cells of that column.';
  }

  @override
  String coachBoxLine(String line, int digit) {
    return '$line: the $digit only fits in the highlighted cells, all in one box. So it can\'t go in the red cells of that box.';
  }

  @override
  String coachNakedPair(String unit, int a, int b) {
    return '$unit: the two highlighted cells can only hold $a or $b. So the red cells can\'t hold them.';
  }

  @override
  String coachHiddenPair(String unit, int a, int b) {
    return '$unit: $a and $b only fit in the two highlighted cells. So those cells can\'t hold any other digit.';
  }

  @override
  String coachNakedTriple(String unit, int a, int b, int c) {
    return '$unit: the three highlighted cells can only hold $a, $b or $c. So the red cells can\'t hold them.';
  }

  @override
  String coachXWingRows(int digit) {
    return 'In two rows, the $digit only fits in the four highlighted cells, which share two columns. Either way, each of those columns gets its $digit there, so it can\'t go in the red cells.';
  }

  @override
  String coachXWingColumns(int digit) {
    return 'In two columns, the $digit only fits in the four highlighted cells, which share two rows. Either way, each of those rows gets its $digit there, so it can\'t go in the red cells.';
  }

  @override
  String coachMistake(int digit) {
    return 'The highlighted $digit doesn\'t belong in this cell.';
  }

  @override
  String get coachFallback =>
      'The highlighted cell will be filled in from the solution.';

  @override
  String coachDone(int digit) {
    return 'The $digit is in place.';
  }

  @override
  String coachCorrected(int digit) {
    return 'Corrected: this cell takes the $digit.';
  }

  @override
  String get coachShow => 'Show me';

  @override
  String coachApply(int seconds) {
    return 'Apply +${seconds}s';
  }

  @override
  String get continueGame => 'Continue';

  @override
  String get newGameTitle => 'Start a new game?';

  @override
  String newGameMessage(int level) {
    return 'The unfinished game on level $level will be lost.';
  }

  @override
  String get newGame => 'New game';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String levelCompleted(int level, String time) {
    return 'You solved level $level in $time!';
  }

  @override
  String hintsAndMistakes(int hints, int mistakes) {
    return 'Hints: $hints · Mistakes: $mistakes';
  }

  @override
  String get newBestTime => '🏆 New best time for this level!';

  @override
  String rankOnScoreboard(int rank, int level) {
    return '#$rank on the level $level scoreboard';
  }

  @override
  String nextLevelInfo(String band, String technique) {
    return 'Next level: $band · $technique';
  }

  @override
  String get allLevelsComplete => 'You conquered the hardest level!';

  @override
  String get nextLevel => 'Next Level';

  @override
  String get sameLevel => 'Same Level';

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToMenu => 'Back to Menu';

  @override
  String get okButton => 'OK';

  @override
  String get review => 'Review';

  @override
  String get reviewTitle => 'Game review';

  @override
  String get reviewNeeded => 'What this puzzle needed';

  @override
  String get reviewNeededNote =>
      'Each step of the logic coach, one digit at a time, counted under its hardest technique.';

  @override
  String get reviewYourGame => 'Your hints and mistakes';

  @override
  String get reviewClean => 'No hints and no mistakes: a clean solve!';

  @override
  String reviewHint(String time, String technique, int digit, String cell) {
    return '$time · Hint: $technique, the $digit in $cell.';
  }

  @override
  String reviewHintFix(String time, int digit, String cell) {
    return '$time · Hint: corrected to $digit in $cell.';
  }

  @override
  String reviewMistake(String time, int digit, String cell) {
    return '$time · Mistake: a $digit in $cell.';
  }

  @override
  String reviewAvailable(String technique, int digit, String cell) {
    return 'Available then: $technique, the $digit in $cell.';
  }

  @override
  String reviewAvailableFix(String cell) {
    return 'Available then: fixing an earlier mistake in $cell.';
  }

  @override
  String cellName(int row, int column) {
    return 'row $row, column $column';
  }

  @override
  String get lessons => 'Lessons';

  @override
  String get lessonsIntro =>
      'Short lessons, one per technique: the app explains, you make the move.';

  @override
  String get lessonDoneBadge => 'Done';

  @override
  String lessonFromLevel(int level) {
    return 'From level $level';
  }

  @override
  String get lessonTry => 'Find the move: tap the cell, then its digit.';

  @override
  String get lessonWrong => 'Not this one. Here is the reasoning:';

  @override
  String get lessonNowYou => 'Now make the move.';

  @override
  String get lessonSuccess => 'Well done!';

  @override
  String get lessonFinish => 'Finish';

  @override
  String lessonSuggestTitle(String technique) {
    return 'New technique: $technique';
  }

  @override
  String lessonSuggestMessage(int level) {
    return 'Level $level needs it. A short lesson shows how it works.';
  }

  @override
  String get lessonOpen => 'Lesson';

  @override
  String get playNow => 'Play';

  @override
  String get lessonIntroHiddenSingle =>
      'A hidden single is a digit that fits in only one cell of a row, column or box. Pick a box and a digit it still lacks: if every other cell already sees that digit, it goes in the one cell left.';

  @override
  String get lessonIntroNakedSingle =>
      'A naked single is a cell that can hold only one digit: its row, column and box already hold the other eight between them.';

  @override
  String get lessonIntroPointingPair =>
      'If, inside a box, a digit can only go in one row (or column), it must go in that row there. So it can\'t go anywhere else along that row.';

  @override
  String get lessonIntroBoxLine =>
      'If, along a row (or column), a digit can only go inside one box, it must go there in that box. So it can\'t go in the box\'s other cells.';

  @override
  String get lessonIntroNakedPair =>
      'If two cells of a row, column or box can only hold the same two digits, those two digits go in those two cells. No other cell of that unit can hold them.';

  @override
  String get lessonIntroHiddenPair =>
      'If two digits fit only in the same two cells of a row, column or box, those cells must take them. Any other candidates in those two cells can go.';

  @override
  String get lessonIntroNakedTriple =>
      'If three cells of a unit can only hold three digits between them, those three digits go in those cells. The rest of the unit can\'t hold them.';

  @override
  String get lessonIntroXWing =>
      'If, in two rows, a digit fits in only two cells each, and those cells line up in the same two columns, the digit takes one corner in each row. Either way, those columns get it there, so it can\'t go anywhere else in them.';

  @override
  String get optionsTitle => 'Options';

  @override
  String get optSound => 'Sound';

  @override
  String get optSoundDesc => 'Music and sound effects.';

  @override
  String get optTimer => 'Timer';

  @override
  String get optTimerDesc =>
      'Show the clock while you play. Your time is always recorded for the scoreboard.';

  @override
  String get optShowErrors => 'Show errors';

  @override
  String get optShowErrorsDesc =>
      'Mark a wrong number in red as soon as you enter it.';

  @override
  String get optMarkConflicts => 'Mark conflicts';

  @override
  String get optMarkConflictsDesc =>
      'Outline two equal digits in the same row, column or box. It doesn\'t use the solution, so it gives nothing away.';

  @override
  String get cellEmpty => 'empty';

  @override
  String get cellGiven => 'given';

  @override
  String get cellHint => 'hint';

  @override
  String get cellWrong => 'wrong';

  @override
  String get cellConflict => 'conflict';

  @override
  String cellNotes(String notes) {
    return 'notes $notes';
  }

  @override
  String numberKey(int digit, int remaining) {
    return '$digit, $remaining left';
  }

  @override
  String get optHighContrast => 'High contrast';

  @override
  String get optHighContrastDesc =>
      'Stronger grid lines, notes and highlights on the board. Also on when the system asks for more contrast.';

  @override
  String get optHints => 'Hint button';

  @override
  String optHintsDesc(int seconds) {
    return 'Show a button for the logic coach: it explains the next step, and placing the digit costs +$seconds s.';
  }

  @override
  String get optLeftHanded => 'Left-handed';

  @override
  String get optLeftHandedDesc =>
      'With the device sideways, put the number keys to the left of the grid.';

  @override
  String get optFillNotes => 'Fill notes on easy levels';

  @override
  String get optFillNotesDesc =>
      'In Notes mode, offer to fill in every candidate on levels 1–5 too. Levels 6–9 always offer it.';

  @override
  String get optHaptics => 'Vibration';

  @override
  String get optHapticsDesc =>
      'A light tap for each entry, and a stronger one for the win and for errors (with Show errors on).';

  @override
  String get restoreDefaults => 'Restore defaults';

  @override
  String get scoreboardTitle => 'Scoreboard';

  @override
  String get noScores => 'No puzzles solved at this level yet.';

  @override
  String get clearScores => 'Clear scoreboard';

  @override
  String get clearScoresTitle => 'Clear the scoreboard?';

  @override
  String get clearScoresMessage =>
      'All scores for every level will be deleted. This cannot be undone.';

  @override
  String get leaderboards => 'Leaderboards';

  @override
  String get achievements => 'Achievements';

  @override
  String get bestTimes => 'Best times';

  @override
  String get statistics => 'Statistics';

  @override
  String get statPlayed => 'Played';

  @override
  String get statSolved => 'Solved';

  @override
  String get statBestTime => 'Best time';

  @override
  String get statAverageTime => 'Average time';

  @override
  String get statNoHints => 'Without hints';

  @override
  String get statNoMistakes => 'Without mistakes';

  @override
  String get streakCurrent => 'Day streak';

  @override
  String get streakBest => 'Best streak';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String get streakNote => 'A day counts when you solve at least one puzzle.';

  @override
  String get clearStats => 'Reset statistics';

  @override
  String get clearStatsTitle => 'Reset the statistics?';

  @override
  String get clearStatsMessage =>
      'The statistics of every level and the day streaks will be deleted. This cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get infoScreenTitle => 'Info';

  @override
  String get howToPlayTitle => 'How to play';

  @override
  String get howToPlayText =>
      'Fill every empty cell so that each row, each column and each 3×3 box contains the digits 1 to 9 exactly once. Every puzzle has a single solution and can be solved by logic alone — no guessing needed. Use Notes to pencil in the candidates of a cell.';

  @override
  String get sudokuBenefitsTitle => 'Why is Sudoku good for the brain?';

  @override
  String get sudokuBenefitsIntro =>
      'Sudoku is a pure logic puzzle: no arithmetic, just deduction. Research on number puzzles and Sudoku points to these benefits:';

  @override
  String get benefit1Title => '🔢 Logical and Deductive Reasoning';

  @override
  String get benefit1Desc =>
      'Every move is a deduction: \"this cell can only be 7\" or \"the 3 can only go here\". Sudoku-based training programmes target attention and logical-deductive reasoning, and a randomised trial in older adults with mild cognitive impairment reported gains in global cognition after Sudoku training.';

  @override
  String get benefit2Title => '🧠 Working Memory';

  @override
  String get benefit2Desc =>
      'Keeping candidates and the constraints of rows, columns and boxes in mind loads working memory. Studies in older adults found that Sudoku performance relates to working-memory capacity. Brain-imaging studies show that solving Sudoku engages the frontal and parietal networks that support working memory and executive control.';

  @override
  String get benefit3Title => '🎯 Attention and Concentration';

  @override
  String get benefit3Desc =>
      'In a study of over 19,000 adults aged 50 and over, those who did number puzzles more often scored better on tests of attention, reasoning and memory.';

  @override
  String get benefit4Title => '⚡ Processing Speed and Executive Function';

  @override
  String get benefit4Desc =>
      'The same research linked regular number-puzzle play to faster information processing and better executive function — planning, checking and switching strategies.';

  @override
  String get benefit5Title => '🛡️ Cognitive Reserve and Healthy Ageing';

  @override
  String get benefit5Desc =>
      'Long-term studies associate mentally stimulating games and puzzles with better cognitive function later in life and slower cognitive decline — consistent with building cognitive reserve. It\'s never too late: people who took up puzzles later also showed benefits.';

  @override
  String get benefit6Title => '😌 Focus, Flow and Well-being';

  @override
  String get benefit6Desc =>
      'A puzzle matched to your skill invites \"flow\" — full absorption in the task — which is linked to enjoyment and reduced stress. Nine difficulty levels let you keep the challenge just right.';

  @override
  String get evidenceNote =>
      'A note on the evidence: most of these studies are observational, so they show associations rather than proof of cause. Sudoku works best as one part of an active lifestyle that also includes exercise, sleep and social life.';

  @override
  String get scientificReferences => 'Scientific References';

  @override
  String get developedBy =>
      'Developed by Tekinsight - Information Technologies';

  @override
  String get credits => 'Credits';

  @override
  String get music => 'Music';

  @override
  String get sounds => 'Sounds';

  @override
  String get license => 'License';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';
}
