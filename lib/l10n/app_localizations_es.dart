// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Sudoku Sagax';

  @override
  String get bySagaxGames => 'by Sagax Games';

  @override
  String get sagaxGames => 'Sagax Games';

  @override
  String get tagline => 'Completa la cuadrícula, agudiza tu mente';

  @override
  String get selectLevel => 'Selecciona el nivel:';

  @override
  String levelSummary(String band, String technique) {
    return '$band · $technique';
  }

  @override
  String get bandBeginner => 'Principiante';

  @override
  String get bandEasy => 'Fácil';

  @override
  String get bandMedium => 'Medio';

  @override
  String get bandHard => 'Difícil';

  @override
  String get bandExpert => 'Experto';

  @override
  String get trainsSingles => 'únicos';

  @override
  String get trainsLockedCandidates => 'parejas apuntadoras';

  @override
  String get trainsPairs => 'parejas';

  @override
  String get trainsTriples => 'tríos';

  @override
  String get trainsXWing => 'X-Wing';

  @override
  String get play => 'JUGAR';

  @override
  String get info => 'Info';

  @override
  String get options => 'Opciones';

  @override
  String get scoreboard => 'Récords';

  @override
  String get daily => 'Diario';

  @override
  String get dailyTitle => 'Puzle diario';

  @override
  String get dailyIntro =>
      'Un puzle al día, el mismo para todos. Más fácil a principios de semana, más difícil el fin de semana.';

  @override
  String dailyToday(String date) {
    return 'Hoy · $date';
  }

  @override
  String get dailyPlay => 'Jugar el puzle de hoy';

  @override
  String get dailyContinue => 'Continuar el puzle de hoy';

  @override
  String dailySolved(String time) {
    return 'Resuelto hoy en $time';
  }

  @override
  String get dailyStreak => 'Racha diaria';

  @override
  String get dailyBestStreak => 'Mejor racha diaria';

  @override
  String get dailyComeBack => 'Vuelve mañana para un puzle nuevo.';

  @override
  String get levelLabel => 'Nivel';

  @override
  String get timeLabel => 'Tiempo';

  @override
  String get mistakesLabel => 'Errores';

  @override
  String get statusPlay => 'Elige una celda y un número, en cualquier orden';

  @override
  String get statusNotes => 'Notas: toca los números para marcar candidatos';

  @override
  String get statusNotesFill =>
      'Notas · toca aquí para rellenar todos los candidatos';

  @override
  String statusDigit(int digit) {
    return '$digit: toca las celdas donde va';
  }

  @override
  String statusDigitNotes(int digit) {
    return '$digit: toca celdas para marcarlo como candidato';
  }

  @override
  String get statusFullWrong =>
      'La cuadrícula está llena, pero algo no está bien';

  @override
  String get solved => '¡Resuelto!';

  @override
  String get paused => 'En pausa';

  @override
  String get resume => 'Continuar';

  @override
  String get pause => 'Pausa';

  @override
  String get undo => 'Deshacer';

  @override
  String get redo => 'Rehacer';

  @override
  String get erase => 'Borrar';

  @override
  String get notes => 'Notas';

  @override
  String hint(int seconds) {
    return 'Pista +${seconds}s';
  }

  @override
  String get techniqueHiddenSingle => 'Único oculto';

  @override
  String get techniqueNakedSingle => 'Único desnudo';

  @override
  String get techniquePointingPair => 'Pareja apuntadora';

  @override
  String get techniqueBoxLine => 'Reducción línea-caja';

  @override
  String get techniqueNakedPair => 'Pareja desnuda';

  @override
  String get techniqueHiddenPair => 'Pareja oculta';

  @override
  String get techniqueNakedTriple => 'Trío desnudo';

  @override
  String get techniqueXWing => 'X-Wing';

  @override
  String get techniqueMistake => 'Error';

  @override
  String get techniqueFromSolution => 'De la solución';

  @override
  String unitRow(int n) {
    return 'Fila $n';
  }

  @override
  String unitColumn(int n) {
    return 'Columna $n';
  }

  @override
  String unitBox(int n) {
    return 'Caja $n';
  }

  @override
  String coachLook(String unit) {
    return 'Dónde mirar: $unit.';
  }

  @override
  String coachLookMistake(String unit) {
    return 'Uno de tus números está mal. Dónde mirar: $unit.';
  }

  @override
  String coachLookFallback(String unit) {
    return 'Ninguna técnica del entrenador sirve aquí. Dónde mirar: $unit.';
  }

  @override
  String coachHiddenSingle(String unit, int digit) {
    return '$unit: el $digit solo cabe en una celda.';
  }

  @override
  String coachNakedSingle(int digit) {
    return 'La celda resaltada ya ve todos los números menos el $digit en su fila, columna y caja, así que tiene que ser $digit.';
  }

  @override
  String coachPointingRow(String box, int digit) {
    return '$box: el $digit solo cabe en las celdas resaltadas, todas en la misma fila. Así que no puede ir en las celdas en rojo de esa fila.';
  }

  @override
  String coachPointingColumn(String box, int digit) {
    return '$box: el $digit solo cabe en las celdas resaltadas, todas en la misma columna. Así que no puede ir en las celdas en rojo de esa columna.';
  }

  @override
  String coachBoxLine(String line, int digit) {
    return '$line: el $digit solo cabe en las celdas resaltadas, todas en la misma caja. Así que no puede ir en las celdas en rojo de esa caja.';
  }

  @override
  String coachNakedPair(String unit, int a, int b) {
    return '$unit: las dos celdas resaltadas solo pueden llevar $a o $b. Así que las celdas en rojo no pueden llevarlos.';
  }

  @override
  String coachHiddenPair(String unit, int a, int b) {
    return '$unit: el $a y el $b solo caben en las dos celdas resaltadas. Así que esas celdas no pueden llevar otro número.';
  }

  @override
  String coachNakedTriple(String unit, int a, int b, int c) {
    return '$unit: las tres celdas resaltadas solo pueden llevar $a, $b o $c. Así que las celdas en rojo no pueden llevarlos.';
  }

  @override
  String coachXWingRows(int digit) {
    return 'En dos filas, el $digit solo cabe en las cuatro celdas resaltadas, que comparten dos columnas. Sea como sea, cada una de esas columnas tiene ahí su $digit, así que no puede ir en las celdas en rojo.';
  }

  @override
  String coachXWingColumns(int digit) {
    return 'En dos columnas, el $digit solo cabe en las cuatro celdas resaltadas, que comparten dos filas. Sea como sea, cada una de esas filas tiene ahí su $digit, así que no puede ir en las celdas en rojo.';
  }

  @override
  String coachMistake(int digit) {
    return 'El $digit resaltado no va en esta celda.';
  }

  @override
  String get coachFallback =>
      'La celda resaltada se rellenará con la solución.';

  @override
  String coachDone(int digit) {
    return 'El $digit está en su sitio.';
  }

  @override
  String coachCorrected(int digit) {
    return 'Corregido: esta celda lleva el $digit.';
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
  String get newGameTitle => '¿Empezar una partida nueva?';

  @override
  String newGameMessage(int level) {
    return 'La partida sin terminar del nivel $level se perderá.';
  }

  @override
  String get newGame => 'Partida nueva';

  @override
  String get congratulations => '¡Enhorabuena!';

  @override
  String levelCompleted(int level, String time) {
    return '¡Resolviste el nivel $level en $time!';
  }

  @override
  String hintsAndMistakes(int hints, int mistakes) {
    return 'Pistas: $hints · Errores: $mistakes';
  }

  @override
  String get newBestTime => '🏆 ¡Nuevo récord en este nivel!';

  @override
  String rankOnScoreboard(int rank, int level) {
    return '#$rank en los récords del nivel $level';
  }

  @override
  String nextLevelInfo(String band, String technique) {
    return 'Siguiente nivel: $band · $technique';
  }

  @override
  String get allLevelsComplete => '¡Has conquistado el nivel más difícil!';

  @override
  String get nextLevel => 'Siguiente Nivel';

  @override
  String get sameLevel => 'Mismo Nivel';

  @override
  String get playAgain => 'Jugar de Nuevo';

  @override
  String get backToMenu => 'Volver al Menú';

  @override
  String get okButton => 'OK';

  @override
  String get review => 'Revisión';

  @override
  String get reviewTitle => 'Revisión de la partida';

  @override
  String get reviewNeeded => 'Lo que pedía este puzle';

  @override
  String get reviewNeededNote =>
      'Cada paso del entrenador de lógica, un número cada vez, contado por su técnica más difícil.';

  @override
  String get reviewYourGame => 'Tus pistas y errores';

  @override
  String get reviewClean => 'Sin pistas ni errores: ¡una resolución limpia!';

  @override
  String reviewHint(String time, String technique, int digit, String cell) {
    return '$time · Pista: $technique, el $digit en $cell.';
  }

  @override
  String reviewHintFix(String time, int digit, String cell) {
    return '$time · Pista: corregido a $digit en $cell.';
  }

  @override
  String reviewMistake(String time, int digit, String cell) {
    return '$time · Error: un $digit en $cell.';
  }

  @override
  String reviewAvailable(String technique, int digit, String cell) {
    return 'Disponible entonces: $technique, el $digit en $cell.';
  }

  @override
  String reviewAvailableFix(String cell) {
    return 'Disponible entonces: corregir un error anterior en $cell.';
  }

  @override
  String cellName(int row, int column) {
    return 'fila $row, columna $column';
  }

  @override
  String get lessons => 'Lecciones';

  @override
  String get lessonsIntro =>
      'Lecciones cortas, una por técnica: la app explica, tú haces la jugada.';

  @override
  String get lessonDoneBadge => 'Hecha';

  @override
  String lessonFromLevel(int level) {
    return 'Desde el nivel $level';
  }

  @override
  String get lessonTry =>
      'Encuentra la jugada: toca la celda y luego su número.';

  @override
  String get lessonWrong => 'No es esta. Este es el razonamiento:';

  @override
  String get lessonNowYou => 'Ahora haz la jugada.';

  @override
  String get lessonSuccess => '¡Muy bien!';

  @override
  String get lessonFinish => 'Terminar';

  @override
  String lessonSuggestTitle(String technique) {
    return 'Técnica nueva: $technique';
  }

  @override
  String lessonSuggestMessage(int level) {
    return 'El nivel $level la necesita. Una lección corta muestra cómo funciona.';
  }

  @override
  String get lessonOpen => 'Lección';

  @override
  String get playNow => 'Jugar';

  @override
  String get lessonIntroHiddenSingle =>
      'Un único oculto es un número que solo cabe en una celda de una fila, columna o caja. Elige una caja y un número que le falte: si todas las demás celdas ya ven ese número, va en la única que queda.';

  @override
  String get lessonIntroNakedSingle =>
      'Un único desnudo es una celda que solo puede llevar un número: su fila, columna y caja ya tienen los otros ocho.';

  @override
  String get lessonIntroPointingPair =>
      'Si, dentro de una caja, un número solo puede ir en una fila (o columna), tiene que ir en esa fila ahí. Así que no puede ir en ningún otro sitio de esa fila.';

  @override
  String get lessonIntroBoxLine =>
      'Si, en una fila (o columna), un número solo puede ir dentro de una caja, tiene que ir ahí en esa caja. Así que no puede ir en las demás celdas de la caja.';

  @override
  String get lessonIntroNakedPair =>
      'Si dos celdas de una fila, columna o caja solo pueden llevar los mismos dos números, esos números van en esas dos celdas. Ninguna otra celda de esa unidad puede llevarlos.';

  @override
  String get lessonIntroHiddenPair =>
      'Si dos números solo caben en las mismas dos celdas de una fila, columna o caja, esas celdas tienen que llevarlos. Los demás candidatos de esas dos celdas sobran.';

  @override
  String get lessonIntroNakedTriple =>
      'Si tres celdas de una unidad solo pueden llevar tres números entre ellas, esos tres números van en esas celdas. El resto de la unidad no puede llevarlos.';

  @override
  String get lessonIntroXWing =>
      'Si, en dos filas, un número solo cabe en dos celdas en cada una, y esas celdas están en las mismas dos columnas, el número ocupa una esquina en cada fila. Sea como sea, esas columnas lo reciben ahí, así que no puede ir en ningún otro sitio de ellas.';

  @override
  String get optionsTitle => 'Opciones';

  @override
  String get optSound => 'Sonido';

  @override
  String get optSoundDesc => 'Música y efectos de sonido.';

  @override
  String get optTimer => 'Cronómetro';

  @override
  String get optTimerDesc =>
      'Muestra el reloj mientras juegas. Tu tiempo siempre se registra en los récords.';

  @override
  String get optShowErrors => 'Mostrar errores';

  @override
  String get optShowErrorsDesc =>
      'Marca en rojo un número incorrecto en cuanto lo introduces.';

  @override
  String get optMarkConflicts => 'Marcar conflictos';

  @override
  String get optMarkConflictsDesc =>
      'Rodea dos números iguales en la misma fila, columna o caja. No usa la solución, así que no revela nada.';

  @override
  String get cellEmpty => 'vacía';

  @override
  String get cellGiven => 'fija';

  @override
  String get cellHint => 'pista';

  @override
  String get cellWrong => 'errónea';

  @override
  String get cellConflict => 'en conflicto';

  @override
  String cellNotes(String notes) {
    return 'notas $notes';
  }

  @override
  String numberKey(int digit, int remaining) {
    return '$digit, faltan $remaining';
  }

  @override
  String get optHighContrast => 'Alto contraste';

  @override
  String get optHighContrastDesc =>
      'Líneas de la cuadrícula, notas y resaltados más marcados en el tablero. También se activa cuando el sistema pide más contraste.';

  @override
  String get optHints => 'Botón de pista';

  @override
  String optHintsDesc(int seconds) {
    return 'Muestra un botón para el entrenador de lógica: explica el siguiente paso, y colocar el número cuesta +$seconds s.';
  }

  @override
  String get optLeftHanded => 'Zurdo';

  @override
  String get optLeftHandedDesc =>
      'Con el dispositivo en horizontal, los números quedan a la izquierda de la cuadrícula.';

  @override
  String get optFillNotes => 'Rellenar notas en niveles fáciles';

  @override
  String get optFillNotesDesc =>
      'En el modo Notas, ofrece también en los niveles 1–5 rellenar todos los candidatos. Los niveles 6–9 siempre lo ofrecen.';

  @override
  String get optHaptics => 'Vibración';

  @override
  String get optHapticsDesc =>
      'Un toque suave en cada número y uno más fuerte al ganar y en los errores (con Mostrar errores activado).';

  @override
  String get restoreDefaults => 'Restablecer valores predeterminados';

  @override
  String get scoreboardTitle => 'Récords';

  @override
  String get noScores => 'Aún no has resuelto ningún puzle en este nivel.';

  @override
  String get clearScores => 'Borrar récords';

  @override
  String get clearScoresTitle => '¿Borrar los récords?';

  @override
  String get clearScoresMessage =>
      'Se eliminarán todos los récords de todos los niveles. Esta acción no se puede deshacer.';

  @override
  String get leaderboards => 'Clasificaciones';

  @override
  String get achievements => 'Logros';

  @override
  String get bestTimes => 'Mejores tiempos';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get statPlayed => 'Jugadas';

  @override
  String get statSolved => 'Resueltas';

  @override
  String get statBestTime => 'Mejor tiempo';

  @override
  String get statAverageTime => 'Tiempo medio';

  @override
  String get statNoHints => 'Sin pistas';

  @override
  String get statNoMistakes => 'Sin errores';

  @override
  String get streakCurrent => 'Racha de días';

  @override
  String get streakBest => 'Mejor racha';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '$count día',
    );
    return '$_temp0';
  }

  @override
  String get streakNote => 'Un día cuenta cuando resuelves al menos un puzle.';

  @override
  String get clearStats => 'Restablecer estadísticas';

  @override
  String get clearStatsTitle => '¿Restablecer las estadísticas?';

  @override
  String get clearStatsMessage =>
      'Se eliminarán las estadísticas de todos los niveles y las rachas de días. Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Borrar';

  @override
  String get infoScreenTitle => 'Info';

  @override
  String get howToPlayTitle => 'Cómo jugar';

  @override
  String get howToPlayText =>
      'Rellena todas las celdas vacías de modo que cada fila, cada columna y cada caja de 3×3 contenga los dígitos del 1 al 9 una sola vez. Cada puzle tiene una única solución y se resuelve solo con lógica, sin adivinar. Usa las Notas para anotar los candidatos de una celda.';

  @override
  String get sudokuBenefitsTitle =>
      '¿Por qué el Sudoku es bueno para el cerebro?';

  @override
  String get sudokuBenefitsIntro =>
      'El Sudoku es un puzle de lógica pura: no hay cálculos, solo deducción. La investigación sobre puzles numéricos y Sudoku apunta a estos beneficios:';

  @override
  String get benefit1Title => '🔢 Razonamiento Lógico y Deductivo';

  @override
  String get benefit1Desc =>
      'Cada jugada es una deducción: \"esta celda solo puede ser un 7\" o \"el 3 solo puede ir aquí\". Los programas de entrenamiento basados en Sudoku trabajan la atención y el razonamiento lógico-deductivo, y un ensayo aleatorizado con personas mayores con deterioro cognitivo leve registró mejoras en la cognición global tras entrenar con Sudoku.';

  @override
  String get benefit2Title => '🧠 Memoria de Trabajo';

  @override
  String get benefit2Desc =>
      'Tener presentes los candidatos y las reglas de filas, columnas y cajas exige memoria de trabajo. Estudios con adultos mayores mostraron que el rendimiento en Sudoku está relacionado con la capacidad de la memoria de trabajo. Estudios de neuroimagen muestran que resolver un Sudoku activa las redes frontales y parietales que sostienen la memoria de trabajo y el control ejecutivo.';

  @override
  String get benefit3Title => '🎯 Atención y Concentración';

  @override
  String get benefit3Desc =>
      'En un estudio con más de 19 000 adultos de 50 años o más, quienes hacían puzles numéricos con más frecuencia obtuvieron mejores resultados en pruebas de atención, razonamiento y memoria.';

  @override
  String get benefit4Title =>
      '⚡ Velocidad de Procesamiento y Funciones Ejecutivas';

  @override
  String get benefit4Desc =>
      'La misma investigación relacionó la práctica regular de puzles numéricos con un procesamiento de la información más rápido y mejores funciones ejecutivas: planificar, comprobar y cambiar de estrategia.';

  @override
  String get benefit5Title =>
      '🛡️ Reserva Cognitiva y Envejecimiento Saludable';

  @override
  String get benefit5Desc =>
      'Estudios a largo plazo asocian los juegos y puzles mentalmente estimulantes con una mejor función cognitiva en etapas posteriores de la vida y un declive cognitivo más lento, en línea con la construcción de reserva cognitiva. Nunca es tarde: quienes empezaron a hacer puzles más tarde también mostraron beneficios.';

  @override
  String get benefit6Title => '😌 Concentración, Flow y Bienestar';

  @override
  String get benefit6Desc =>
      'Un puzle ajustado a tu nivel invita al \"flow\" —la absorción total en la tarea—, asociado al disfrute y a la reducción del estrés. Nueve niveles de dificultad te permiten mantener el reto en su punto justo.';

  @override
  String get evidenceNote =>
      'Una nota sobre la evidencia: la mayoría de estos estudios son observacionales, por lo que muestran asociaciones y no pruebas de causa. El Sudoku funciona mejor como parte de un estilo de vida activo que incluya también ejercicio, descanso y vida social.';

  @override
  String get scientificReferences => 'Referencias Científicas';

  @override
  String get developedBy =>
      'Desarrollado por Tekinsight - Information Technologies';

  @override
  String get credits => 'Créditos';

  @override
  String get music => 'Música';

  @override
  String get sounds => 'Sonidos';

  @override
  String get license => 'Licencia';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Volver';
}
