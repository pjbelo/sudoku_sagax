import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/lessons.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/lesson_service.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/coach_card.dart';
import '../widgets/fade_route.dart';
import 'lesson_screen.dart';

/// The list of lessons, one per technique, with the finished ones ticked.
class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  Future<void> _open(int index) async {
    final technique = lessonTechniques[index];
    unawaited(
      AudioService.instance.playSfx(AudioService.buttonSfx, volume: 0.85),
    );
    AnalyticsService.instance.log('lesson_opened', {
      'technique': technique.name,
    });
    await Navigator.push(
      context,
      fadeRoute<void>(LessonScreen(technique: technique)),
    );
    if (mounted) setState(() {}); // a lesson may now be done
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final lessons = LessonService.instance;
    final maxWidth = 560 * uiScaleOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.lessons), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            padding: EdgeInsets.symmetric(
              horizontal: max(24, (constraints.maxWidth - maxWidth) / 2),
              vertical: 16,
            ),
            children: [
              Text(
                l10n.lessonsIntro,
                style: GoogleFonts.inter(fontSize: 15, color: colors.muted),
              ),
              const SizedBox(height: 16),
              for (final (index, technique) in lessonTechniques.indexed)
                _LessonRow(
                  name: techniqueName(l10n, technique),
                  level: l10n.lessonFromLevel(lessonLevel[technique]!),
                  done: lessons.isDone(technique),
                  doneLabel: l10n.lessonDoneBadge,
                  onTap: () => _open(index),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  const _LessonRow({
    required this.name,
    required this.level,
    required this.done,
    required this.doneLabel,
    required this.onTap,
  });

  final String name;
  final String level;
  final bool done;
  final String doneLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final primary = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary.withValues(alpha: done ? 0.6 : 0.25)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                done ? Icons.check_circle : Icons.school_outlined,
                color: done ? primary : colors.muted,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.exo2(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      done ? '$level · $doneLabel' : level,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
