// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Sudoku Sagax';

  @override
  String get bySagaxGames => 'by Sagax Games';

  @override
  String get sagaxGames => 'Sagax Games';

  @override
  String get tagline => 'Preenche a grelha, afia a mente';

  @override
  String get selectLevel => 'Seleciona o nível:';

  @override
  String levelSummary(String band, int clues) {
    return '$band · $clues pistas';
  }

  @override
  String get bandBeginner => 'Iniciante';

  @override
  String get bandEasy => 'Fácil';

  @override
  String get bandMedium => 'Médio';

  @override
  String get bandHard => 'Difícil';

  @override
  String get bandExpert => 'Especialista';

  @override
  String get play => 'JOGAR';

  @override
  String get info => 'Info';

  @override
  String get options => 'Opções';

  @override
  String get scoreboard => 'Recordes';

  @override
  String get levelLabel => 'Nível';

  @override
  String get timeLabel => 'Tempo';

  @override
  String get mistakesLabel => 'Erros';

  @override
  String get statusPlay => 'Escolhe uma célula e depois um número';

  @override
  String get statusNotes => 'Notas: toca nos números para marcar candidatos';

  @override
  String get statusFullWrong =>
      'A grelha está cheia, mas há algo que não está certo';

  @override
  String get solved => 'Resolvido!';

  @override
  String get paused => 'Em pausa';

  @override
  String get resume => 'Continuar';

  @override
  String get pause => 'Pausa';

  @override
  String get undo => 'Desfazer';

  @override
  String get erase => 'Apagar';

  @override
  String get notes => 'Notas';

  @override
  String hint(int seconds) {
    return 'Ajuda +${seconds}s';
  }

  @override
  String get leaveGameTitle => 'Sair deste jogo?';

  @override
  String get leaveGameMessage => 'O progresso neste puzzle será perdido.';

  @override
  String get leave => 'Sair';

  @override
  String get stay => 'Continuar a jogar';

  @override
  String get congratulations => 'Parabéns!';

  @override
  String levelCompleted(int level, String time) {
    return 'Resolveste o nível $level em $time!';
  }

  @override
  String hintsAndMistakes(int hints, int mistakes) {
    return 'Ajudas: $hints · Erros: $mistakes';
  }

  @override
  String get newBestTime => '🏆 Novo recorde neste nível!';

  @override
  String rankOnScoreboard(int rank, int level) {
    return '#$rank nos recordes do nível $level';
  }

  @override
  String nextLevelInfo(String band, int clues) {
    return 'Próximo nível: $band · $clues pistas';
  }

  @override
  String get allLevelsComplete => 'Conquistaste o nível mais difícil!';

  @override
  String get nextLevel => 'Próximo Nível';

  @override
  String get sameLevel => 'Mesmo Nível';

  @override
  String get playAgain => 'Jogar Novamente';

  @override
  String get backToMenu => 'Voltar ao Menu';

  @override
  String get okButton => 'OK';

  @override
  String get optionsTitle => 'Opções';

  @override
  String get optSound => 'Som';

  @override
  String get optSoundDesc => 'Música e efeitos sonoros.';

  @override
  String get optTimer => 'Cronómetro';

  @override
  String get optTimerDesc =>
      'Mostra o relógio enquanto jogas. O teu tempo é sempre registado nos recordes.';

  @override
  String get optShowErrors => 'Mostrar erros';

  @override
  String get optShowErrorsDesc =>
      'Marca a vermelho um número errado assim que o introduzes.';

  @override
  String get optHints => 'Botão de ajuda';

  @override
  String optHintsDesc(int seconds) {
    return 'Mostra um botão que preenche um número correto (+$seconds s).';
  }

  @override
  String get restoreDefaults => 'Repor predefinições';

  @override
  String get scoreboardTitle => 'Recordes';

  @override
  String get noScores => 'Ainda não resolveste nenhum puzzle neste nível.';

  @override
  String get clearScores => 'Apagar recordes';

  @override
  String get clearScoresTitle => 'Apagar os recordes?';

  @override
  String get clearScoresMessage =>
      'Todos os recordes de todos os níveis serão apagados. Esta ação não pode ser desfeita.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Apagar';

  @override
  String get infoScreenTitle => 'Info';

  @override
  String get howToPlayTitle => 'Como jogar';

  @override
  String get howToPlayText =>
      'Preenche todas as células vazias de modo que cada linha, cada coluna e cada quadrado 3×3 contenha os algarismos de 1 a 9 uma única vez. Cada puzzle tem uma só solução e resolve-se apenas com lógica — sem adivinhar. Usa as Notas para marcar os candidatos de uma célula.';

  @override
  String get sudokuBenefitsTitle => 'Porque é que o Sudoku faz bem ao cérebro?';

  @override
  String get sudokuBenefitsIntro =>
      'O Sudoku é um puzzle de lógica pura: não há contas, apenas dedução. A investigação sobre puzzles numéricos e Sudoku aponta para estes benefícios:';

  @override
  String get benefit1Title => '🔢 Raciocínio Lógico e Dedutivo';

  @override
  String get benefit1Desc =>
      'Cada jogada é uma dedução: \"esta célula só pode ser 7\" ou \"o 3 só pode ir aqui\". Os programas de treino baseados em Sudoku trabalham a atenção e o raciocínio lógico-dedutivo, e um ensaio aleatorizado com idosos com défice cognitivo ligeiro registou melhorias na cognição global após o treino com Sudoku.';

  @override
  String get benefit2Title => '🧠 Memória de Trabalho';

  @override
  String get benefit2Desc =>
      'Manter em mente os candidatos e as regras de linhas, colunas e quadrados exige memória de trabalho. Estudos com adultos mais velhos mostraram que o desempenho no Sudoku está relacionado com a capacidade da memória de trabalho.';

  @override
  String get benefit3Title => '🎯 Atenção e Concentração';

  @override
  String get benefit3Desc =>
      'Num estudo com mais de 19 000 adultos com 50 ou mais anos, quem fazia puzzles numéricos com mais frequência teve melhores resultados em testes de atenção, raciocínio e memória.';

  @override
  String get benefit4Title =>
      '⚡ Velocidade de Processamento e Funções Executivas';

  @override
  String get benefit4Desc =>
      'A mesma investigação associou a prática regular de puzzles numéricos a um processamento de informação mais rápido e a melhores funções executivas — planear, verificar e mudar de estratégia.';

  @override
  String get benefit5Title => '🛡️ Reserva Cognitiva e Envelhecimento Saudável';

  @override
  String get benefit5Desc =>
      'Estudos de longo prazo associam jogos e puzzles mentalmente estimulantes a uma melhor função cognitiva mais tarde na vida e a um declínio cognitivo mais lento — coerente com a construção de reserva cognitiva. Nunca é tarde: quem começou a fazer puzzles mais tarde também mostrou benefícios.';

  @override
  String get benefit6Title => '😌 Foco, Flow e Bem-estar';

  @override
  String get benefit6Desc =>
      'Um puzzle ajustado à tua capacidade convida ao \"flow\" — a absorção total na tarefa — associado ao prazer e à redução do stress. Nove níveis de dificuldade permitem manter o desafio na medida certa.';

  @override
  String get evidenceNote =>
      'Uma nota sobre as evidências: a maioria destes estudos é observacional, pelo que mostra associações e não provas de causa. O Sudoku funciona melhor como parte de um estilo de vida ativo, que inclua também exercício, sono e vida social.';

  @override
  String get scientificReferences => 'Referências Científicas';

  @override
  String get developedBy =>
      'Desenvolvido por Tekinsight - Information Technologies';

  @override
  String get credits => 'Créditos';

  @override
  String get music => 'Música';

  @override
  String get sounds => 'Sons';

  @override
  String get license => 'Licença';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';
}
