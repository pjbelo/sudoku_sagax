import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/puzzle_code.dart';
import '../game/sudoku_generator.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/saved_game_service.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/fade_route.dart';
import '../widgets/level_selector.dart';
import 'game_screen.dart';

/// Opens a puzzle a friend shared: the player pastes the whole message, or
/// types the code, and plays the same grid.
class PuzzleCodeScreen extends StatefulWidget {
  const PuzzleCodeScreen({super.key});

  @override
  State<PuzzleCodeScreen> createState() => _PuzzleCodeScreenState();
}

class _PuzzleCodeScreenState extends State<PuzzleCodeScreen> {
  final _controller = TextEditingController();

  /// The puzzle in the text field, or null while there is no valid code.
  SudokuPuzzle? _puzzle;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    setState(() => _puzzle = puzzleFromText(text));
  }

  Future<void> _play() async {
    final puzzle = _puzzle;
    if (puzzle == null) return;
    final audio = AudioService.instance;
    unawaited(audio.playSfx(AudioService.buttonSfx, volume: 0.85));

    // The shared puzzle takes the place of the saved game, as Play does.
    final saved = SavedGameService.instance.savedGame;
    if (saved != null) {
      final l10n = AppLocalizations.of(context)!;
      final replace = await showConfirmDialog(
        context,
        title: l10n.newGameTitle,
        message: l10n.newGameMessage(saved.level),
        confirmLabel: l10n.newGame,
        cancelLabel: l10n.cancel,
        destructive: true,
      );
      if (!replace || !mounted) return;
    }

    AnalyticsService.instance.log('shared_puzzle_opened', {
      'level': puzzle.level,
      'clues': puzzle.clueCount,
    });
    await Navigator.push(
      context,
      fadeRoute<void>(GameScreen(sharedPuzzle: puzzle)),
    );
    // Back from the game: straight back home, where Continue shows a game
    // left unfinished.
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).primaryColor;
    final puzzle = _puzzle;
    final hasText = _controller.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.puzzleCodeTitle), centerTitle: true),
      body: SafeArea(
        child: CenteredPane(
          maxWidth: 480 * uiScaleOf(context),
          padding: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.puzzleCodeIntro,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.softSlate,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                onChanged: _onChanged,
                minLines: 3,
                maxLines: 6,
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.characters,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.snowWhite,
                ),
                decoration: InputDecoration(
                  hintText: l10n.puzzleCodeHint,
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.softSlate.withValues(alpha: 0.7),
                  ),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: primary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // What the code holds, or a nudge while it isn't valid yet.
              if (puzzle != null)
                Row(
                  children: [
                    Icon(Icons.check_circle, color: primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.puzzleCodeFound(
                          puzzle.level,
                          levelSummary(l10n, puzzle.level),
                        ),
                        style: GoogleFonts.exo2(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ),
                  ],
                )
              else if (hasText)
                Text(
                  l10n.puzzleCodeInvalid,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.softSlate,
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: puzzle == null ? null : _play,
                child: Text(l10n.puzzleCodePlay, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.puzzleCodeNote,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.softSlate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
