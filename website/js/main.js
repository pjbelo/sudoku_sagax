(function () {
  'use strict';

  var I18N = window.SUDOKU_SAGAX_I18N;
  var LANGS = ['pt', 'en', 'es', 'fr', 'de'];
  var DEFAULT_LANG = 'en';
  var STORAGE_KEY = 'sudokusagax.lang';

  // Ordem: início, jogo, recordes, benefícios (igual a shots[] em i18n.js).
  // Capturas do Pixel 9 Pro, copiadas de docs/google-play/screenshots/.
  var SCREENSHOTS = ['1_home', '2_game', '4_scoreboard', '6_info'];

  // [nível, pistas, faixa] — igual a sudokuLevels em lib/game/sudoku_generator.dart
  var LEVELS = [
    [1, 46, 0], [2, 42, 0], [3, 38, 1], [4, 35, 1], [5, 32, 2],
    [6, 30, 2], [7, 28, 3], [8, 26, 3], [9, 24, 4]
  ];

  // Mesmas referências do ecrã Info da app (lib/screens/info_screen.dart)
  var REFERENCES = [
    ['Brooker, H., Wesnes, K. A., Ballard, C., et al. (2019)', 'The relationship between the frequency of number-puzzle use and baseline cognitive function in a large online sample of adults aged 50 and over', 'International Journal of Geriatric Psychiatry, 34(7), 932–940'],
    ['Grabbe, J. W. (2011)', 'Sudoku and Working Memory Performance for Older Adults', 'Activities, Adaptation & Aging, 35(3), 241–254'],
    ['Litwin, H., Schwartz, E., & Damri, N. (2017)', 'Cognitively Stimulating Leisure Activity and Subsequent Cognitive Function: A SHARE-based Analysis', 'The Gerontologist, 57(5), 940–948'],
    ['Ferreira, N., Owen, A., Mohan, A., Corbett, A., & Ballard, C. (2015)', 'Associations between cognitively stimulating leisure activities, cognitive function and age-related cognitive decline', 'International Journal of Geriatric Psychiatry, 30(4), 422–430'],
    ['Yu, D., Li, P., Two, W., & Waye, M. (2023)', 'Effects of Gamified Cognitive Training to Deter the Progression of Mild Cognitive Impairment (Sudoku SMART trial)', 'Innovation in Aging, 7(Suppl. 1), 645 — conference abstract; ClinicalTrials.gov NCT04913857'],
    ['Altschul, D. M., & Deary, I. J. (2020)', 'Playing Analog Games Is Associated With Reduced Declines in Cognitive Function: A 68-Year Longitudinal Cohort Study', 'The Journals of Gerontology: Series B, 75(3), 474–482'],
    ['Verghese, J., Lipton, R. B., Katz, M. J., et al. (2003)', 'Leisure Activities and the Risk of Dementia in the Elderly', 'New England Journal of Medicine, 348(25), 2508–2516'],
    ['Stern, Y. (2012)', "Cognitive reserve in ageing and Alzheimer's disease", 'The Lancet Neurology, 11(11), 1006–1012'],
    ['Nakamura, J., & Csikszentmihalyi, M. (2014)', 'The Concept of Flow', 'Flow and the Foundations of Positive Psychology, Springer, 239–263']
  ];

  function readStored() {
    try { return localStorage.getItem(STORAGE_KEY); } catch (e) { return null; }
  }
  function writeStored(lang) {
    try { localStorage.setItem(STORAGE_KEY, lang); } catch (e) { /* sem storage */ }
  }

  function detectLang() {
    var param = new URLSearchParams(location.search).get('lang');
    if (param && I18N[param]) return param;
    var stored = readStored();
    if (stored && I18N[stored]) return stored;
    var prefs = navigator.languages || [navigator.language || ''];
    for (var i = 0; i < prefs.length; i++) {
      var code = String(prefs[i]).slice(0, 2).toLowerCase();
      if (I18N[code]) return code;
    }
    return DEFAULT_LANG;
  }

  function el(tag, cls, text) {
    var node = document.createElement(tag);
    if (cls) node.className = cls;
    if (text != null) node.textContent = text;
    return node;
  }

  function renderBenefits(t) {
    var box = document.getElementById('benefits');
    if (!box) return;
    box.replaceChildren();
    t.benefits.forEach(function (b) {
      var card = el('article', 'benefit-card');
      card.append(el('div', 'icon', b[0]), el('h3', null, b[1]), el('p', null, b[2]));
      box.append(card);
    });
  }

  function renderFeatures(t) {
    var list = document.getElementById('features');
    if (!list) return;
    list.replaceChildren();
    t.features.forEach(function (f) {
      var li = el('li');
      var icon = el('span', 'icon', f[0]);
      icon.setAttribute('aria-hidden', 'true');
      li.append(icon, document.createTextNode(f[1]));
      list.append(li);
    });
  }

  function renderLevels(t) {
    var box = document.getElementById('levels');
    if (!box) return;
    box.replaceChildren();
    LEVELS.forEach(function (lv) {
      var card = el('div', 'level');
      card.append(
        el('b', null, String(lv[0])),
        el('span', 'band', t.bands[lv[2]]),
        el('span', null, lv[1] + ' ' + t.clues)
      );
      box.append(card);
    });
  }

  function renderReferences() {
    var list = document.getElementById('references');
    if (!list || list.childElementCount) return;
    REFERENCES.forEach(function (r) {
      var li = el('li');
      li.append(document.createTextNode(r[0] + '. '), el('cite', null, r[1]), document.createTextNode('. ' + r[2] + '.'));
      list.append(li);
    });
  }

  function renderScreenshots(t, lang) {
    var box = document.getElementById('screenshots');
    if (!box) return;
    box.replaceChildren();
    SCREENSHOTS.forEach(function (name, i) {
      var src = 'img/screenshots/' + lang + '/' + name + '.png';
      var fig = el('figure');
      var btn = el('button');
      btn.type = 'button';
      btn.setAttribute('aria-label', t.shots[i]);
      var img = el('img');
      img.src = src;
      img.alt = t.shots[i];
      img.loading = 'lazy';
      img.decoding = 'async';
      img.width = 1280;
      img.height = 2856;
      btn.append(img);
      btn.addEventListener('click', function () { openLightbox(src, t.shots[i]); });
      fig.append(btn, el('figcaption', null, t.shots[i]));
      box.append(fig);
    });
  }

  function renderPrivacy(t) {
    var box = document.getElementById('privacy');
    if (!box) return;
    var p = t.privacy;
    var html = '<h1>' + p.title + '</h1>' +
      '<p class="last-updated">' + p.updated + '</p>' +
      '<p>' + p.intro + '</p>' +
      '<div class="highlight"><p>' + p.summary + '</p></div>';
    p.sections.forEach(function (s) {
      html += '<h2>' + s[0] + '</h2>';
      s[1].forEach(function (para) { html += '<p>' + para + '</p>'; });
      if (s[2]) html += '<ul>' + s[2].map(function (li) { return '<li>' + li + '</li>'; }).join('') + '</ul>';
      if (s[3]) s[3].forEach(function (para) { html += '<p>' + para + '</p>'; });
    });
    // Conteúdo estático e controlado (i18n.js), não vem do utilizador
    box.innerHTML = html;
    document.title = p.title + ' — Sudoku Sagax';
  }

  // Lightbox dos screenshots
  var lightbox, lightboxImg, lastFocus;
  function openLightbox(src, alt) {
    if (!lightbox) return;
    lastFocus = document.activeElement;
    lightboxImg.src = src;
    lightboxImg.alt = alt;
    lightbox.classList.add('open');
    lightbox.focus();
  }
  function closeLightbox() {
    if (!lightbox || !lightbox.classList.contains('open')) return;
    lightbox.classList.remove('open');
    if (lastFocus) lastFocus.focus();
  }

  function applyLang(lang) {
    var t = I18N[lang];
    document.documentElement.lang = t.htmlLang;

    if (document.body.dataset.page === 'home') {
      document.title = t.title;
    } else if (document.body.dataset.page === 'contact') {
      document.title = t.contactTitle + ' — Sudoku Sagax';
    }
    var meta = document.querySelector('meta[name="description"]');
    if (meta) meta.setAttribute('content', t.metaDescription);

    document.querySelectorAll('[data-i18n]').forEach(function (node) {
      var value = t[node.dataset.i18n];
      if (value != null) node.textContent = value;
    });

    document.querySelectorAll('.lang-bar button').forEach(function (btn) {
      btn.setAttribute('aria-pressed', String(btn.dataset.lang === lang));
    });

    // Mantém o idioma ao navegar entre páginas
    document.querySelectorAll('a[data-keep-lang]').forEach(function (a) {
      var base = a.getAttribute('href').split('?')[0];
      a.setAttribute('href', base + '?lang=' + lang);
    });

    var year = document.getElementById('year');
    if (year) year.textContent = String(new Date().getFullYear());

    renderLevels(t);
    renderBenefits(t);
    renderReferences();
    renderFeatures(t);
    renderScreenshots(t, lang);
    renderPrivacy(t);

    var url = new URL(location.href);
    url.searchParams.set('lang', lang);
    history.replaceState(null, '', url);

    document.dispatchEvent(new CustomEvent('sudoku:lang', { detail: { lang: lang, t: t } }));
  }

  function buildLangBar(current) {
    var bar = document.querySelector('.lang-bar');
    if (!bar) return;
    LANGS.forEach(function (code) {
      var btn = el('button', null, code.toUpperCase());
      btn.type = 'button';
      btn.dataset.lang = code;
      btn.setAttribute('aria-pressed', String(code === current));
      btn.addEventListener('click', function () {
        writeStored(code);
        applyLang(code);
      });
      bar.append(btn);
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    lightbox = document.getElementById('lightbox');
    if (lightbox) {
      lightboxImg = lightbox.querySelector('img');
      lightbox.addEventListener('click', closeLightbox);
      document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeLightbox();
      });
    }

    var lang = detectLang();
    buildLangBar(lang);
    applyLang(lang);
  });

  window.SudokuSagaxSite = { currentLang: function () { return document.documentElement.lang; } };
})();
