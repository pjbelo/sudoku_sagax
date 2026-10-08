import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/audio_service.dart';

/// How to play, "Brain Benefits" backed by the references below, and
/// credits. See docs/research.md for the full literature notes.
class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  static const _references = [
    (
      authors: 'Brooker, H., Wesnes, K. A., Ballard, C., Hampshire, A., Aarsland, D., Khan, Z., Stenton, R., Megalogeni, M., & Corbett, A. (2019)',
      title: 'The relationship between the frequency of number-puzzle use and baseline cognitive function in a large online sample of adults aged 50 and over',
      journal: 'International Journal of Geriatric Psychiatry, 34(7), 932-940',
    ),
    (
      authors: 'Grabbe, J. W. (2011)',
      title: 'Sudoku and Working Memory Performance for Older Adults',
      journal: 'Activities, Adaptation & Aging, 35(3), 241-254',
    ),
    (
      authors: 'Litwin, H., Schwartz, E., & Damri, N. (2017)',
      title: 'Cognitively Stimulating Leisure Activity and Subsequent Cognitive Function: A SHARE-based Analysis',
      journal: 'The Gerontologist, 57(5), 940-948',
    ),
    (
      authors: 'Ferreira, N., Owen, A., Mohan, A., Corbett, A., & Ballard, C. (2015)',
      title: 'Associations between cognitively stimulating leisure activities, cognitive function and age-related cognitive decline',
      journal: 'International Journal of Geriatric Psychiatry, 30(4), 422-430',
    ),
    (
      authors: 'Yu, D., Li, P., Two, W., & Waye, M. (2023)',
      title: 'Effects of Gamified Cognitive Training to Deter the Progression of Mild Cognitive Impairment (Sudoku SMART trial)',
      journal: 'Innovation in Aging, 7(Suppl. 1), 645 — conference abstract; ClinicalTrials.gov NCT04913857',
    ),
    (
      authors: 'Altschul, D. M., & Deary, I. J. (2020)',
      title: 'Playing Analog Games Is Associated With Reduced Declines in Cognitive Function: A 68-Year Longitudinal Cohort Study',
      journal: 'The Journals of Gerontology: Series B, 75(3), 474-482',
    ),
    (
      authors: 'Verghese, J., Lipton, R. B., Katz, M. J., et al. (2003)',
      title: 'Leisure Activities and the Risk of Dementia in the Elderly',
      journal: 'New England Journal of Medicine, 348(25), 2508-2516',
    ),
    (
      authors: 'Stern, Y. (2012)',
      title: 'Cognitive reserve in ageing and Alzheimer\'s disease',
      journal: 'The Lancet Neurology, 11(11), 1006-1012',
    ),
    (
      authors: 'Nakamura, J., & Csikszentmihalyi, M. (2014)',
      title: 'The Concept of Flow',
      journal:
          'Flow and the Foundations of Positive Psychology, Springer, 239-263',
    ),
  ];

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  void _playClick() => unawaited(
    AudioService.instance.playSfx(AudioService.buttonSfx, volume: 0.85),
  );

  void _onBackPressed() {
    _playClick();
    Navigator.pop(context);
  }

  void _showCredits(BuildContext context) {
    const primary = AppColors.electricCyan;
    final l10n = AppLocalizations.of(context)!;

    Widget heading(String text) => Text(
      text,
      style: GoogleFonts.exo2(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
    );
    Widget detail(String text) => Text(
      text,
      style: GoogleFonts.inter(fontSize: 13, color: AppColors.softSlate),
    );

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            l10n.credits,
            style: GoogleFonts.exo2(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.snowWhite,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading(l10n.music),
            const SizedBox(height: 4),
            detail('Solar Sail by Vitalezzz (OpenGameArt.org)'),
            const SizedBox(height: 12),
            heading(l10n.sounds),
            const SizedBox(height: 4),
            detail('Digital Audio by Kenney Vleugels (Kenney.nl)'),
            const SizedBox(height: 12),
            heading(l10n.license),
            const SizedBox(height: 4),
            detail('Creative Commons CC0 1.0'),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              _playClick();
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.electricCyan;
    final l10n = AppLocalizations.of(context)!;

    final benefits = [
      (title: l10n.benefit1Title, desc: l10n.benefit1Desc),
      (title: l10n.benefit2Title, desc: l10n.benefit2Desc),
      (title: l10n.benefit3Title, desc: l10n.benefit3Desc),
      (title: l10n.benefit4Title, desc: l10n.benefit4Desc),
      (title: l10n.benefit5Title, desc: l10n.benefit5Desc),
      (title: l10n.benefit6Title, desc: l10n.benefit6Desc),
    ];

    final title = Text(
      l10n.infoScreenTitle,
      style: GoogleFonts.exo2(
        color: AppColors.snowWhite,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );

    TextStyle sectionStyle() => GoogleFonts.exo2(
      color: AppColors.snowWhite,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    );

    final body = SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.howToPlayTitle, style: sectionStyle()),
                const SizedBox(height: 16),
                _InfoCard(
                  title: '🧩 Sudoku',
                  description: l10n.howToPlayText,
                  titleColor: primary,
                ),
                const SizedBox(height: 14),
                Text(l10n.sudokuBenefitsTitle, style: sectionStyle()),
                const SizedBox(height: 20),
                Text(
                  l10n.sudokuBenefitsIntro,
                  style: GoogleFonts.inter(
                    color: AppColors.snowWhite,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                for (final b in benefits)
                  _InfoCard(
                    title: b.title,
                    description: b.desc,
                    titleColor: primary,
                  ),
                _InfoCard(
                  title: 'ℹ️',
                  description: l10n.evidenceNote,
                  titleColor: AppColors.hintAmber,
                ),
                const SizedBox(height: 30),
                Text(l10n.scientificReferences, style: sectionStyle()),
                const SizedBox(height: 20),
                for (final r in InfoScreen._references)
                  _ReferenceCard(
                    authors: r.authors,
                    title: r.title,
                    journal: r.journal,
                  ),
                const SizedBox(height: 30),
                Center(
                  child: Image.asset(
                    'assets/images/sagax-games-logo.png',
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    l10n.developedBy,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.softSlate,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _playClick();
                      _showCredits(context);
                    },
                    child: Text(
                      l10n.credits,
                      style: GoogleFonts.exo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _onBackPressed,
                    child: Text(
                      l10n.back,
                      style: GoogleFonts.exo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );

    final platform = Theme.of(context).platform;
    final useCupertino =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

    if (useCupertino) {
      return DefaultTextStyle.merge(
        style: const TextStyle(decoration: TextDecoration.none),
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: title,
            backgroundColor: AppColors.midnightNavy,
            border: null,
          ),
          child: body,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: title, centerTitle: true),
      body: body,
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final Color titleColor;

  const _InfoCard({
    required this.title,
    required this.description,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: titleColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.exo2(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(color: AppColors.softSlate, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ReferenceCard extends StatelessWidget {
  final String authors;
  final String title;
  final String journal;

  const _ReferenceCard({
    required this.authors,
    required this.title,
    required this.journal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.electricCyan.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            authors,
            style: GoogleFonts.inter(
              color: AppColors.softSlate,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.exo2(
              color: AppColors.snowWhite,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            journal,
            style: GoogleFonts.inter(color: AppColors.softSlate, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
