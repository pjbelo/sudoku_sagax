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
  String get statusPlay => 'Choisissez une case, puis un chiffre';

  @override
  String get statusNotes =>
      'Notes : touchez les chiffres pour noter les candidats';

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
  String get erase => 'Effacer';

  @override
  String get notes => 'Notes';

  @override
  String hint(int seconds) {
    return 'Indice +${seconds}s';
  }

  @override
  String get leaveGameTitle => 'Quitter cette partie ?';

  @override
  String get leaveGameMessage =>
      'Votre progression sur cette grille sera perdue.';

  @override
  String get leave => 'Quitter';

  @override
  String get stay => 'Continuer';

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
  String get optHints => 'Bouton d\'indice';

  @override
  String optHintsDesc(int seconds) {
    return 'Affiche un bouton qui remplit un chiffre correct (+$seconds s).';
  }

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
      'Garder en tête les candidats et les contraintes des lignes, colonnes et carrés sollicite la mémoire de travail. Des études chez des adultes âgés ont montré que la performance au Sudoku est liée à la capacité de la mémoire de travail.';

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
