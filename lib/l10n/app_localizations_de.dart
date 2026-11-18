// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Sudoku Sagax';

  @override
  String get bySagaxGames => 'by Sagax Games';

  @override
  String get sagaxGames => 'Sagax Games';

  @override
  String get tagline => 'Fülle das Gitter, schärfe deinen Geist';

  @override
  String get selectLevel => 'Level wählen:';

  @override
  String levelSummary(String band, String technique) {
    return '$band · $technique';
  }

  @override
  String get bandBeginner => 'Anfänger';

  @override
  String get bandEasy => 'Leicht';

  @override
  String get bandMedium => 'Mittel';

  @override
  String get bandHard => 'Schwer';

  @override
  String get bandExpert => 'Experte';

  @override
  String get trainsSingles => 'Singles';

  @override
  String get trainsLockedCandidates => 'zeigende Paare';

  @override
  String get trainsPairs => 'Paare';

  @override
  String get trainsTriples => 'Tripel';

  @override
  String get trainsXWing => 'X-Wing';

  @override
  String get play => 'SPIELEN';

  @override
  String get info => 'Info';

  @override
  String get options => 'Optionen';

  @override
  String get scoreboard => 'Bestenliste';

  @override
  String get daily => 'Täglich';

  @override
  String get dailyTitle => 'Tagesrätsel';

  @override
  String get dailyIntro =>
      'Ein Rätsel pro Tag, für alle dasselbe. Am Wochenanfang leichter, am Wochenende schwerer.';

  @override
  String dailyToday(String date) {
    return 'Heute · $date';
  }

  @override
  String get dailyPlay => 'Heutiges Rätsel spielen';

  @override
  String get dailyContinue => 'Heutiges Rätsel fortsetzen';

  @override
  String dailySolved(String time) {
    return 'Heute gelöst in $time';
  }

  @override
  String get dailyStreak => 'Tagesserie';

  @override
  String get dailyBestStreak => 'Beste Tagesserie';

  @override
  String get dailyComeBack => 'Komm morgen für ein neues Rätsel wieder.';

  @override
  String get levelLabel => 'Level';

  @override
  String get timeLabel => 'Zeit';

  @override
  String get mistakesLabel => 'Fehler';

  @override
  String get statusPlay =>
      'Wähle ein Feld und eine Zahl, in beliebiger Reihenfolge';

  @override
  String get statusNotes =>
      'Notizen: Tippe auf Zahlen, um Kandidaten zu markieren';

  @override
  String get statusNotesFill =>
      'Notizen · hier tippen, um alle Kandidaten einzutragen';

  @override
  String statusDigit(int digit) {
    return '$digit: Tippe auf die Felder, in die sie gehört';
  }

  @override
  String statusDigitNotes(int digit) {
    return '$digit: Tippe auf Felder, um sie als Kandidat zu notieren';
  }

  @override
  String get statusFullWrong => 'Das Gitter ist voll, aber etwas stimmt nicht';

  @override
  String get solved => 'Gelöst!';

  @override
  String get paused => 'Pausiert';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get pause => 'Pause';

  @override
  String get undo => 'Rückgängig';

  @override
  String get redo => 'Wiederholen';

  @override
  String get erase => 'Löschen';

  @override
  String get notes => 'Notizen';

  @override
  String hint(int seconds) {
    return 'Tipp +${seconds}s';
  }

  @override
  String get techniqueHiddenSingle => 'Versteckter Single';

  @override
  String get techniqueNakedSingle => 'Nackter Single';

  @override
  String get techniquePointingPair => 'Zeigendes Paar';

  @override
  String get techniqueBoxLine => 'Linie-Block-Reduktion';

  @override
  String get techniqueNakedPair => 'Nacktes Paar';

  @override
  String get techniqueHiddenPair => 'Verstecktes Paar';

  @override
  String get techniqueNakedTriple => 'Nacktes Tripel';

  @override
  String get techniqueXWing => 'X-Wing';

  @override
  String get techniqueMistake => 'Fehler';

  @override
  String get techniqueFromSolution => 'Aus der Lösung';

  @override
  String unitRow(int n) {
    return 'Zeile $n';
  }

  @override
  String unitColumn(int n) {
    return 'Spalte $n';
  }

  @override
  String unitBox(int n) {
    return 'Block $n';
  }

  @override
  String coachLook(String unit) {
    return 'Schau hier: $unit.';
  }

  @override
  String coachLookMistake(String unit) {
    return 'Eine deiner Zahlen ist falsch. Schau hier: $unit.';
  }

  @override
  String coachLookFallback(String unit) {
    return 'Keine Technik des Trainers hilft hier. Schau hier: $unit.';
  }

  @override
  String coachHiddenSingle(String unit, int digit) {
    return '$unit: Die $digit passt nur in ein Feld.';
  }

  @override
  String coachNakedSingle(int digit) {
    return 'Das markierte Feld sieht in seiner Zeile, Spalte und seinem Block schon alle Zahlen außer der $digit, also muss es die $digit sein.';
  }

  @override
  String coachPointingRow(String box, int digit) {
    return '$box: Die $digit passt nur in die markierten Felder, alle in derselben Zeile. Also kann sie nicht in die roten Felder dieser Zeile.';
  }

  @override
  String coachPointingColumn(String box, int digit) {
    return '$box: Die $digit passt nur in die markierten Felder, alle in derselben Spalte. Also kann sie nicht in die roten Felder dieser Spalte.';
  }

  @override
  String coachBoxLine(String line, int digit) {
    return '$line: Die $digit passt nur in die markierten Felder, alle im selben Block. Also kann sie nicht in die roten Felder dieses Blocks.';
  }

  @override
  String coachNakedPair(String unit, int a, int b) {
    return '$unit: Die zwei markierten Felder können nur $a oder $b enthalten. Also können die roten Felder sie nicht enthalten.';
  }

  @override
  String coachHiddenPair(String unit, int a, int b) {
    return '$unit: Die $a und die $b passen nur in die zwei markierten Felder. Also können diese Felder keine andere Zahl enthalten.';
  }

  @override
  String coachNakedTriple(String unit, int a, int b, int c) {
    return '$unit: Die drei markierten Felder können nur $a, $b oder $c enthalten. Also können die roten Felder sie nicht enthalten.';
  }

  @override
  String coachXWingRows(int digit) {
    return 'In zwei Zeilen passt die $digit nur in die vier markierten Felder, die sich zwei Spalten teilen. So oder so bekommt jede dieser Spalten dort ihre $digit, also kann sie nicht in die roten Felder.';
  }

  @override
  String coachXWingColumns(int digit) {
    return 'In zwei Spalten passt die $digit nur in die vier markierten Felder, die sich zwei Zeilen teilen. So oder so bekommt jede dieser Zeilen dort ihre $digit, also kann sie nicht in die roten Felder.';
  }

  @override
  String coachMistake(int digit) {
    return 'Die markierte $digit gehört nicht in dieses Feld.';
  }

  @override
  String get coachFallback => 'Das markierte Feld wird aus der Lösung gefüllt.';

  @override
  String coachDone(int digit) {
    return 'Die $digit ist an ihrem Platz.';
  }

  @override
  String coachCorrected(int digit) {
    return 'Korrigiert: In dieses Feld gehört die $digit.';
  }

  @override
  String get coachShow => 'Zeigen';

  @override
  String coachApply(int seconds) {
    return 'Anwenden +${seconds}s';
  }

  @override
  String get continueGame => 'Fortsetzen';

  @override
  String get newGameTitle => 'Neues Spiel starten?';

  @override
  String newGameMessage(int level) {
    return 'Das unfertige Spiel auf Level $level geht verloren.';
  }

  @override
  String get newGame => 'Neues Spiel';

  @override
  String get congratulations => 'Glückwunsch!';

  @override
  String levelCompleted(int level, String time) {
    return 'Du hast Level $level in $time gelöst!';
  }

  @override
  String hintsAndMistakes(int hints, int mistakes) {
    return 'Tipps: $hints · Fehler: $mistakes';
  }

  @override
  String get newBestTime => '🏆 Neue Bestzeit für dieses Level!';

  @override
  String rankOnScoreboard(int rank, int level) {
    return 'Platz $rank in der Bestenliste von Level $level';
  }

  @override
  String nextLevelInfo(String band, String technique) {
    return 'Nächstes Level: $band · $technique';
  }

  @override
  String get allLevelsComplete => 'Du hast das schwerste Level gemeistert!';

  @override
  String get nextLevel => 'Nächstes Level';

  @override
  String get sameLevel => 'Gleiches Level';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get backToMenu => 'Zurück zum Menü';

  @override
  String get okButton => 'OK';

  @override
  String get review => 'Rückblick';

  @override
  String get reviewTitle => 'Spielrückblick';

  @override
  String get reviewNeeded => 'Was dieses Rätsel brauchte';

  @override
  String get reviewNeededNote =>
      'Jeder Schritt des Logik-Trainers, eine Zahl nach der anderen, gezählt nach seiner schwierigsten Technik.';

  @override
  String get reviewYourGame => 'Deine Tipps und Fehler';

  @override
  String get reviewClean => 'Keine Tipps und keine Fehler: sauber gelöst!';

  @override
  String reviewHint(String time, String technique, int digit, String cell) {
    return '$time · Tipp: $technique, die $digit in $cell.';
  }

  @override
  String reviewHintFix(String time, int digit, String cell) {
    return '$time · Tipp: korrigiert zu $digit in $cell.';
  }

  @override
  String reviewMistake(String time, int digit, String cell) {
    return '$time · Fehler: eine $digit in $cell.';
  }

  @override
  String reviewAvailable(String technique, int digit, String cell) {
    return 'Damals möglich: $technique, die $digit in $cell.';
  }

  @override
  String reviewAvailableFix(String cell) {
    return 'Damals möglich: einen früheren Fehler in $cell korrigieren.';
  }

  @override
  String cellName(int row, int column) {
    return 'Zeile $row, Spalte $column';
  }

  @override
  String get lessons => 'Lektionen';

  @override
  String get lessonsIntro =>
      'Kurze Lektionen, eine pro Technik: Die App erklärt, du machst den Zug.';

  @override
  String get lessonDoneBadge => 'Erledigt';

  @override
  String lessonFromLevel(int level) {
    return 'Ab Level $level';
  }

  @override
  String get lessonTry =>
      'Finde den Zug: Tippe auf das Feld, dann auf seine Zahl.';

  @override
  String get lessonWrong => 'Nicht dieser. Hier ist die Begründung:';

  @override
  String get lessonNowYou => 'Jetzt mach den Zug.';

  @override
  String get lessonSuccess => 'Gut gemacht!';

  @override
  String get lessonFinish => 'Fertig';

  @override
  String lessonSuggestTitle(String technique) {
    return 'Neue Technik: $technique';
  }

  @override
  String lessonSuggestMessage(int level) {
    return 'Level $level braucht sie. Eine kurze Lektion zeigt, wie sie funktioniert.';
  }

  @override
  String get lessonOpen => 'Lektion';

  @override
  String get playNow => 'Spielen';

  @override
  String get lessonIntroHiddenSingle =>
      'Ein versteckter Single ist eine Zahl, die in einer Zeile, Spalte oder einem Block nur in ein Feld passt. Wähle einen Block und eine Zahl, die ihm noch fehlt: Sehen alle anderen Felder diese Zahl schon, gehört sie in das eine Feld, das übrig bleibt.';

  @override
  String get lessonIntroNakedSingle =>
      'Ein nackter Single ist ein Feld, das nur eine Zahl enthalten kann: Seine Zeile, Spalte und sein Block enthalten die anderen acht schon.';

  @override
  String get lessonIntroPointingPair =>
      'Kann eine Zahl in einem Block nur in einer Zeile (oder Spalte) stehen, muss sie dort in dieser Zeile stehen. Also kann sie nirgends sonst in dieser Zeile stehen.';

  @override
  String get lessonIntroBoxLine =>
      'Kann eine Zahl in einer Zeile (oder Spalte) nur in einem Block stehen, muss sie dort in diesem Block stehen. Also kann sie in den übrigen Feldern des Blocks nicht stehen.';

  @override
  String get lessonIntroNakedPair =>
      'Können zwei Felder einer Zeile, Spalte oder eines Blocks nur dieselben zwei Zahlen enthalten, gehören diese Zahlen in diese zwei Felder. Kein anderes Feld der Einheit kann sie enthalten.';

  @override
  String get lessonIntroHiddenPair =>
      'Passen zwei Zahlen nur in dieselben zwei Felder einer Zeile, Spalte oder eines Blocks, müssen diese Felder sie enthalten. Alle anderen Kandidaten dieser zwei Felder fallen weg.';

  @override
  String get lessonIntroNakedTriple =>
      'Können drei Felder einer Einheit zusammen nur drei Zahlen enthalten, gehören diese drei Zahlen in diese Felder. Der Rest der Einheit kann sie nicht enthalten.';

  @override
  String get lessonIntroXWing =>
      'Passt eine Zahl in zwei Zeilen jeweils nur in zwei Felder, und liegen diese Felder in denselben zwei Spalten, besetzt die Zahl in jeder Zeile eine Ecke. So oder so bekommen diese Spalten sie dort, also kann sie nirgends sonst in ihnen stehen.';

  @override
  String get optionsTitle => 'Optionen';

  @override
  String get optSound => 'Ton';

  @override
  String get optSoundDesc => 'Musik und Soundeffekte.';

  @override
  String get optTimer => 'Stoppuhr';

  @override
  String get optTimerDesc =>
      'Zeigt die Uhr während des Spiels. Deine Zeit wird für die Bestenliste immer erfasst.';

  @override
  String get optShowErrors => 'Fehler anzeigen';

  @override
  String get optShowErrorsDesc =>
      'Markiert eine falsche Zahl rot, sobald du sie eingibst.';

  @override
  String get optMarkConflicts => 'Konflikte markieren';

  @override
  String get optMarkConflictsDesc =>
      'Umrandet zwei gleiche Zahlen in derselben Zeile, Spalte oder im selben Block. Nutzt nicht die Lösung und verrät daher nichts.';

  @override
  String get cellEmpty => 'leer';

  @override
  String get cellGiven => 'vorgegeben';

  @override
  String get cellHint => 'Tipp';

  @override
  String get cellWrong => 'falsch';

  @override
  String get cellConflict => 'im Konflikt';

  @override
  String cellNotes(String notes) {
    return 'Notizen $notes';
  }

  @override
  String numberKey(int digit, int remaining) {
    return '$digit, noch $remaining';
  }

  @override
  String get optHighContrast => 'Hoher Kontrast';

  @override
  String get optHighContrastDesc =>
      'Kräftigere Gitterlinien, Notizen und Markierungen auf dem Spielfeld. Schaltet sich auch ein, wenn das System mehr Kontrast verlangt.';

  @override
  String get optHints => 'Tipp-Taste';

  @override
  String optHintsDesc(int seconds) {
    return 'Zeigt eine Taste für den Logik-Trainer: Er erklärt den nächsten Schritt, und das Setzen der Zahl kostet +$seconds s.';
  }

  @override
  String get optLeftHanded => 'Linkshänder';

  @override
  String get optLeftHandedDesc =>
      'Im Querformat liegen die Zahlentasten links vom Gitter.';

  @override
  String get optFillNotes => 'Notizen füllen in leichten Leveln';

  @override
  String get optFillNotesDesc =>
      'Im Notizmodus auch in den Leveln 1–5 anbieten, alle Kandidaten einzutragen. Die Level 6–9 bieten es immer an.';

  @override
  String get optHaptics => 'Vibration';

  @override
  String get optHapticsDesc =>
      'Ein leichtes Tippen bei jeder Zahl, ein stärkeres beim Sieg und bei Fehlern (mit „Fehler anzeigen“).';

  @override
  String get restoreDefaults => 'Standardwerte wiederherstellen';

  @override
  String get scoreboardTitle => 'Bestenliste';

  @override
  String get noScores => 'In diesem Level wurde noch kein Rätsel gelöst.';

  @override
  String get clearScores => 'Bestenliste löschen';

  @override
  String get clearScoresTitle => 'Bestenliste löschen?';

  @override
  String get clearScoresMessage =>
      'Alle Ergebnisse aller Level werden gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get leaderboards => 'Bestenlisten';

  @override
  String get achievements => 'Erfolge';

  @override
  String get bestTimes => 'Bestzeiten';

  @override
  String get statistics => 'Statistik';

  @override
  String get statPlayed => 'Gespielt';

  @override
  String get statSolved => 'Gelöst';

  @override
  String get statBestTime => 'Bestzeit';

  @override
  String get statAverageTime => 'Durchschnitt';

  @override
  String get statNoHints => 'Ohne Tipps';

  @override
  String get statNoMistakes => 'Ohne Fehler';

  @override
  String get streakCurrent => 'Tage in Folge';

  @override
  String get streakBest => 'Beste Serie';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '$count Tag',
    );
    return '$_temp0';
  }

  @override
  String get streakNote => 'Ein Tag zählt, wenn du mindestens ein Rätsel löst.';

  @override
  String get clearStats => 'Statistik zurücksetzen';

  @override
  String get clearStatsTitle => 'Statistik zurücksetzen?';

  @override
  String get clearStatsMessage =>
      'Die Statistik aller Level und die Tagesserien werden gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get infoScreenTitle => 'Info';

  @override
  String get howToPlayTitle => 'So wird gespielt';

  @override
  String get howToPlayText =>
      'Fülle jedes leere Feld so, dass jede Zeile, jede Spalte und jeder 3×3-Block die Ziffern 1 bis 9 genau einmal enthält. Jedes Rätsel hat genau eine Lösung und lässt sich allein mit Logik lösen — ganz ohne Raten. Mit Notizen kannst du die Kandidaten eines Feldes vormerken.';

  @override
  String get sudokuBenefitsTitle => 'Warum ist Sudoku gut fürs Gehirn?';

  @override
  String get sudokuBenefitsIntro =>
      'Sudoku ist ein reines Logikrätsel: kein Rechnen, nur Schlussfolgern. Die Forschung zu Zahlenrätseln und Sudoku weist auf diese Vorteile hin:';

  @override
  String get benefit1Title => '🔢 Logisches und Deduktives Denken';

  @override
  String get benefit1Desc =>
      'Jeder Zug ist eine Schlussfolgerung: „Dieses Feld kann nur eine 7 sein“ oder „Die 3 kann nur hierhin“. Sudoku-basierte Trainingsprogramme zielen auf Aufmerksamkeit und logisch-deduktives Denken, und eine randomisierte Studie mit älteren Menschen mit leichter kognitiver Beeinträchtigung berichtete nach dem Sudoku-Training über Verbesserungen der allgemeinen Kognition.';

  @override
  String get benefit2Title => '🧠 Arbeitsgedächtnis';

  @override
  String get benefit2Desc =>
      'Kandidaten und die Regeln von Zeilen, Spalten und Blöcken im Kopf zu behalten, beansprucht das Arbeitsgedächtnis. Studien mit älteren Erwachsenen zeigten, dass die Sudoku-Leistung mit der Kapazität des Arbeitsgedächtnisses zusammenhängt. Studien mit bildgebenden Verfahren zeigen, dass das Lösen von Sudoku frontale und parietale Hirnnetzwerke aktiviert, die Arbeitsgedächtnis und exekutive Kontrolle unterstützen.';

  @override
  String get benefit3Title => '🎯 Aufmerksamkeit und Konzentration';

  @override
  String get benefit3Desc =>
      'In einer Studie mit über 19.000 Erwachsenen ab 50 Jahren schnitten diejenigen, die häufiger Zahlenrätsel lösten, bei Tests zu Aufmerksamkeit, logischem Denken und Gedächtnis besser ab.';

  @override
  String get benefit4Title =>
      '⚡ Verarbeitungsgeschwindigkeit und Exekutive Funktionen';

  @override
  String get benefit4Desc =>
      'Dieselbe Forschung brachte regelmäßiges Lösen von Zahlenrätseln mit schnellerer Informationsverarbeitung und besseren exekutiven Funktionen in Verbindung — Planen, Überprüfen und Strategiewechsel.';

  @override
  String get benefit5Title => '🛡️ Kognitive Reserve und Gesundes Altern';

  @override
  String get benefit5Desc =>
      'Langzeitstudien verbinden geistig anregende Spiele und Rätsel mit besserer kognitiver Leistung im späteren Leben und langsamerem kognitivem Abbau — passend zum Aufbau einer kognitiven Reserve. Es ist nie zu spät: Auch wer erst später mit Rätseln begann, profitierte davon.';

  @override
  String get benefit6Title => '😌 Fokus, Flow und Wohlbefinden';

  @override
  String get benefit6Desc =>
      'Ein Rätsel, das zu deinem Können passt, lädt zum „Flow“ ein — dem völligen Aufgehen in der Aufgabe —, der mit Freude und weniger Stress verbunden ist. Neun Schwierigkeitsstufen halten die Herausforderung genau richtig.';

  @override
  String get evidenceNote =>
      'Ein Hinweis zur Studienlage: Die meisten dieser Studien sind Beobachtungsstudien; sie zeigen Zusammenhänge, aber keinen Beweis für Ursache und Wirkung. Sudoku wirkt am besten als Teil eines aktiven Lebensstils, zu dem auch Bewegung, Schlaf und soziale Kontakte gehören.';

  @override
  String get scientificReferences => 'Wissenschaftliche Quellen';

  @override
  String get developedBy =>
      'Entwickelt von Tekinsight - Information Technologies';

  @override
  String get credits => 'Danksagungen';

  @override
  String get music => 'Musik';

  @override
  String get sounds => 'Klänge';

  @override
  String get license => 'Lizenz';

  @override
  String get close => 'Schließen';

  @override
  String get back => 'Zurück';

  @override
  String get share => 'Teilen';

  @override
  String shareMessage(int level, String time, String code, String website) {
    return 'Ich habe dieses Sudoku-Sagax-Rätsel (Level $level) in $time gelöst. Schaffst du es schneller?\n\nCode: $code\n\nTippe in Sudoku Sagax auf dem Startbildschirm auf Code und füge diese Nachricht ein.\n$website';
  }

  @override
  String get sharedPuzzleTitle => 'Geteiltes Rätsel';

  @override
  String get puzzleCode => 'Code';

  @override
  String get puzzleCodeTitle => 'Rätselcode';

  @override
  String get puzzleCodeIntro =>
      'Code von einem Freund bekommen? Füge seine Nachricht ein oder tippe den Code, um dasselbe Rätsel zu lösen und eure Zeiten zu vergleichen.';

  @override
  String get puzzleCodeHint => 'Nachricht einfügen oder Code eingeben';

  @override
  String puzzleCodeFound(int level, String summary) {
    return 'Level $level · $summary';
  }

  @override
  String get puzzleCodeInvalid =>
      'Noch kein gültiger Code. Prüfe die Nachricht oder den Code.';

  @override
  String get puzzleCodePlay => 'Dieses Rätsel spielen';

  @override
  String get puzzleCodeNote =>
      'Ein geteiltes Rätsel zählt in deiner Statistik, aber nicht in den Bestzeiten oder Ranglisten.';
}
