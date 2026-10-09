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
  String levelSummary(String band, int clues) {
    return '$band · $clues clues';
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
  String get play => 'PLAY';

  @override
  String get info => 'Info';

  @override
  String get options => 'Options';

  @override
  String get scoreboard => 'Scoreboard';

  @override
  String get levelLabel => 'Level';

  @override
  String get timeLabel => 'Time';

  @override
  String get mistakesLabel => 'Mistakes';

  @override
  String get statusPlay => 'Pick a cell, then a number';

  @override
  String get statusNotes => 'Notes: tap numbers to mark candidates';

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
  String get erase => 'Erase';

  @override
  String get notes => 'Notes';

  @override
  String hint(int seconds) {
    return 'Hint +${seconds}s';
  }

  @override
  String get leaveGameTitle => 'Leave this game?';

  @override
  String get leaveGameMessage => 'Your progress on this puzzle will be lost.';

  @override
  String get leave => 'Leave';

  @override
  String get stay => 'Keep playing';

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
  String nextLevelInfo(String band, int clues) {
    return 'Next level: $band · $clues clues';
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
  String get optHints => 'Hint button';

  @override
  String optHintsDesc(int seconds) {
    return 'Show a button that fills in a correct number (+$seconds s).';
  }

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
