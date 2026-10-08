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
  /// **'{band} · {clues} clues'**
  String levelSummary(String band, int clues);

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
  /// **'Pick a cell, then a number'**
  String get statusPlay;

  /// No description provided for @statusNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes: tap numbers to mark candidates'**
  String get statusNotes;

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

  /// No description provided for @leaveGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this game?'**
  String get leaveGameTitle;

  /// No description provided for @leaveGameMessage.
  ///
  /// In en, this message translates to:
  /// **'Your progress on this puzzle will be lost.'**
  String get leaveGameMessage;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Keep playing'**
  String get stay;

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
  /// **'Next level: {band} · {clues} clues'**
  String nextLevelInfo(String band, int clues);

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

  /// No description provided for @optHints.
  ///
  /// In en, this message translates to:
  /// **'Hint button'**
  String get optHints;

  /// No description provided for @optHintsDesc.
  ///
  /// In en, this message translates to:
  /// **'Show a button that fills in a correct number (+{seconds} s).'**
  String optHintsDesc(int seconds);

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
  /// **'Keeping candidates and the constraints of rows, columns and boxes in mind loads working memory. Studies in older adults found that Sudoku performance relates to working-memory capacity.'**
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
