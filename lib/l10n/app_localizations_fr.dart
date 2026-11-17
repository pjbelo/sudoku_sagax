// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sudoku Sagax';

  @override
  String get bySagaxGames => 'by Sagax Games';

  @override
  String get sagaxGames => 'Sagax Games';

  @override
  String get tagline => 'Remplissez la grille, aiguisez votre esprit';

  @override
  String get selectLevel => 'Choisissez le niveau :';

  @override
  String levelSummary(String band, int clues) {
    return '$band · $clues indices';
  }

  @override
  String get bandBeginner => 'Débutant';

  @override
  String get bandEasy => 'Facile';

  @override
  String get bandMedium => 'Moyen';

  @override
  String get bandHard => 'Difficile';

  @override
  String get bandExpert => 'Expert';

  @override
  String get play => 'JOUER';

  @override
  String get info => 'Info';

  @override
  String get options => 'Options';

  @override
  String get scoreboard => 'Records';

  @override
  String get levelLabel => 'Niveau';

  @override
  String get timeLabel => 'Temps';

  @override
  String get mistakesLabel => 'Erreurs';

  @override
  String get statusPlay =>
      'Choisissez une case et un chiffre, dans l\'ordre de votre choix';

  @override
  String get statusNotes =>
      'Notes : touchez les chiffres pour noter les candidats';

  @override
  String get statusNotesFill =>
      'Notes · touchez ici pour remplir tous les candidats';

  @override
  String statusDigit(int digit) {
    return '$digit : touchez les cases où il va';
  }

  @override
  String statusDigitNotes(int digit) {
    return '$digit : touchez des cases pour le noter comme candidat';
  }

  @override
  String get statusFullWrong =>
      'La grille est pleine, mais quelque chose ne va pas';

  @override
  String get solved => 'Résolu !';

  @override
  String get paused => 'En pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get pause => 'Pause';

  @override
  String get undo => 'Annuler';

  @override
  String get redo => 'Rétablir';

  @override
  String get erase => 'Effacer';

  @override
  String get notes => 'Notes';

  @override
  String hint(int seconds) {
    return 'Indice +${seconds}s';
  }

  @override
  String get techniqueHiddenSingle => 'Singleton caché';

  @override
  String get techniqueNakedSingle => 'Singleton nu';

  @override
  String get techniquePointingPair => 'Paire pointante';

  @override
  String get techniqueBoxLine => 'Réduction ligne-carré';

  @override
  String get techniqueNakedPair => 'Paire nue';

  @override
  String get techniqueHiddenPair => 'Paire cachée';

  @override
  String get techniqueNakedTriple => 'Triplet nu';

  @override
  String get techniqueXWing => 'X-Wing';

  @override
  String get techniqueMistake => 'Erreur';

  @override
  String get techniqueFromSolution => 'D\'après la solution';

  @override
  String unitRow(int n) {
    return 'Ligne $n';
  }

  @override
  String unitColumn(int n) {
    return 'Colonne $n';
  }

  @override
  String unitBox(int n) {
    return 'Carré $n';
  }

  @override
  String coachLook(String unit) {
    return 'Où regarder : $unit.';
  }

  @override
  String coachLookMistake(String unit) {
    return 'L\'un de vos chiffres est faux. Où regarder : $unit.';
  }

  @override
  String coachLookFallback(String unit) {
    return 'Aucune technique de l\'entraîneur ne marche ici. Où regarder : $unit.';
  }

  @override
  String coachHiddenSingle(String unit, int digit) {
    return '$unit : le $digit ne va que dans une seule case.';
  }

  @override
  String coachNakedSingle(int digit) {
    return 'La case en surbrillance voit déjà tous les chiffres sauf le $digit dans sa ligne, sa colonne et son carré : c\'est donc un $digit.';
  }

  @override
  String coachPointingRow(String box, int digit) {
    return '$box : le $digit ne va que dans les cases en surbrillance, toutes sur la même ligne. Il ne peut donc pas aller dans les cases en rouge de cette ligne.';
  }

  @override
  String coachPointingColumn(String box, int digit) {
    return '$box : le $digit ne va que dans les cases en surbrillance, toutes dans la même colonne. Il ne peut donc pas aller dans les cases en rouge de cette colonne.';
  }

  @override
  String coachBoxLine(String line, int digit) {
    return '$line : le $digit ne va que dans les cases en surbrillance, toutes dans le même carré. Il ne peut donc pas aller dans les cases en rouge de ce carré.';
  }

  @override
  String coachNakedPair(String unit, int a, int b) {
    return '$unit : les deux cases en surbrillance ne peuvent contenir que $a ou $b. Les cases en rouge ne peuvent donc pas les contenir.';
  }

  @override
  String coachHiddenPair(String unit, int a, int b) {
    return '$unit : le $a et le $b ne vont que dans les deux cases en surbrillance. Ces cases ne peuvent donc contenir aucun autre chiffre.';
  }

  @override
  String coachNakedTriple(String unit, int a, int b, int c) {
    return '$unit : les trois cases en surbrillance ne peuvent contenir que $a, $b ou $c. Les cases en rouge ne peuvent donc pas les contenir.';
  }

  @override
  String coachXWingRows(int digit) {
    return 'Sur deux lignes, le $digit ne va que dans les quatre cases en surbrillance, qui partagent deux colonnes. Quoi qu\'il arrive, chacune de ces colonnes a son $digit là : il ne peut donc pas aller dans les cases en rouge.';
  }

  @override
  String coachXWingColumns(int digit) {
    return 'Dans deux colonnes, le $digit ne va que dans les quatre cases en surbrillance, qui partagent deux lignes. Quoi qu\'il arrive, chacune de ces lignes a son $digit là : il ne peut donc pas aller dans les cases en rouge.';
  }

  @override
  String coachMistake(int digit) {
    return 'Le $digit en surbrillance n\'a pas sa place dans cette case.';
  }

  @override
  String get coachFallback =>
      'La case en surbrillance sera remplie d\'après la solution.';

  @override
  String coachDone(int digit) {
    return 'Le $digit est en place.';
  }

  @override
  String coachCorrected(int digit) {
    return 'Corrigé : cette case contient un $digit.';
  }

  @override
  String get coachShow => 'Montrer';

  @override
  String coachApply(int seconds) {
    return 'Appliquer +${seconds}s';
  }

  @override
  String get continueGame => 'Reprendre';

  @override
  String get newGameTitle => 'Commencer une nouvelle partie ?';

  @override
  String newGameMessage(int level) {
    return 'La partie inachevée du niveau $level sera perdue.';
  }

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get congratulations => 'Félicitations !';

  @override
  String levelCompleted(int level, String time) {
    return 'Vous avez résolu le niveau $level en $time !';
  }

  @override
  String hintsAndMistakes(int hints, int mistakes) {
    return 'Indices : $hints · Erreurs : $mistakes';
  }

  @override
  String get newBestTime => '🏆 Nouveau record pour ce niveau !';

  @override
  String rankOnScoreboard(int rank, int level) {
    return '#$rank au classement du niveau $level';
  }

  @override
  String nextLevelInfo(String band, int clues) {
    return 'Niveau suivant : $band · $clues indices';
  }

  @override
  String get allLevelsComplete =>
      'Vous avez conquis le niveau le plus difficile !';

  @override
  String get nextLevel => 'Niveau Suivant';

  @override
  String get sameLevel => 'Même Niveau';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get backToMenu => 'Retour au Menu';

  @override
  String get okButton => 'OK';

  @override
  String get optionsTitle => 'Options';

  @override
  String get optSound => 'Son';

  @override
  String get optSoundDesc => 'Musique et effets sonores.';

  @override
  String get optTimer => 'Chronomètre';

  @override
  String get optTimerDesc =>
      'Affiche l\'horloge pendant la partie. Votre temps est toujours enregistré pour les records.';

  @override
  String get optShowErrors => 'Afficher les erreurs';

  @override
  String get optShowErrorsDesc =>
      'Marque en rouge un chiffre erroné dès que vous le saisissez.';

  @override
  String get optMarkConflicts => 'Signaler les conflits';

  @override
  String get optMarkConflictsDesc =>
      'Entoure deux chiffres identiques dans la même ligne, colonne ou carré. La solution n\'est pas utilisée : rien n\'est dévoilé.';

  @override
  String get optHints => 'Bouton d\'indice';

  @override
  String optHintsDesc(int seconds) {
    return 'Affiche un bouton pour l\'entraîneur de logique : il explique l\'étape suivante, et placer le chiffre coûte +$seconds s.';
  }

  @override
  String get optLeftHanded => 'Gaucher';

  @override
  String get optLeftHandedDesc =>
      'Appareil à l\'horizontale, les chiffres passent à gauche de la grille.';

  @override
  String get optFillNotes => 'Remplir les notes aux niveaux faciles';

  @override
  String get optFillNotesDesc =>
      'En mode Notes, proposer aussi aux niveaux 1–5 de remplir tous les candidats. Les niveaux 6–9 le proposent toujours.';

  @override
  String get optHaptics => 'Vibration';

  @override
  String get optHapticsDesc =>
      'Une légère vibration à chaque chiffre, une plus forte pour la victoire et pour les erreurs (avec Afficher les erreurs activé).';

  @override
  String get restoreDefaults => 'Rétablir les valeurs par défaut';

  @override
  String get scoreboardTitle => 'Records';

  @override
  String get noScores => 'Aucune grille résolue à ce niveau pour l\'instant.';

  @override
  String get clearScores => 'Effacer les records';

  @override
  String get clearScoresTitle => 'Effacer les records ?';

  @override
  String get clearScoresMessage =>
      'Tous les records de tous les niveaux seront supprimés. Cette action est irréversible.';

  @override
  String get bestTimes => 'Meilleurs temps';

  @override
  String get statistics => 'Statistiques';

  @override
  String get statPlayed => 'Jouées';

  @override
  String get statSolved => 'Résolues';

  @override
  String get statBestTime => 'Meilleur temps';

  @override
  String get statAverageTime => 'Temps moyen';

  @override
  String get statNoHints => 'Sans indice';

  @override
  String get statNoMistakes => 'Sans erreur';

  @override
  String get streakCurrent => 'Jours d\'affilée';

  @override
  String get streakBest => 'Meilleure série';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '$count jour',
    );
    return '$_temp0';
  }

  @override
  String get streakNote =>
      'Un jour compte quand vous résolvez au moins une grille.';

  @override
  String get clearStats => 'Réinitialiser les statistiques';

  @override
  String get clearStatsTitle => 'Réinitialiser les statistiques ?';

  @override
  String get clearStatsMessage =>
      'Les statistiques de tous les niveaux et les séries de jours seront supprimées. Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get infoScreenTitle => 'Info';

  @override
  String get howToPlayTitle => 'Comment jouer';

  @override
  String get howToPlayText =>
      'Remplissez chaque case vide de sorte que chaque ligne, chaque colonne et chaque carré 3×3 contienne les chiffres de 1 à 9 une seule fois. Chaque grille a une solution unique et se résout par la seule logique, sans deviner. Utilisez les Notes pour inscrire les candidats d\'une case.';

  @override
  String get sudokuBenefitsTitle =>
      'Pourquoi le Sudoku est-il bon pour le cerveau ?';

  @override
  String get sudokuBenefitsIntro =>
      'Le Sudoku est un pur casse-tête logique : pas de calcul, seulement de la déduction. La recherche sur les casse-têtes numériques et le Sudoku met en avant ces bienfaits :';

  @override
  String get benefit1Title => '🔢 Raisonnement Logique et Déductif';

  @override
  String get benefit1Desc =>
      'Chaque coup est une déduction : « cette case ne peut être qu\'un 7 » ou « le 3 ne peut aller qu\'ici ». Les programmes d\'entraînement basés sur le Sudoku ciblent l\'attention et le raisonnement logico-déductif, et un essai randomisé chez des personnes âgées présentant un trouble cognitif léger a rapporté des progrès de la cognition globale après un entraînement au Sudoku.';

  @override
  String get benefit2Title => '🧠 Mémoire de Travail';

  @override
  String get benefit2Desc =>
      'Garder en tête les candidats et les contraintes des lignes, colonnes et carrés sollicite la mémoire de travail. Des études chez des adultes âgés ont montré que la performance au Sudoku est liée à la capacité de la mémoire de travail. Des études d\'imagerie cérébrale montrent que résoudre un Sudoku active les réseaux frontaux et pariétaux qui soutiennent la mémoire de travail et le contrôle exécutif.';

  @override
  String get benefit3Title => '🎯 Attention et Concentration';

  @override
  String get benefit3Desc =>
      'Dans une étude portant sur plus de 19 000 adultes de 50 ans et plus, ceux qui faisaient le plus souvent des casse-têtes numériques obtenaient de meilleurs résultats aux tests d\'attention, de raisonnement et de mémoire.';

  @override
  String get benefit4Title => '⚡ Vitesse de Traitement et Fonctions Exécutives';

  @override
  String get benefit4Desc =>
      'La même recherche a associé la pratique régulière de casse-têtes numériques à un traitement de l\'information plus rapide et à de meilleures fonctions exécutives : planifier, vérifier et changer de stratégie.';

  @override
  String get benefit5Title => '🛡️ Réserve Cognitive et Vieillissement Sain';

  @override
  String get benefit5Desc =>
      'Des études à long terme associent les jeux et casse-têtes stimulants à une meilleure fonction cognitive plus tard dans la vie et à un déclin cognitif plus lent, ce qui concorde avec la constitution d\'une réserve cognitive. Il n\'est jamais trop tard : ceux qui s\'y sont mis plus tard en ont aussi bénéficié.';

  @override
  String get benefit6Title => '😌 Concentration, Flow et Bien-être';

  @override
  String get benefit6Desc =>
      'Une grille adaptée à votre niveau favorise le « flow » — l\'absorption totale dans la tâche — associé au plaisir et à la réduction du stress. Neuf niveaux de difficulté vous permettent de garder le défi juste à la bonne mesure.';

  @override
  String get evidenceNote =>
      'Une remarque sur les données : la plupart de ces études sont observationnelles ; elles montrent des associations, pas une preuve de cause à effet. Le Sudoku est plus efficace dans le cadre d\'un mode de vie actif, qui inclut aussi l\'exercice, le sommeil et la vie sociale.';

  @override
  String get scientificReferences => 'Références Scientifiques';

  @override
  String get developedBy =>
      'Développé par Tekinsight - Information Technologies';

  @override
  String get credits => 'Crédits';

  @override
  String get music => 'Musique';

  @override
  String get sounds => 'Sons';

  @override
  String get license => 'Licence';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';
}
