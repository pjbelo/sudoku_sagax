# Sudoku and the brain — research notes

Background for the in-app **Brain Benefits** screen
([lib/screens/info_screen.dart](../lib/screens/info_screen.dart)) and for the
level design. Every citation below was checked against Crossref (October 2026).
If you change the in-app benefit texts, keep them within what these sources
support.

## Summary

- The best evidence links **regular number-puzzle play** (Sudoku and similar)
  with **better attention, reasoning, processing speed, executive function and
  memory** in middle-aged and older adults. Brooker et al. 2019 is the largest
  study (n ≈ 19,000).
- **Working memory** is the cognitive resource most directly tied to Sudoku
  performance (Grabbe 2011, 2017).
- Longitudinal cohorts associate puzzles and games with **slower cognitive
  decline** and **better function years later** (Litwin et al. 2017; Altschul
  & Deary 2020; Verghese et al. 2003). That fits the **cognitive reserve**
  model (Stern 2012).
- **Interventional evidence is thin but encouraging.** An RCT of a 24-week
  Sudoku training programme in older adults with mild cognitive impairment
  reported gains in global cognition, working memory and executive function
  (Yu et al. 2023, so far published only as a conference abstract).
- **Caveat:** most studies are observational, so they show associations, not
  causation. People who are already cognitively sharp may simply enjoy puzzles
  more. The app says this explicitly ("A note on the evidence").

## Studies used in the app

### Number puzzles and cognition

**Brooker, H., Wesnes, K. A., Ballard, C., Hampshire, A., Aarsland, D., Khan, Z.,
Stenton, R., Megalogeni, M., & Corbett, A. (2019).** The relationship between
the frequency of number-puzzle use and baseline cognitive function in a large
online sample of adults aged 50 and over. *International Journal of Geriatric
Psychiatry, 34*(7), 932–940. doi:10.1002/gps.5085
- PROTECT online cohort, 19,078 adults aged 50–93.
- Frequency of number-puzzle use had significant effects on all 14 cognitive
  measures: reasoning, focused and sustained attention, information processing,
  executive function, working memory and episodic memory. People who played
  more than once a day did best on 10 core measures.
- Cross-sectional. → *Benefits 3 and 4.*

**Ferreira, N., Owen, A., Mohan, A., Corbett, A., & Ballard, C. (2015).**
Associations between cognitively stimulating leisure activities, cognitive
function and age-related cognitive decline. *International Journal of
Geriatric Psychiatry, 30*(4), 422–430. doi:10.1002/gps.4155
- Online sample of over 65,000 people (Cambridge Brain Sciences tests). Looked
  at crosswords, Sudoku, brain-training games and other video games.
- Sudoku frequency was positively associated with performance on several
  cognitive tasks. Cross-sectional.

### Working memory

**Grabbe, J. W. (2011).** Sudoku and working memory performance for older
adults. *Activities, Adaptation & Aging, 35*(3), 241–254.
doi:10.1080/01924788.2011.596748

**Grabbe, J. W. (2017).** Sudoku and changes in working memory performance for
older adults and younger adults. *Activities, Adaptation & Aging, 41*(1), 14–21.
doi:10.1080/01924788.2016.1272390
- Sudoku performance relates to working-memory capacity, and Sudoku shares the
  cognitive processes working memory relies on. Small samples. → *Benefit 2.*

### Longitudinal: healthy ageing and cognitive reserve

**Litwin, H., Schwartz, E., & Damri, N. (2017).** Cognitively stimulating
leisure activity and subsequent cognitive function: A SHARE-based analysis.
*The Gerontologist, 57*(5), 940–948. doi:10.1093/geront/gnw084
- About 17,000 Europeans aged 65+ (SHARE). Doing word or number puzzles
  predicted better memory, numeracy and verbal fluency two years later.
  Taking up puzzles between waves was also associated with better function
  ("never too late"). → *Benefit 5.*

**Altschul, D. M., & Deary, I. J. (2020).** Playing analog games is associated
with reduced declines in cognitive function: A 68-year longitudinal cohort
study. *The Journals of Gerontology: Series B, 75*(3), 474–482.
doi:10.1093/geronb/gbz149
- Lothian Birth Cohort 1936 (n = 1,091), tested from age 11 to 79. More
  game-playing was associated with less cognitive decline from 70 to 79,
  especially in memory. Covers board and card games as well as puzzles.

**Verghese, J., Lipton, R. B., Katz, M. J., et al. (2003).** Leisure activities
and the risk of dementia in the elderly. *New England Journal of Medicine,
348*(25), 2508–2516. doi:10.1056/NEJMoa022252
- Bronx Aging Study. Cognitive leisure activities (puzzles, board games,
  reading) were associated with lower dementia risk. Predates Sudoku's
  popularity, so it's cited for puzzles in general.

**Stern, Y. (2012).** Cognitive reserve in ageing and Alzheimer's disease.
*The Lancet Neurology, 11*(11), 1006–1012. doi:10.1016/S1474-4422(12)70191-6
- The theoretical framework: lifelong mental stimulation builds reserve that
  buffers age-related decline.

### Intervention

**Yu, D., Li, P., Two, W., & Waye, M. (2023).** Effects of gamified cognitive
training to deter the progression of mild cognitive impairment. *Innovation in
Aging, 7*(Suppl. 1), 645. doi:10.1093/geroni/igad104.2098 — conference
abstract. Trial registration: ClinicalTrials.gov NCT04913857.
- Sudoku Mind Activation and Revitalizing Training (SMART): single-blind RCT
  with 288 older adults with MCI, run as 12 weeks of training plus 12 weeks of
  self-practice.
- Reported greater gains than usual care in global cognition, working memory,
  language, delayed recall, recognition memory and subjective memory
  complaints. The effects, plus executive function, were sustained to the end
  of the programme.
- Not yet a full peer-reviewed paper; worth re-checking for a journal
  publication before the store release. → *Benefit 1.*

### Flow and well-being

**Nakamura, J., & Csikszentmihalyi, M. (2014).** The concept of flow. In *Flow
and the Foundations of Positive Psychology* (pp. 239–263). Springer.
- Flow arises when challenge matches skill. This is the design rationale for
  nine finely graded levels. → *Benefit 6.* (Same reference as Slidox.)

## Research behind the level design

**McGuire, G., Tugemann, B., & Civario, G. (2014).** There is no 16-clue
Sudoku: Solving the Sudoku minimum number of clues problem via hitting set
enumeration. *Experimental Mathematics, 23*(2), 190–217.
doi:10.1080/10586458.2013.870056
- A puzzle with a unique solution needs at least 17 givens. Level 9 uses 24,
  safely above that, and still generates in a few milliseconds.

**Pelánek, R. (2014).** Difficulty rating of Sudoku puzzles: An overview and
evaluation. arXiv:1403.7373.
- With more than 1,700 puzzles and hundreds of human solvers, clue count alone
  predicts difficulty poorly. A model of the *logic steps* a human needs does
  much better (r ≈ 0.95).
- That is why each level in
  [sudoku_generator.dart](../lib/game/sudoku_generator.dart) sets both a clue
  target and a required technique:

| Level | Givens | Band | Technique requirement |
|---|---|---|---|
| 1–2 | 46, 42 | Beginner | Solvable with naked + hidden singles only |
| 3–4 | 38, 35 | Easy | Singles only |
| 5 | 32 | Medium | Singles only |
| 6 | 30 | Medium | Unique solution, any technique |
| 7–8 | 28, 26 | Hard | Unique, and singles alone get stuck (needs candidate elimination, so notes matter) |
| 9 | 24 | Expert | Same as 7–8, with fewer givens |

## Not used

- Popular claims that Sudoku "lowers cortisol" or "boosts dopamine" have no
  direct Sudoku-specific evidence. They are left out of the app on purpose.
- Brain-training transfer in general is contested (e.g. Simons et al. 2016,
  *Psychological Science in the Public Interest*). The app avoids promising
  improvements in unrelated everyday tasks.
