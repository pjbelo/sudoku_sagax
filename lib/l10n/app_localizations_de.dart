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
  String levelSummary(String band, int clues) {
    return '$band · $clues Vorgaben';
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
  String get play => 'SPIELEN';

  @override
  String get info => 'Info';

  @override
  String get options => 'Optionen';

  @override
  String get scoreboard => 'Bestenliste';

  @override
  String get levelLabel => 'Level';

  @override
  String get timeLabel => 'Zeit';

  @override
  String get mistakesLabel => 'Fehler';

  @override
  String get statusPlay => 'Wähle ein Feld, dann eine Zahl';

  @override
  String get statusNotes =>
      'Notizen: Tippe auf Zahlen, um Kandidaten zu markieren';

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
  String get erase => 'Löschen';

  @override
  String get notes => 'Notizen';

  @override
  String hint(int seconds) {
    return 'Tipp +${seconds}s';
  }

  @override
  String get leaveGameTitle => 'Dieses Spiel verlassen?';

  @override
  String get leaveGameMessage =>
      'Dein Fortschritt bei diesem Rätsel geht verloren.';

  @override
  String get leave => 'Verlassen';

  @override
  String get stay => 'Weiterspielen';

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
  String nextLevelInfo(String band, int clues) {
    return 'Nächstes Level: $band · $clues Vorgaben';
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
  String get optHints => 'Tipp-Taste';

  @override
  String optHintsDesc(int seconds) {
    return 'Zeigt eine Taste, die eine richtige Zahl einträgt (+$seconds s).';
  }

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
}
