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
  String levelSummary(String band, int clues) {
    return '$band · $clues pistas';
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
  String get play => 'JUGAR';

  @override
  String get info => 'Info';

  @override
  String get options => 'Opciones';

  @override
  String get scoreboard => 'Récords';

  @override
  String get levelLabel => 'Nivel';

  @override
  String get timeLabel => 'Tiempo';

  @override
  String get mistakesLabel => 'Errores';

  @override
  String get statusPlay => 'Elige una celda y luego un número';

  @override
  String get statusNotes => 'Notas: toca los números para marcar candidatos';

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
  String get erase => 'Borrar';

  @override
  String get notes => 'Notas';

  @override
  String hint(int seconds) {
    return 'Pista +${seconds}s';
  }

  @override
  String get leaveGameTitle => '¿Salir de esta partida?';

  @override
  String get leaveGameMessage => 'Se perderá tu progreso en este puzle.';

  @override
  String get leave => 'Salir';

  @override
  String get stay => 'Seguir jugando';

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
  String nextLevelInfo(String band, int clues) {
    return 'Siguiente nivel: $band · $clues pistas';
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
  String get optHints => 'Botón de pista';

  @override
  String optHintsDesc(int seconds) {
    return 'Muestra un botón que rellena un número correcto (+$seconds s).';
  }

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
