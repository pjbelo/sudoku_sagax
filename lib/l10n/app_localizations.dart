import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Sudoku Sagax'**
  String get appTitle;

  /// No description provided for @bySagaxGames.
  ///
  /// In en, this message translates to:
  /// **'by Sagax Games'**
  String get bySagaxGames;

  /// No description provided for @sagaxGames.
  ///
  /// In en, this message translates to:
  /// **'Sagax Games'**
  String get sagaxGames;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Fill the grid, sharpen your mind'**
  String get tagline;

  /// No description provided for @selectLevel.
  ///
  /// In en, this message translates to:
  /// **'Select level:'**
  String get selectLevel;

  /// No description provided for @levelSummary.
  ///
  /// In en, this message translates to:
  /// **'{band} · {technique}'**
  String levelSummary(String band, String technique);

  /// No description provided for @bandBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get bandBeginner;

  /// No description provided for @bandEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get bandEasy;

  /// No description provided for @bandMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get bandMedium;

  /// No description provided for @bandHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get bandHard;

  /// No description provided for @bandExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get bandExpert;

  /// No description provided for @trainsSingles.
  ///
  /// In en, this message translates to:
  /// **'singles'**
  String get trainsSingles;

  /// No description provided for @trainsLockedCandidates.
  ///
  /// In en, this message translates to:
  /// **'pointing pairs'**
  String get trainsLockedCandidates;

  /// No description provided for @trainsPairs.
  ///
  /// In en, this message translates to:
  /// **'pairs'**
  String get trainsPairs;

  /// No description provided for @trainsTriples.
  ///
  /// In en, this message translates to:
  /// **'triples'**
  String get trainsTriples;

  /// No description provided for @trainsXWing.
  ///
  /// In en, this message translates to:
  /// **'X-Wing'**
  String get trainsXWing;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'PLAY'**
  String get play;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @scoreboard.
  ///
  /// In en, this message translates to:
  /// **'Scoreboard'**
  String get scoreboard;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @dailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily puzzle'**
  String get dailyTitle;

  /// No description provided for @dailyIntro.
  ///
  /// In en, this message translates to:
  /// **'One puzzle a day, the same for everyone. Easier early in the week, harder at the weekend.'**
  String get dailyIntro;

  /// No description provided for @dailyToday.
  ///
  /// In en, this message translates to:
  /// **'Today · {date}'**
  String dailyToday(String date);

  /// No description provided for @dailyPlay.
  ///
  /// In en, this message translates to:
  /// **'Play today\'s puzzle'**
  String get dailyPlay;

  /// No description provided for @dailyContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue today\'s puzzle'**
  String get dailyContinue;

  /// No description provided for @dailySolved.
  ///
  /// In en, this message translates to:
  /// **'Solved today in {time}'**
  String dailySolved(String time);

  /// No description provided for @dailyStreak.
  ///
  /// In en, this message translates to:
  /// **'Daily streak'**
  String get dailyStreak;

  /// No description provided for @dailyBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best daily streak'**
  String get dailyBestStreak;

  /// No description provided for @dailyComeBack.
  ///
  /// In en, this message translates to:
  /// **'Come back tomorrow for a new puzzle.'**
  String get dailyComeBack;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @mistakesLabel.
  ///
  /// In en, this message translates to:
  /// **'Mistakes'**
  String get mistakesLabel;

  /// No description provided for @statusPlay.
  ///
  /// In en, this message translates to:
  /// **'Pick a cell and a number, in either order'**
  String get statusPlay;

  /// No description provided for @statusNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes: tap numbers to mark candidates'**
  String get statusNotes;

  /// No description provided for @statusNotesFill.
  ///
  /// In en, this message translates to:
  /// **'Notes · tap here to fill in every candidate'**
  String get statusNotesFill;

  /// No description provided for @statusDigit.
  ///
  /// In en, this message translates to:
  /// **'{digit}: tap the cells that take it'**
  String statusDigit(int digit);

  /// No description provided for @statusDigitNotes.
  ///
  /// In en, this message translates to:
  /// **'{digit}: tap cells to note it as a candidate'**
  String statusDigitNotes(int digit);

  /// No description provided for @statusFullWrong.
  ///
  /// In en, this message translates to:
  /// **'The grid is full, but something is not right'**
  String get statusFullWrong;

  /// No description provided for @solved.
  ///
  /// In en, this message translates to:
  /// **'Solved!'**
  String get solved;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @erase.
  ///
  /// In en, this message translates to:
  /// **'Erase'**
  String get erase;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @hint.
  ///
  /// In en, this message translates to:
  /// **'Hint +{seconds}s'**
  String hint(int seconds);

  /// No description provided for @techniqueHiddenSingle.
  ///
  /// In en, this message translates to:
  /// **'Hidden single'**
  String get techniqueHiddenSingle;

  /// No description provided for @techniqueNakedSingle.
  ///
  /// In en, this message translates to:
  /// **'Naked single'**
  String get techniqueNakedSingle;

  /// No description provided for @techniquePointingPair.
  ///
  /// In en, this message translates to:
  /// **'Pointing pair'**
  String get techniquePointingPair;

  /// No description provided for @techniqueBoxLine.
  ///
  /// In en, this message translates to:
  /// **'Box-line reduction'**
  String get techniqueBoxLine;

  /// No description provided for @techniqueNakedPair.
  ///
  /// In en, this message translates to:
  /// **'Naked pair'**
  String get techniqueNakedPair;

  /// No description provided for @techniqueHiddenPair.
  ///
  /// In en, this message translates to:
  /// **'Hidden pair'**
  String get techniqueHiddenPair;

  /// No description provided for @techniqueNakedTriple.
  ///
  /// In en, this message translates to:
  /// **'Naked triple'**
  String get techniqueNakedTriple;

  /// No description provided for @techniqueXWing.
  ///
  /// In en, this message translates to:
  /// **'X-Wing'**
  String get techniqueXWing;

  /// No description provided for @techniqueMistake.
  ///
  /// In en, this message translates to:
  /// **'Mistake'**
  String get techniqueMistake;

  /// No description provided for @techniqueFromSolution.
  ///
  /// In en, this message translates to:
  /// **'From the solution'**
  String get techniqueFromSolution;

  /// No description provided for @unitRow.
  ///
  /// In en, this message translates to:
  /// **'Row {n}'**
  String unitRow(int n);

  /// No description provided for @unitColumn.
  ///
  /// In en, this message translates to:
  /// **'Column {n}'**
  String unitColumn(int n);

  /// No description provided for @unitBox.
  ///
  /// In en, this message translates to:
  /// **'Box {n}'**
  String unitBox(int n);

  /// No description provided for @coachLook.
  ///
  /// In en, this message translates to:
  /// **'Where to look: {unit}.'**
  String coachLook(String unit);

  /// No description provided for @coachLookMistake.
  ///
  /// In en, this message translates to:
  /// **'One of your digits is wrong. Where to look: {unit}.'**
  String coachLookMistake(String unit);

  /// No description provided for @coachLookFallback.
  ///
  /// In en, this message translates to:
  /// **'None of the coach\'s techniques works here. Where to look: {unit}.'**
  String coachLookFallback(String unit);

  /// No description provided for @coachHiddenSingle.
  ///
  /// In en, this message translates to:
  /// **'{unit}: the {digit} fits in only one cell.'**
  String coachHiddenSingle(String unit, int digit);

  /// No description provided for @coachNakedSingle.
  ///
  /// In en, this message translates to:
  /// **'The highlighted cell already sees every digit but {digit} in its row, column and box, so it must be {digit}.'**
  String coachNakedSingle(int digit);

  /// No description provided for @coachPointingRow.
  ///
  /// In en, this message translates to:
  /// **'{box}: the {digit} only fits in the highlighted cells, all in one row. So it can\'t go in the red cells of that row.'**
  String coachPointingRow(String box, int digit);

  /// No description provided for @coachPointingColumn.
  ///
  /// In en, this message translates to:
  /// **'{box}: the {digit} only fits in the highlighted cells, all in one column. So it can\'t go in the red cells of that column.'**
  String coachPointingColumn(String box, int digit);

  /// No description provided for @coachBoxLine.
  ///
  /// In en, this message translates to:
  /// **'{line}: the {digit} only fits in the highlighted cells, all in one box. So it can\'t go in the red cells of that box.'**
  String coachBoxLine(String line, int digit);

  /// No description provided for @coachNakedPair.
  ///
  /// In en, this message translates to:
  /// **'{unit}: the two highlighted cells can only hold {a} or {b}. So the red cells can\'t hold them.'**
  String coachNakedPair(String unit, int a, int b);

  /// No description provided for @coachHiddenPair.
  ///
  /// In en, this message translates to:
  /// **'{unit}: {a} and {b} only fit in the two highlighted cells. So those cells can\'t hold any other digit.'**
  String coachHiddenPair(String unit, int a, int b);

  /// No description provided for @coachNakedTriple.
  ///
  /// In en, this message translates to:
  /// **'{unit}: the three highlighted cells can only hold {a}, {b} or {c}. So the red cells can\'t hold them.'**
  String coachNakedTriple(String unit, int a, int b, int c);

  /// No description provided for @coachXWingRows.
  ///
  /// In en, this message translates to:
  /// **'In two rows, the {digit} only fits in the four highlighted cells, which share two columns. Either way, each of those columns gets its {digit} there, so it can\'t go in the red cells.'**
  String coachXWingRows(int digit);

  /// No description provided for @coachXWingColumns.
  ///
  /// In en, this message translates to:
  /// **'In two columns, the {digit} only fits in the four highlighted cells, which share two rows. Either way, each of those rows gets its {digit} there, so it can\'t go in the red cells.'**
  String coachXWingColumns(int digit);

  /// No description provided for @coachMistake.
  ///
  /// In en, this message translates to:
  /// **'The highlighted {digit} doesn\'t belong in this cell.'**
  String coachMistake(int digit);

  /// No description provided for @coachFallback.
  ///
  /// In en, this message translates to:
  /// **'The highlighted cell will be filled in from the solution.'**
  String get coachFallback;

  /// No description provided for @coachDone.
  ///
  /// In en, this message translates to:
  /// **'The {digit} is in place.'**
  String coachDone(int digit);

  /// No description provided for @coachCorrected.
  ///
  /// In en, this message translates to:
  /// **'Corrected: this cell takes the {digit}.'**
  String coachCorrected(int digit);

  /// No description provided for @coachShow.
  ///
  /// In en, this message translates to:
  /// **'Show me'**
  String get coachShow;

  /// No description provided for @coachApply.
  ///
  /// In en, this message translates to:
  /// **'Apply +{seconds}s'**
  String coachApply(int seconds);

  /// No description provided for @continueGame.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueGame;

  /// No description provided for @newGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new game?'**
  String get newGameTitle;

  /// No description provided for @newGameMessage.
  ///
  /// In en, this message translates to:
  /// **'The unfinished game on level {level} will be lost.'**
  String newGameMessage(int level);

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get newGame;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @levelCompleted.
  ///
  /// In en, this message translates to:
  /// **'You solved level {level} in {time}!'**
  String levelCompleted(int level, String time);

  /// No description provided for @hintsAndMistakes.
  ///
  /// In en, this message translates to:
  /// **'Hints: {hints} · Mistakes: {mistakes}'**
  String hintsAndMistakes(int hints, int mistakes);

  /// No description provided for @newBestTime.
  ///
  /// In en, this message translates to:
  /// **'🏆 New best time for this level!'**
  String get newBestTime;

  /// No description provided for @rankOnScoreboard.
  ///
  /// In en, this message translates to:
  /// **'#{rank} on the level {level} scoreboard'**
  String rankOnScoreboard(int rank, int level);

  /// No description provided for @nextLevelInfo.
  ///
  /// In en, this message translates to:
  /// **'Next level: {band} · {technique}'**
  String nextLevelInfo(String band, String technique);

  /// No description provided for @allLevelsComplete.
  ///
  /// In en, this message translates to:
  /// **'You conquered the hardest level!'**
  String get allLevelsComplete;

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nextLevel;

  /// No description provided for @sameLevel.
  ///
  /// In en, this message translates to:
  /// **'Same Level'**
  String get sameLevel;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @backToMenu.
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get backToMenu;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Game review'**
  String get reviewTitle;

  /// No description provided for @reviewNeeded.
  ///
  /// In en, this message translates to:
  /// **'What this puzzle needed'**
  String get reviewNeeded;

  /// No description provided for @reviewNeededNote.
  ///
  /// In en, this message translates to:
  /// **'Each step of the logic coach, one digit at a time, counted under its hardest technique.'**
  String get reviewNeededNote;

  /// No description provided for @reviewYourGame.
  ///
  /// In en, this message translates to:
  /// **'Your hints and mistakes'**
  String get reviewYourGame;

  /// No description provided for @reviewClean.
  ///
  /// In en, this message translates to:
  /// **'No hints and no mistakes: a clean solve!'**
  String get reviewClean;

  /// No description provided for @reviewHint.
  ///
  /// In en, this message translates to:
  /// **'{time} · Hint: {technique}, the {digit} in {cell}.'**
  String reviewHint(String time, String technique, int digit, String cell);

  /// No description provided for @reviewHintFix.
  ///
  /// In en, this message translates to:
  /// **'{time} · Hint: corrected to {digit} in {cell}.'**
  String reviewHintFix(String time, int digit, String cell);

  /// No description provided for @reviewMistake.
  ///
  /// In en, this message translates to:
  /// **'{time} · Mistake: a {digit} in {cell}.'**
  String reviewMistake(String time, int digit, String cell);

  /// No description provided for @reviewAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available then: {technique}, the {digit} in {cell}.'**
  String reviewAvailable(String technique, int digit, String cell);

  /// No description provided for @reviewAvailableFix.
  ///
  /// In en, this message translates to:
  /// **'Available then: fixing an earlier mistake in {cell}.'**
  String reviewAvailableFix(String cell);

  /// No description provided for @cellName.
  ///
  /// In en, this message translates to:
  /// **'row {row}, column {column}'**
  String cellName(int row, int column);

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @lessonsIntro.
  ///
  /// In en, this message translates to:
  /// **'Short lessons, one per technique: the app explains, you make the move.'**
  String get lessonsIntro;

  /// No description provided for @lessonDoneBadge.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get lessonDoneBadge;

  /// No description provided for @lessonFromLevel.
  ///
  /// In en, this message translates to:
  /// **'From level {level}'**
  String lessonFromLevel(int level);

  /// No description provided for @lessonTry.
  ///
  /// In en, this message translates to:
  /// **'Find the move: tap the cell, then its digit.'**
  String get lessonTry;

  /// No description provided for @lessonWrong.
  ///
  /// In en, this message translates to:
  /// **'Not this one. Here is the reasoning:'**
  String get lessonWrong;

  /// No description provided for @lessonNowYou.
  ///
  /// In en, this message translates to:
  /// **'Now make the move.'**
  String get lessonNowYou;

  /// No description provided for @lessonSuccess.
  ///
  /// In en, this message translates to:
  /// **'Well done!'**
  String get lessonSuccess;

  /// No description provided for @lessonFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get lessonFinish;

  /// No description provided for @lessonSuggestTitle.
  ///
  /// In en, this message translates to:
  /// **'New technique: {technique}'**
  String lessonSuggestTitle(String technique);

  /// No description provided for @lessonSuggestMessage.
  ///
  /// In en, this message translates to:
  /// **'Level {level} needs it. A short lesson shows how it works.'**
  String lessonSuggestMessage(int level);

  /// No description provided for @lessonOpen.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lessonOpen;

  /// No description provided for @playNow.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playNow;

  /// No description provided for @lessonIntroHiddenSingle.
  ///
  /// In en, this message translates to:
  /// **'A hidden single is a digit that fits in only one cell of a row, column or box. Pick a box and a digit it still lacks: if every other cell already sees that digit, it goes in the one cell left.'**
  String get lessonIntroHiddenSingle;

  /// No description provided for @lessonIntroNakedSingle.
  ///
  /// In en, this message translates to:
  /// **'A naked single is a cell that can hold only one digit: its row, column and box already hold the other eight between them.'**
  String get lessonIntroNakedSingle;

  /// No description provided for @lessonIntroPointingPair.
  ///
  /// In en, this message translates to:
  /// **'If, inside a box, a digit can only go in one row (or column), it must go in that row there. So it can\'t go anywhere else along that row.'**
  String get lessonIntroPointingPair;

  /// No description provided for @lessonIntroBoxLine.
  ///
  /// In en, this message translates to:
  /// **'If, along a row (or column), a digit can only go inside one box, it must go there in that box. So it can\'t go in the box\'s other cells.'**
  String get lessonIntroBoxLine;

  /// No description provided for @lessonIntroNakedPair.
  ///
  /// In en, this message translates to:
  /// **'If two cells of a row, column or box can only hold the same two digits, those two digits go in those two cells. No other cell of that unit can hold them.'**
  String get lessonIntroNakedPair;

  /// No description provided for @lessonIntroHiddenPair.
  ///
  /// In en, this message translates to:
  /// **'If two digits fit only in the same two cells of a row, column or box, those cells must take them. Any other candidates in those two cells can go.'**
  String get lessonIntroHiddenPair;

  /// No description provided for @lessonIntroNakedTriple.
  ///
  /// In en, this message translates to:
  /// **'If three cells of a unit can only hold three digits between them, those three digits go in those cells. The rest of the unit can\'t hold them.'**
  String get lessonIntroNakedTriple;

  /// No description provided for @lessonIntroXWing.
  ///
  /// In en, this message translates to:
  /// **'If, in two rows, a digit fits in only two cells each, and those cells line up in the same two columns, the digit takes one corner in each row. Either way, those columns get it there, so it can\'t go anywhere else in them.'**
  String get lessonIntroXWing;

  /// No description provided for @optionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get optionsTitle;

  /// No description provided for @optSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get optSound;

  /// No description provided for @optSoundDesc.
  ///
  /// In en, this message translates to:
  /// **'Music and sound effects.'**
  String get optSoundDesc;

  /// No description provided for @optTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get optTimer;

  /// No description provided for @optTimerDesc.
  ///
  /// In en, this message translates to:
  /// **'Show the clock while you play. Your time is always recorded for the scoreboard.'**
  String get optTimerDesc;

  /// No description provided for @optShowErrors.
  ///
  /// In en, this message translates to:
  /// **'Show errors'**
  String get optShowErrors;

  /// No description provided for @optShowErrorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Mark a wrong number in red as soon as you enter it.'**
  String get optShowErrorsDesc;

  /// No description provided for @optMarkConflicts.
  ///
  /// In en, this message translates to:
  /// **'Mark conflicts'**
  String get optMarkConflicts;

  /// No description provided for @optMarkConflictsDesc.
  ///
  /// In en, this message translates to:
  /// **'Outline two equal digits in the same row, column or box. It doesn\'t use the solution, so it gives nothing away.'**
  String get optMarkConflictsDesc;

  /// No description provided for @cellEmpty.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get cellEmpty;

  /// No description provided for @cellGiven.
  ///
  /// In en, this message translates to:
  /// **'given'**
  String get cellGiven;

  /// No description provided for @cellHint.
  ///
  /// In en, this message translates to:
  /// **'hint'**
  String get cellHint;

  /// No description provided for @cellWrong.
  ///
  /// In en, this message translates to:
  /// **'wrong'**
  String get cellWrong;

  /// No description provided for @cellConflict.
  ///
  /// In en, this message translates to:
  /// **'conflict'**
  String get cellConflict;

  /// No description provided for @cellNotes.
  ///
  /// In en, this message translates to:
  /// **'notes {notes}'**
  String cellNotes(String notes);

  /// No description provided for @numberKey.
  ///
  /// In en, this message translates to:
  /// **'{digit}, {remaining} left'**
  String numberKey(int digit, int remaining);

  /// No description provided for @optHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get optHighContrast;

  /// No description provided for @optHighContrastDesc.
  ///
  /// In en, this message translates to:
  /// **'Stronger grid lines, notes and highlights on the board. Also on when the system asks for more contrast.'**
  String get optHighContrastDesc;

  /// No description provided for @optHints.
  ///
  /// In en, this message translates to:
  /// **'Hint button'**
  String get optHints;

  /// No description provided for @optHintsDesc.
  ///
  /// In en, this message translates to:
  /// **'Show a button for the logic coach: it explains the next step, and placing the digit costs +{seconds} s.'**
  String optHintsDesc(int seconds);

  /// No description provided for @optLeftHanded.
  ///
  /// In en, this message translates to:
  /// **'Left-handed'**
  String get optLeftHanded;

  /// No description provided for @optLeftHandedDesc.
  ///
  /// In en, this message translates to:
  /// **'With the device sideways, put the number keys to the left of the grid.'**
  String get optLeftHandedDesc;

  /// No description provided for @optFillNotes.
  ///
  /// In en, this message translates to:
  /// **'Fill notes on easy levels'**
  String get optFillNotes;

  /// No description provided for @optFillNotesDesc.
  ///
  /// In en, this message translates to:
  /// **'In Notes mode, offer to fill in every candidate on levels 1–5 too. Levels 6–9 always offer it.'**
  String get optFillNotesDesc;

  /// No description provided for @optHaptics.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get optHaptics;

  /// No description provided for @optHapticsDesc.
  ///
  /// In en, this message translates to:
  /// **'A light tap for each entry, and a stronger one for the win and for errors (with Show errors on).'**
  String get optHapticsDesc;

  /// No description provided for @restoreDefaults.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get restoreDefaults;

  /// No description provided for @scoreboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Scoreboard'**
  String get scoreboardTitle;

  /// No description provided for @noScores.
  ///
  /// In en, this message translates to:
  /// **'No puzzles solved at this level yet.'**
  String get noScores;

  /// No description provided for @clearScores.
  ///
  /// In en, this message translates to:
  /// **'Clear scoreboard'**
  String get clearScores;

  /// No description provided for @clearScoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the scoreboard?'**
  String get clearScoresTitle;

  /// No description provided for @clearScoresMessage.
  ///
  /// In en, this message translates to:
  /// **'All scores for every level will be deleted. This cannot be undone.'**
  String get clearScoresMessage;

  /// No description provided for @leaderboards.
  ///
  /// In en, this message translates to:
  /// **'Leaderboards'**
  String get leaderboards;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @bestTimes.
  ///
  /// In en, this message translates to:
  /// **'Best times'**
  String get bestTimes;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @statPlayed.
  ///
  /// In en, this message translates to:
  /// **'Played'**
  String get statPlayed;

  /// No description provided for @statSolved.
  ///
  /// In en, this message translates to:
  /// **'Solved'**
  String get statSolved;

  /// No description provided for @statBestTime.
  ///
  /// In en, this message translates to:
  /// **'Best time'**
  String get statBestTime;

  /// No description provided for @statAverageTime.
  ///
  /// In en, this message translates to:
  /// **'Average time'**
  String get statAverageTime;

  /// No description provided for @statNoHints.
  ///
  /// In en, this message translates to:
  /// **'Without hints'**
  String get statNoHints;

  /// No description provided for @statNoMistakes.
  ///
  /// In en, this message translates to:
  /// **'Without mistakes'**
  String get statNoMistakes;

  /// No description provided for @streakCurrent.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get streakCurrent;

  /// No description provided for @streakBest.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get streakBest;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day} other{{count} days}}'**
  String streakDays(int count);

  /// No description provided for @streakNote.
  ///
  /// In en, this message translates to:
  /// **'A day counts when you solve at least one puzzle.'**
  String get streakNote;

  /// No description provided for @clearStats.
  ///
  /// In en, this message translates to:
  /// **'Reset statistics'**
  String get clearStats;

  /// No description provided for @clearStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset the statistics?'**
  String get clearStatsTitle;

  /// No description provided for @clearStatsMessage.
  ///
  /// In en, this message translates to:
  /// **'The statistics of every level and the day streaks will be deleted. This cannot be undone.'**
  String get clearStatsMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @infoScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoScreenTitle;

  /// No description provided for @howToPlayTitle.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get howToPlayTitle;

  /// No description provided for @howToPlayText.
  ///
  /// In en, this message translates to:
  /// **'Fill every empty cell so that each row, each column and each 3×3 box contains the digits 1 to 9 exactly once. Every puzzle has a single solution and can be solved by logic alone — no guessing needed. Use Notes to pencil in the candidates of a cell.'**
  String get howToPlayText;

  /// No description provided for @sudokuBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Why is Sudoku good for the brain?'**
  String get sudokuBenefitsTitle;

  /// No description provided for @sudokuBenefitsIntro.
  ///
  /// In en, this message translates to:
  /// **'Sudoku is a pure logic puzzle: no arithmetic, just deduction. Research on number puzzles and Sudoku points to these benefits:'**
  String get sudokuBenefitsIntro;

  /// No description provided for @benefit1Title.
  ///
  /// In en, this message translates to:
  /// **'🔢 Logical and Deductive Reasoning'**
  String get benefit1Title;

  /// No description provided for @benefit1Desc.
  ///
  /// In en, this message translates to:
  /// **'Every move is a deduction: \"this cell can only be 7\" or \"the 3 can only go here\". Sudoku-based training programmes target attention and logical-deductive reasoning, and a randomised trial in older adults with mild cognitive impairment reported gains in global cognition after Sudoku training.'**
  String get benefit1Desc;

  /// No description provided for @benefit2Title.
  ///
  /// In en, this message translates to:
  /// **'🧠 Working Memory'**
  String get benefit2Title;

  /// No description provided for @benefit2Desc.
  ///
  /// In en, this message translates to:
  /// **'Keeping candidates and the constraints of rows, columns and boxes in mind loads working memory. Studies in older adults found that Sudoku performance relates to working-memory capacity. Brain-imaging studies show that solving Sudoku engages the frontal and parietal networks that support working memory and executive control.'**
  String get benefit2Desc;

  /// No description provided for @benefit3Title.
  ///
  /// In en, this message translates to:
  /// **'🎯 Attention and Concentration'**
  String get benefit3Title;

  /// No description provided for @benefit3Desc.
  ///
  /// In en, this message translates to:
  /// **'In a study of over 19,000 adults aged 50 and over, those who did number puzzles more often scored better on tests of attention, reasoning and memory.'**
  String get benefit3Desc;

  /// No description provided for @benefit4Title.
  ///
  /// In en, this message translates to:
  /// **'⚡ Processing Speed and Executive Function'**
  String get benefit4Title;

  /// No description provided for @benefit4Desc.
  ///
  /// In en, this message translates to:
  /// **'The same research linked regular number-puzzle play to faster information processing and better executive function — planning, checking and switching strategies.'**
  String get benefit4Desc;

  /// No description provided for @benefit5Title.
  ///
  /// In en, this message translates to:
  /// **'🛡️ Cognitive Reserve and Healthy Ageing'**
  String get benefit5Title;

  /// No description provided for @benefit5Desc.
  ///
  /// In en, this message translates to:
  /// **'Long-term studies associate mentally stimulating games and puzzles with better cognitive function later in life and slower cognitive decline — consistent with building cognitive reserve. It\'s never too late: people who took up puzzles later also showed benefits.'**
  String get benefit5Desc;

  /// No description provided for @benefit6Title.
  ///
  /// In en, this message translates to:
  /// **'😌 Focus, Flow and Well-being'**
  String get benefit6Title;

  /// No description provided for @benefit6Desc.
  ///
  /// In en, this message translates to:
  /// **'A puzzle matched to your skill invites \"flow\" — full absorption in the task — which is linked to enjoyment and reduced stress. Nine difficulty levels let you keep the challenge just right.'**
  String get benefit6Desc;

  /// No description provided for @evidenceNote.
  ///
  /// In en, this message translates to:
  /// **'A note on the evidence: most of these studies are observational, so they show associations rather than proof of cause. Sudoku works best as one part of an active lifestyle that also includes exercise, sleep and social life.'**
  String get evidenceNote;

  /// No description provided for @scientificReferences.
  ///
  /// In en, this message translates to:
  /// **'Scientific References'**
  String get scientificReferences;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by Tekinsight - Information Technologies'**
  String get developedBy;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @sounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get sounds;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
