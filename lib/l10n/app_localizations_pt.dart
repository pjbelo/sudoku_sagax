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
  String levelSummary(String band, String technique) {
    return '$band · $technique';
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
  String get trainsSingles => 'únicos';

  @override
  String get trainsLockedCandidates => 'pares apontadores';

  @override
  String get trainsPairs => 'pares';

  @override
  String get trainsTriples => 'trios';

  @override
  String get trainsXWing => 'X-Wing';

  @override
  String get play => 'JOGAR';

  @override
  String get info => 'Info';

  @override
  String get options => 'Opções';

  @override
  String get scoreboard => 'Recordes';

  @override
  String get daily => 'Diário';

  @override
  String get dailyTitle => 'Puzzle diário';

  @override
  String get dailyIntro =>
      'Um puzzle por dia, o mesmo para todos. Mais fácil no início da semana, mais difícil ao fim de semana.';

  @override
  String dailyToday(String date) {
    return 'Hoje · $date';
  }

  @override
  String get dailyPlay => 'Jogar o puzzle de hoje';

  @override
  String get dailyContinue => 'Continuar o puzzle de hoje';

  @override
  String dailySolved(String time) {
    return 'Resolvido hoje em $time';
  }

  @override
  String get dailyStreak => 'Sequência diária';

  @override
  String get dailyBestStreak => 'Melhor sequência diária';

  @override
  String get dailyComeBack => 'Volta amanhã para um puzzle novo.';

  @override
  String get levelLabel => 'Nível';

  @override
  String get timeLabel => 'Tempo';

  @override
  String get mistakesLabel => 'Erros';

  @override
  String get statusPlay => 'Escolhe uma célula e um número, por qualquer ordem';

  @override
  String get statusNotes => 'Notas: toca nos números para marcar candidatos';

  @override
  String get statusNotesFill =>
      'Notas · toca aqui para preencher todos os candidatos';

  @override
  String statusDigit(int digit) {
    return '$digit: toca nas células onde vai';
  }

  @override
  String statusDigitNotes(int digit) {
    return '$digit: toca nas células para o marcar como candidato';
  }

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
  String get redo => 'Refazer';

  @override
  String get erase => 'Apagar';

  @override
  String get notes => 'Notas';

  @override
  String hint(int seconds) {
    return 'Ajuda +${seconds}s';
  }

  @override
  String get techniqueHiddenSingle => 'Única posição';

  @override
  String get techniqueNakedSingle => 'Único candidato';

  @override
  String get techniquePointingPair => 'Par apontador';

  @override
  String get techniqueBoxLine => 'Redução linha-quadrado';

  @override
  String get techniqueNakedPair => 'Par nu';

  @override
  String get techniqueHiddenPair => 'Par escondido';

  @override
  String get techniqueNakedTriple => 'Trio nu';

  @override
  String get techniqueXWing => 'X-Wing';

  @override
  String get techniqueMistake => 'Erro';

  @override
  String get techniqueFromSolution => 'Da solução';

  @override
  String unitRow(int n) {
    return 'Linha $n';
  }

  @override
  String unitColumn(int n) {
    return 'Coluna $n';
  }

  @override
  String unitBox(int n) {
    return 'Quadrado $n';
  }

  @override
  String coachLook(String unit) {
    return 'Onde olhar: $unit.';
  }

  @override
  String coachLookMistake(String unit) {
    return 'Um dos teus números está errado. Onde olhar: $unit.';
  }

  @override
  String coachLookFallback(String unit) {
    return 'Nenhuma técnica do treinador resulta aqui. Onde olhar: $unit.';
  }

  @override
  String coachHiddenSingle(String unit, int digit) {
    return '$unit: o $digit só cabe numa célula.';
  }

  @override
  String coachNakedSingle(int digit) {
    return 'A célula destacada já vê todos os números menos o $digit na sua linha, coluna e quadrado, por isso tem de ser $digit.';
  }

  @override
  String coachPointingRow(String box, int digit) {
    return '$box: o $digit só cabe nas células destacadas, todas na mesma linha. Por isso, não pode ir para as células a vermelho dessa linha.';
  }

  @override
  String coachPointingColumn(String box, int digit) {
    return '$box: o $digit só cabe nas células destacadas, todas na mesma coluna. Por isso, não pode ir para as células a vermelho dessa coluna.';
  }

  @override
  String coachBoxLine(String line, int digit) {
    return '$line: o $digit só cabe nas células destacadas, todas no mesmo quadrado. Por isso, não pode ir para as células a vermelho desse quadrado.';
  }

  @override
  String coachNakedPair(String unit, int a, int b) {
    return '$unit: as duas células destacadas só podem levar $a ou $b. Por isso, as células a vermelho não os podem levar.';
  }

  @override
  String coachHiddenPair(String unit, int a, int b) {
    return '$unit: o $a e o $b só cabem nas duas células destacadas. Por isso, essas células não podem levar outro número.';
  }

  @override
  String coachNakedTriple(String unit, int a, int b, int c) {
    return '$unit: as três células destacadas só podem levar $a, $b ou $c. Por isso, as células a vermelho não os podem levar.';
  }

  @override
  String coachXWingRows(int digit) {
    return 'Em duas linhas, o $digit só cabe nas quatro células destacadas, que partilham duas colunas. Seja como for, cada uma dessas colunas tem o seu $digit ali, por isso ele não pode ir para as células a vermelho.';
  }

  @override
  String coachXWingColumns(int digit) {
    return 'Em duas colunas, o $digit só cabe nas quatro células destacadas, que partilham duas linhas. Seja como for, cada uma dessas linhas tem o seu $digit ali, por isso ele não pode ir para as células a vermelho.';
  }

  @override
  String coachMistake(int digit) {
    return 'O $digit destacado não pertence a esta célula.';
  }

  @override
  String get coachFallback =>
      'A célula destacada vai ser preenchida a partir da solução.';

  @override
  String coachDone(int digit) {
    return 'O $digit está no lugar.';
  }

  @override
  String coachCorrected(int digit) {
    return 'Corrigido: esta célula leva o $digit.';
  }

  @override
  String get coachShow => 'Mostrar';

  @override
  String coachApply(int seconds) {
    return 'Aplicar +${seconds}s';
  }

  @override
  String get continueGame => 'Continuar';

  @override
  String get newGameTitle => 'Começar um jogo novo?';

  @override
  String newGameMessage(int level) {
    return 'O jogo por terminar no nível $level será perdido.';
  }

  @override
  String get newGame => 'Jogo novo';

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
  String nextLevelInfo(String band, String technique) {
    return 'Próximo nível: $band · $technique';
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
  String get review => 'Revisão';

  @override
  String get reviewTitle => 'Revisão do jogo';

  @override
  String get reviewNeeded => 'O que este puzzle pedia';

  @override
  String get reviewNeededNote =>
      'Cada passo do treinador de lógica, um número de cada vez, contado pela sua técnica mais difícil.';

  @override
  String get reviewYourGame => 'As tuas ajudas e erros';

  @override
  String get reviewClean => 'Sem ajudas nem erros: uma resolução limpa!';

  @override
  String reviewHint(String time, String technique, int digit, String cell) {
    return '$time · Ajuda: $technique, o $digit em $cell.';
  }

  @override
  String reviewHintFix(String time, int digit, String cell) {
    return '$time · Ajuda: corrigido para $digit em $cell.';
  }

  @override
  String reviewMistake(String time, int digit, String cell) {
    return '$time · Erro: um $digit em $cell.';
  }

  @override
  String reviewAvailable(String technique, int digit, String cell) {
    return 'Disponível nesse momento: $technique, o $digit em $cell.';
  }

  @override
  String reviewAvailableFix(String cell) {
    return 'Disponível nesse momento: corrigir um erro anterior em $cell.';
  }

  @override
  String cellName(int row, int column) {
    return 'linha $row, coluna $column';
  }

  @override
  String get lessons => 'Lições';

  @override
  String get lessonsIntro =>
      'Lições curtas, uma por técnica: a app explica, tu fazes a jogada.';

  @override
  String get lessonDoneBadge => 'Feita';

  @override
  String lessonFromLevel(int level) {
    return 'A partir do nível $level';
  }

  @override
  String get lessonTry =>
      'Encontra a jogada: toca na célula e depois no número.';

  @override
  String get lessonWrong => 'Não é esta. Eis o raciocínio:';

  @override
  String get lessonNowYou => 'Agora faz a jogada.';

  @override
  String get lessonSuccess => 'Muito bem!';

  @override
  String get lessonFinish => 'Terminar';

  @override
  String lessonSuggestTitle(String technique) {
    return 'Técnica nova: $technique';
  }

  @override
  String lessonSuggestMessage(int level) {
    return 'O nível $level precisa dela. Uma lição curta mostra como funciona.';
  }

  @override
  String get lessonOpen => 'Lição';

  @override
  String get playNow => 'Jogar';

  @override
  String get lessonIntroHiddenSingle =>
      'Uma posição única é um número que só cabe numa célula de uma linha, coluna ou quadrado. Escolhe um quadrado e um número que lhe falte: se todas as outras células já veem esse número, ele vai para a única que sobra.';

  @override
  String get lessonIntroNakedSingle =>
      'Um candidato único é uma célula que só pode levar um número: a sua linha, coluna e quadrado já têm os outros oito.';

  @override
  String get lessonIntroPointingPair =>
      'Se, dentro de um quadrado, um número só pode ir para uma linha (ou coluna), tem de ir para essa linha ali. Por isso, não pode ir para mais nenhum sítio dessa linha.';

  @override
  String get lessonIntroBoxLine =>
      'Se, numa linha (ou coluna), um número só pode ir para dentro de um quadrado, tem de ir para ali nesse quadrado. Por isso, não pode ir para as outras células do quadrado.';

  @override
  String get lessonIntroNakedPair =>
      'Se duas células de uma linha, coluna ou quadrado só podem levar os mesmos dois números, esses números vão para essas duas células. Nenhuma outra célula dessa unidade os pode levar.';

  @override
  String get lessonIntroHiddenPair =>
      'Se dois números só cabem nas mesmas duas células de uma linha, coluna ou quadrado, essas células têm de os levar. Os outros candidatos dessas duas células saem.';

  @override
  String get lessonIntroNakedTriple =>
      'Se três células de uma unidade só podem levar três números entre elas, esses três números vão para essas células. O resto da unidade não os pode levar.';

  @override
  String get lessonIntroXWing =>
      'Se, em duas linhas, um número só cabe em duas células em cada uma, e essas células estão nas mesmas duas colunas, o número fica num canto de cada linha. Seja como for, essas colunas recebem-no ali, por isso não pode ir para mais nenhum sítio delas.';

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
  String get optMarkConflicts => 'Marcar conflitos';

  @override
  String get optMarkConflictsDesc =>
      'Contorna dois números iguais na mesma linha, coluna ou quadrado. Não usa a solução, por isso não revela nada.';

  @override
  String get cellEmpty => 'vazia';

  @override
  String get cellGiven => 'pista';

  @override
  String get cellHint => 'ajuda';

  @override
  String get cellWrong => 'errado';

  @override
  String get cellConflict => 'em conflito';

  @override
  String cellNotes(String notes) {
    return 'notas $notes';
  }

  @override
  String numberKey(int digit, int remaining) {
    return '$digit, faltam $remaining';
  }

  @override
  String get optHighContrast => 'Alto contraste';

  @override
  String get optHighContrastDesc =>
      'Linhas da grelha, notas e destaques mais fortes no tabuleiro. Liga-se também quando o sistema pede mais contraste.';

  @override
  String get optHints => 'Botão de ajuda';

  @override
  String optHintsDesc(int seconds) {
    return 'Mostra um botão para o treinador de lógica: explica o passo seguinte, e colocar o número custa +$seconds s.';
  }

  @override
  String get optLeftHanded => 'Canhoto';

  @override
  String get optLeftHandedDesc =>
      'Com o aparelho na horizontal, os números ficam à esquerda da grelha.';

  @override
  String get optFillNotes => 'Preencher notas nos níveis fáceis';

  @override
  String get optFillNotesDesc =>
      'No modo Notas, oferece também nos níveis 1–5 o preenchimento de todos os candidatos. Os níveis 6–9 oferecem-no sempre.';

  @override
  String get optHaptics => 'Vibração';

  @override
  String get optHapticsDesc =>
      'Um toque leve a cada número e um mais forte na vitória e nos erros (com Mostrar erros ligado).';

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
  String get bestTimes => 'Melhores tempos';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get statPlayed => 'Jogados';

  @override
  String get statSolved => 'Resolvidos';

  @override
  String get statBestTime => 'Melhor tempo';

  @override
  String get statAverageTime => 'Tempo médio';

  @override
  String get statNoHints => 'Sem ajudas';

  @override
  String get statNoMistakes => 'Sem erros';

  @override
  String get streakCurrent => 'Dias seguidos';

  @override
  String get streakBest => 'Melhor sequência';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '$count dia',
    );
    return '$_temp0';
  }

  @override
  String get streakNote => 'Um dia conta quando resolves pelo menos um puzzle.';

  @override
  String get clearStats => 'Repor estatísticas';

  @override
  String get clearStatsTitle => 'Repor as estatísticas?';

  @override
  String get clearStatsMessage =>
      'As estatísticas de todos os níveis e as sequências de dias serão apagadas. Esta ação não pode ser desfeita.';

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
      'Manter em mente os candidatos e as regras de linhas, colunas e quadrados exige memória de trabalho. Estudos com adultos mais velhos mostraram que o desempenho no Sudoku está relacionado com a capacidade da memória de trabalho. Estudos de imagiologia cerebral mostram que resolver Sudoku ativa as redes frontais e parietais que suportam a memória de trabalho e o controlo executivo.';

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
