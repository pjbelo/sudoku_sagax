import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../game/daily_puzzle.dart';
import '../game/sudoku_game.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/daily_service.dart';
import '../services/saved_game_service.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/fade_route.dart';
import '../widgets/level_selector.dart';
import 'game_screen.dart';

/// Today's puzzle (play, continue, or its time once solved), the daily
/// streak, and a month calendar with the days solved.
class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key, this.today});

  /// The date to treat as today; null for the real one, [dailyToday]
  /// (tests set it).
  final DateTime? today;

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  final _daily = DailyService.instance;
  late final DateTime _today = widget.today == null
      ? dailyToday()
      : _dateOf(widget.today!);

  /// The first day of the month the calendar shows.
  late DateTime _month = DateTime(_today.year, _today.month);

  static DateTime _dateOf(DateTime time) =>
      DateTime(time.year, time.month, time.day);

  void _click() => unawaited(
    AudioService.instance.playSfx(AudioService.buttonSfx, volume: 0.85),
  );

  /// The saved daily game, if it is today's puzzle (a game left from an
  /// earlier day can't be finished any more).
  SavedGame? _savedToday() {
    final saved = SavedGameService.daily.savedGame;
    if (saved == null) return null;
    final today = dailyPuzzle(_today);
    return listEquals(saved.game.puzzle.givens, today.givens) ? saved : null;
  }

  Future<void> _play() async {
    _click();
    final saved = _savedToday();
    AnalyticsService.instance.log('daily_opened', {
      'level': dailyLevel(_today),
      'resumed': saved != null ? 1 : 0,
    });
    await Navigator.push(
      context,
      fadeRoute<void>(GameScreen(dailyDay: _today, savedGame: saved)),
    );
    if (mounted) setState(() {}); // solved or saved now
  }

  void _showMonth(int step) {
    _click();
    setState(() => _month = DateTime(_month.year, _month.month + step));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final level = dailyLevel(_today);
    final solvedSeconds = _daily.secondsFor(_today);
    final maxWidth = 560 * uiScaleOf(context);

    final today = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.dailyIntro,
          style: GoogleFonts.inter(fontSize: 15, color: colors.muted),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.dailyToday(DateFormat.yMMMMEEEEd(locale).format(_today)),
          style: GoogleFonts.exo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${l10n.levelLabel} $level · ${levelSummary(l10n, level)}',
          style: GoogleFonts.inter(fontSize: 15, color: colors.muted),
        ),
        const SizedBox(height: 16),
        if (solvedSeconds != null)
          _SolvedBanner(text: l10n.dailySolved(formatTime(solvedSeconds)))
        else
          ElevatedButton(
            onPressed: _play,
            child: Text(
              _savedToday() == null ? l10n.dailyPlay : l10n.dailyContinue,
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _StreakTile(
                label: l10n.dailyStreak,
                value: l10n.streakDays(_daily.currentStreak(_today)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StreakTile(
                label: l10n.dailyBestStreak,
                value: l10n.streakDays(_daily.bestStreak),
              ),
            ),
          ],
        ),
      ],
    );

    final calendar = _MonthCalendar(
      month: _month,
      today: _today,
      isSolved: _daily.isSolved,
      locale: locale,
      // Back a year at most; never past the current month.
      onPrevious: _month.isAfter(DateTime(_today.year - 1, _today.month))
          ? () => _showMonth(-1)
          : null,
      onNext: _month.isBefore(DateTime(_today.year, _today.month))
          ? () => _showMonth(1)
          : null,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dailyTitle), centerTitle: true),
      body: SafeArea(
        child: TwoPaneLayout(
          first: CenteredPane(maxWidth: 480, padding: 20, child: today),
          second: CenteredPane(maxWidth: 480, padding: 20, child: calendar),
          single: LayoutBuilder(
            builder: (context, constraints) => ListView(
              padding: EdgeInsets.symmetric(
                horizontal: max(20, (constraints.maxWidth - maxWidth) / 2),
                vertical: 16,
              ),
              children: [today, const SizedBox(height: 24), calendar],
            ),
          ),
        ),
      ),
    );
  }
}

class _SolvedBanner extends StatelessWidget {
  const _SolvedBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: primary),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.exo2(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakTile extends StatelessWidget {
  const _StreakTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final primary = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: GoogleFonts.inter(fontSize: 13, color: colors.muted),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.exo2(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One month, Monday first, with the solved days filled in and today
/// outlined; arrows to the months before and after.
class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.month,
    required this.today,
    required this.isSolved,
    required this.locale,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final DateTime today;
  final bool Function(DateTime day) isSolved;
  final String locale;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final primary = Theme.of(context).primaryColor;
    final days = DateTime(month.year, month.month + 1, 0).day;
    // Empty cells before the 1st: Monday is 1, so a Monday 1st needs none.
    final blanks = DateTime(month.year, month.month).weekday - 1;
    // Weekday initials from a known Monday (5 January 2026).
    final weekdays = [
      for (int d = 0; d < 7; d++)
        DateFormat.E(locale).format(DateTime(2026, 1, 5 + d)),
    ];

    Widget arrow(IconData icon, VoidCallback? onPressed) => IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: primary,
      disabledColor: colors.muted.withValues(alpha: 0.3),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              arrow(Icons.chevron_left, onPrevious),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(locale).format(month),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.exo2(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: colors.text,
                  ),
                ),
              ),
              arrow(Icons.chevron_right, onNext),
            ],
          ),
          const SizedBox(height: 4),
          // The text is sized for the grid, so system text scaling stays out.
          MediaQuery.withNoTextScaling(
            child: GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final name in weekdays)
                  Center(
                    child: Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: colors.muted,
                      ),
                    ),
                  ),
                for (int i = 0; i < blanks; i++) const SizedBox(),
                for (int d = 1; d <= days; d++)
                  _dayCell(
                    colors,
                    DateTime(month.year, month.month, d),
                    primary,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayCell(AppColors colors, DateTime day, Color primary) {
    final solved = isSolved(day);
    final isToday = day == today;
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: solved ? primary : null,
          border: isToday ? Border.all(color: primary, width: 2) : null,
        ),
        child: Text(
          '${day.day}',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: solved || isToday ? FontWeight.bold : FontWeight.w400,
            color: solved
                ? colors.onPrimary
                : day.isAfter(today)
                ? colors.muted.withValues(alpha: 0.4)
                : colors.text,
          ),
        ),
      ),
    );
  }
}
