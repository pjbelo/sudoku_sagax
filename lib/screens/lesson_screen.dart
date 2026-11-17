import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/lessons.dart';
import '../game/logic_coach.dart';
import '../game/sudoku_game.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/lesson_service.dart';
import '../services/settings_service.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/coach_card.dart';
import '../widgets/number_pad.dart';
import '../widgets/sudoku_board.dart';

/// What a technique is, in a few sentences: the start of its lesson.
String lessonIntro(AppLocalizations l10n, CoachTechnique technique) =>
    switch (technique) {
      CoachTechnique.hiddenSingle => l10n.lessonIntroHiddenSingle,
      CoachTechnique.nakedSingle => l10n.lessonIntroNakedSingle,
      CoachTechnique.pointingPair => l10n.lessonIntroPointingPair,
      CoachTechnique.boxLineReduction => l10n.lessonIntroBoxLine,
      CoachTechnique.nakedPair => l10n.lessonIntroNakedPair,
      CoachTechnique.hiddenPair => l10n.lessonIntroHiddenPair,
      CoachTechnique.nakedTriple => l10n.lessonIntroNakedTriple,
      CoachTechnique.xWing => l10n.lessonIntroXWing,
      _ => '',
    };

/// Where the lesson has got to: the player looks for the move, then (after
/// Show me or a wrong move) sees the reasoning, then has made the move.
enum _Stage { find, explained, done }

/// One guided lesson: the app explains a technique on a prepared board,
/// and the player makes the move.
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.technique});

  final CoachTechnique technique;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final _audio = AudioService.instance;
  late final Lesson _lesson = lessonFor(widget.technique);
  late final SudokuGame _game = _newGame();

  _Stage _stage = _Stage.find;

  /// A wrong move was tried: the reasoning opens with a word about it.
  bool _missed = false;
  int? _selected;

  CoachStep get _step => _lesson.step;

  SudokuGame _newGame() {
    final game = SudokuGame(_lesson.puzzle);
    if (_lesson.showsCandidates) game.fillNotes();
    return game;
  }

  void _onCellTap(int i) {
    if (_stage == _Stage.done) return;
    setState(() => _selected = i);
  }

  void _onDigit(int digit) {
    final i = _selected;
    if (_stage == _Stage.done || i == null) return;
    if (i == _step.cell && digit == _step.digit) {
      // The move: rule out the step's candidates, then place the digit.
      _step.removals.forEach((cell, mask) => _game.notes[cell] &= ~mask);
      _game.enterDigit(i, digit);
      unawaited(_audio.playSfx(AudioService.winSfx, volume: 0.7));
      unawaited(LessonService.instance.markDone(widget.technique));
      AnalyticsService.instance.log('lesson_done', {
        'technique': widget.technique.name,
        'missed': _missed ? 1 : 0,
      });
      setState(() => _stage = _Stage.done);
    } else {
      unawaited(_audio.playSfx(AudioService.wrongSfx, volume: 0.6));
      setState(() {
        _missed = true;
        _stage = _Stage.explained;
      });
    }
  }

  void _showMe() {
    unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.7));
    setState(() => _stage = _Stage.explained);
  }

  void _finish() {
    unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.85));
    Navigator.pop(context);
  }

  BoardHighlight _highlight() {
    // The selected cell, if any (`?` leaves it out when it is null).
    final selected = <int>{?_selected};
    return switch (_stage) {
      _Stage.find => BoardHighlight(
        area: _step.lookAt.cells.toSet(),
        focus: selected,
      ),
      _Stage.explained => BoardHighlight(
        area: _step.areaCells,
        focus: {..._step.focusCells, ...selected},
        removed: _step.removedCells,
        candidates: _step.candidatesToShow,
      ),
      _Stage.done => BoardHighlight(focus: {_step.cell}),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(techniqueName(l10n, widget.technique)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: TwoPaneLayout(
          first: LayoutBuilder(
            builder: (context, constraints) => Center(
              child: SizedBox.square(
                dimension: constraints.biggest.shortestSide - 24,
                child: _buildBoard(),
              ),
            ),
          ),
          second: Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 16, 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Three rows of keys in the height the text leaves.
                final keyHeight = ((constraints.maxHeight - 170) / 3 - 8).clamp(
                  36.0,
                  64.0,
                );
                return Column(
                  children: [
                    Expanded(child: _buildText(l10n)),
                    const SizedBox(height: 12),
                    _buildPad(height: keyHeight, grid: true),
                  ],
                );
              },
            ),
          ),
          single: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final board = (width - 24).clamp(
                0.0,
                constraints.maxHeight * 0.55,
              );
              final keyHeight = (width / 9 * 0.95).clamp(44.0, 70.0);
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: _buildText(l10n),
                    ),
                  ),
                  SizedBox.square(dimension: board, child: _buildBoard()),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildPad(height: keyHeight),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return SudokuBoard(
      game: _game,
      selected: null,
      showErrors: false,
      highContrast: SettingsService.instance.highContrast,
      highlight: _highlight(),
      onCellTap: _onCellTap,
    );
  }

  Widget _buildPad({required double height, bool grid = false}) {
    return NumberPad(
      game: _game,
      notesMode: false,
      highContrast: SettingsService.instance.highContrast,
      onDigit: _onDigit,
      height: height,
      grid: grid,
    );
  }

  /// What the technique is, then the stage's text and its button.
  Widget _buildText(AppLocalizations l10n) {
    final String text;
    switch (_stage) {
      case _Stage.find:
        text = '${coachLookText(l10n, _step)} ${l10n.lessonTry}';
      case _Stage.explained:
        final reasoning = coachExplanation(l10n, _step);
        text = _missed
            ? '${l10n.lessonWrong} $reasoning ${l10n.lessonNowYou}'
            : '$reasoning ${l10n.lessonNowYou}';
      case _Stage.done:
        text = '${l10n.lessonSuccess} ${coachDoneText(l10n, _step)}';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.hintAmber.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lessonIntro(l10n, widget.technique),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.35,
                      color: AppColors.softSlate,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                      color: _stage == _Stage.done
                          ? AppColors.hintAmber
                          : AppColors.snowWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_stage != _Stage.explained)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: _stage == _Stage.find
                    ? OutlinedButton(
                        onPressed: _showMe,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.hintAmber,
                          side: BorderSide(
                            color: AppColors.hintAmber.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(l10n.coachShow),
                      )
                    : ElevatedButton(
                        onPressed: _finish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.hintAmber,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          textStyle: GoogleFonts.exo2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text(l10n.lessonFinish),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
