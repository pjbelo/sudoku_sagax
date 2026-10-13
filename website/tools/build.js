#!/usr/bin/env node
// Gera as páginas estáticas de cada idioma a partir de js/i18n.js, para que os motores de busca
// vejam o texto traduzido sem executar JavaScript (como em sagax-games.com):
//   /index.html, /privacy.html, /contact.html          → inglês (também x-default)
//   /pt/, /es/, /fr/, /de/ (mesmos nomes de ficheiro)  → restantes idiomas
// As páginas da raiz são também os modelos: mantêm os atributos data-i18n*, por isso o script
// pode correr quantas vezes for preciso. Correr após editar textos ou HTML: node tools/build.js
'use strict';

const fs = require('fs');
const path = require('path');
const vm = require('vm');

const ROOT = path.join(__dirname, '..');
const SITE = 'https://sudoku.sagax-games.com/';
const LANGS = ['pt', 'en', 'es', 'fr', 'de']; // ordem dos botões de idioma
const DEFAULT_LANG = 'en';
const STORAGE_KEY = 'sudokusagax.lang';
const PAGES = ['index.html', 'privacy.html', 'contact.html'];
const LANG_NAMES = { pt: 'Português', en: 'English', es: 'Español', fr: 'Français', de: 'Deutsch' };
const OG_LOCALES = { pt: 'pt_PT', en: 'en_GB', es: 'es_ES', fr: 'fr_FR', de: 'de_DE' };

// [pistas, faixa] por nível, de 1 a 9 — igual a sudokuLevels em lib/game/sudoku_generator.dart
// (faixa = índice em bands[]: Iniciante, Fácil, Médio, Difícil, Especialista)
const LEVELS = [[46, 0], [42, 0], [38, 1], [35, 1], [32, 2], [30, 2], [28, 3], [26, 3], [24, 4]];

// Textos que js/sudoku.js lê da página (script#demo-text)
const DEMO_KEYS = ['statusPlaying', 'statusFull', 'statusWin'];

// Listas do HTML (data-i18n="benefits.0.1"): o modelo tem de mostrar todos os itens de i18n.js
const LISTS = ['benefits', 'features', 'shots', 'levelBands', 'levelClues'];

function loadI18n() {
  const sandbox = { window: {} };
  vm.runInNewContext(fs.readFileSync(path.join(ROOT, 'js/i18n.js'), 'utf8'), sandbox);
  return sandbox.window.SUDOKU_SAGAX_I18N;
}

const escText = (s) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
const escAttr = (s) => escText(s).replace(/"/g, '&quot;');

// Chaves com pontos: 'benefits.0.1' → t.benefits[0][1]
function lookup(t, key) {
  const value = key.split('.').reduce((obj, k) => (obj == null ? undefined : obj[k]), t);
  if (typeof value !== 'string') throw new Error(`Chave de tradução em falta: ${key}`);
  return value;
}

function replaceOnce(html, re, fn, what) {
  let found = false;
  const out = html.replace(re, (...args) => { found = true; return fn(...args); });
  if (!found) throw new Error(`Não encontrado no modelo: ${what}`);
  return out;
}

// Textos derivados: a faixa e as pistas de cada nível ("Beginner", "46 clues")
function withDerived(t) {
  const levelBands = LEVELS.map(([, band]) => t.bands[band]);
  const levelClues = LEVELS.map(([clues]) => clues + ' ' + t.clues);
  return Object.assign({}, t, { levelBands, levelClues });
}

const dir = (lang) => (lang === DEFAULT_LANG ? '' : lang + '/');
const pageName = (page) => (page === 'index.html' ? '' : page);
const absUrl = (lang, page) => SITE + dir(lang) + pageName(page);
// Link relativo entre versões de idioma da mesma página
const relUrl = (from, to, page) => (from === DEFAULT_LANG ? '' : '../') + dir(to) + pageName(page) || './';

function pageMeta(t, page) {
  if (page === 'contact.html') return { title: t.contactTitle + ' — Sudoku Sagax', description: t.contactMeta };
  if (page === 'privacy.html') return { title: t.privacy.title + ' — Sudoku Sagax', description: t.privacyMeta };
  return { title: t.title, description: t.metaDescription };
}

function headBlock(lang, page) {
  const links = [`<link rel="canonical" href="${absUrl(lang, page)}">`];
  LANGS.slice().sort().forEach((l) => links.push(`<link rel="alternate" hreflang="${l}" href="${absUrl(l, page)}">`));
  links.push(`<link rel="alternate" hreflang="x-default" href="${absUrl(DEFAULT_LANG, page)}">`);
  const urls = {};
  LANGS.forEach((l) => { urls[l] = relUrl(lang, l, page); });
  // Escolha do idioma antes de pintar a página: ?lang= (links antigos e de sagax-games.com) ou a
  // escolha guardada; só na versão inglesa (x-default) conta também o idioma do browser.
  // Os robots não têm escolha guardada nem ?lang=, por isso ficam sempre na página pedida.
  const script = `<script>
  (function () {
    var urls = ${JSON.stringify(urls)}, cur = '${lang}', key = '${STORAGE_KEY}', lang = null, saved = null;
    var ok = function (l) { return Object.prototype.hasOwnProperty.call(urls, l); };
    var param = new URLSearchParams(location.search).get('lang');
    try {
      if (ok(param)) localStorage.setItem(key, param);
      saved = localStorage.getItem(key);
    } catch (e) {}
    lang = ok(param) ? param : ok(saved) ? saved : null;
    if (!lang && cur === '${DEFAULT_LANG}') {
      var prefs = navigator.languages || [navigator.language || ''];
      for (var i = 0; i < prefs.length && !lang; i++) {
        var code = String(prefs[i]).slice(0, 2).toLowerCase();
        if (ok(code)) lang = code;
      }
    }
    if (lang && lang !== cur) location.replace(urls[lang] + location.hash);
    else if (param !== null) history.replaceState(null, '', location.pathname + location.hash);
  })();
  </script>`;
  return '<!-- i18n:head (gerado por tools/build.js) -->\n  ' + links.join('\n  ') + '\n  ' + script + '\n  <!-- /i18n:head -->';
}

function langBar(lang, page) {
  const links = LANGS.map((l) =>
    `<a href="${relUrl(lang, l, page)}" hreflang="${l}" lang="${l}" title="${LANG_NAMES[l]}"` +
    (l === lang ? ' aria-current="page"' : '') + `>${l.toUpperCase()}</a>`);
  return '\n    ' + links.join('\n    ') + '\n  ';
}

function privacyHtml(t) {
  const p = t.privacy;
  let html = `\n      <h1>${p.title}</h1>\n      <p class="last-updated">${p.updated}</p>\n      <p>${p.intro}</p>\n` +
    `      <div class="highlight"><p>${p.summary}</p></div>\n`;
  p.sections.forEach((s) => {
    html += `      <h2>${s[0]}</h2>\n`;
    s[1].forEach((para) => { html += `      <p>${para}</p>\n`; });
    if (s[2]) html += '      <ul>\n' + s[2].map((li) => `        <li>${li}</li>\n`).join('') + '      </ul>\n';
    if (s[3]) s[3].forEach((para) => { html += `      <p>${para}</p>\n`; });
  });
  return html + '    ';
}

// JSON dentro de <script>: escapa '<' para não fechar a tag
function demoJson(t) {
  const text = {};
  DEMO_KEYS.forEach((k) => {
    if (t[k] == null) throw new Error(`Chave de tradução em falta: ${k}`);
    text[k] = t[k];
  });
  return JSON.stringify(text).replace(/</g, '\\u003c');
}

// Cada lista de i18n.js tem de aparecer inteira no modelo (sem itens esquecidos)
function checkLists(template, t, page) {
  LISTS.forEach((list) => {
    const used = new Set();
    const re = new RegExp(`data-i18n(?:-html|-alt)?="${list}\\.(\\d+)`, 'g');
    let m;
    while ((m = re.exec(template))) used.add(Number(m[1]));
    if (used.size && used.size !== t[list].length) {
      throw new Error(`${page}: ${list} tem ${t[list].length} itens em i18n.js, o modelo mostra ${used.size}`);
    }
  });
}

function render(template, t, lang, page) {
  let html = template;
  const meta = pageMeta(t, page);

  html = replaceOnce(html, /<html lang="[^"]*">/, () => `<html lang="${t.htmlLang}">`, '<html lang>');
  html = replaceOnce(html, /<title>[\s\S]*?<\/title>/, () => `<title>${escText(meta.title)}</title>`, '<title>');
  html = replaceOnce(html, /(<meta name="description" content=")[^"]*/, (m, a) => a + escAttr(meta.description), 'meta description');
  html = html.replace(/(<meta property="og:title" content=")[^"]*/, (m, a) => a + escAttr(meta.title));
  html = html.replace(/(<meta property="og:description" content=")[^"]*/, (m, a) => a + escAttr(meta.description));
  html = html.replace(/(<meta property="og:url" content=")[^"]*/, (m, a) => a + absUrl(lang, page));
  html = html.replace(/(<meta property="og:locale" content=")[^"]*/, (m, a) => a + OG_LOCALES[lang]);
  html = replaceOnce(html, /<!-- i18n:head[\s\S]*?<!-- \/i18n:head -->/, () => headBlock(lang, page), 'marcadores i18n:head');
  html = replaceOnce(html, /(<nav class="lang-bar"[^>]*>)[\s\S]*?(<\/nav>)/, (m, a, b) => a + langBar(lang, page) + b, 'nav.lang-bar');

  // Conteúdo dos elementos: data-i18n (texto) e data-i18n-html (marcação estática de i18n.js)
  html = html.replace(/<([a-z][a-z0-9]*)\b([^>]*\sdata-i18n(-html)?="([^"]+)"[^>]*)>([\s\S]*?)<\/\1>/g,
    (m, tag, attrs, isHtml, key) => {
      const value = lookup(t, key);
      return `<${tag}${attrs}>${isHtml ? value : escText(value)}</${tag}>`;
    });
  html = html.replace(/<img\b[^>]*\sdata-i18n-alt="([^"]+)"[^>]*>/g,
    (m, key) => m.replace(/\salt="[^"]*"/, ` alt="${escAttr(lookup(t, key))}"`));

  // Screenshots localizados: img/screenshots/<lang>/<nome>.png
  html = html.replace(/<img\b[^>]*\sdata-shot="([^"]+)"[^>]*>/g,
    (m, name) => m.replace(/\ssrc="[^"]*"/, ` src="img/screenshots/${lang}/${name}.png"`));

  if (page === 'index.html') {
    html = replaceOnce(html, /(<script type="application\/json" id="demo-text">)[\s\S]*?(<\/script>)/,
      (m, a, b) => a + demoJson(t) + b, 'script#demo-text');
  }
  if (page === 'privacy.html') {
    html = replaceOnce(html, /(<article id="privacy">)[\s\S]*?(<\/article>)/, (m, a, b) => a + privacyHtml(t) + b, 'article#privacy');
  }

  // Páginas noutros idiomas ficam numa subpasta: os recursos partilhados sobem um nível
  if (lang !== DEFAULT_LANG) html = html.replace(/(\s(?:href|src)=")((?:css|img|js)\/)/g, '$1../$2');
  return html;
}

function sitemap() {
  const today = new Date().toISOString().slice(0, 10);
  const alternates = (page) => LANGS.slice().sort()
    .map((l) => `    <xhtml:link rel="alternate" hreflang="${l}" href="${absUrl(l, page)}"/>`)
    .concat(`    <xhtml:link rel="alternate" hreflang="x-default" href="${absUrl(DEFAULT_LANG, page)}"/>`)
    .join('\n');
  const urls = [];
  PAGES.forEach((page) => {
    [DEFAULT_LANG].concat(LANGS.filter((l) => l !== DEFAULT_LANG)).forEach((lang) => {
      urls.push(`  <url>\n    <loc>${absUrl(lang, page)}</loc>\n    <lastmod>${today}</lastmod>\n${alternates(page)}\n  </url>`);
    });
  });
  return '<?xml version="1.0" encoding="UTF-8"?>\n' +
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"\n        xmlns:xhtml="http://www.w3.org/1999/xhtml">\n' +
    urls.join('\n') + '\n</urlset>\n';
}

function main() {
  const I18N = loadI18n();
  LANGS.forEach((lang) => {
    if (!I18N[lang]) throw new Error(`Idioma em falta em js/i18n.js: ${lang}`);
  });
  PAGES.forEach((page) => {
    const template = fs.readFileSync(path.join(ROOT, page), 'utf8');
    LANGS.forEach((lang) => {
      const t = withDerived(I18N[lang]);
      checkLists(template, t, page);
      const out = path.join(ROOT, dir(lang), page);
      fs.mkdirSync(path.dirname(out), { recursive: true });
      fs.writeFileSync(out, render(template, t, lang, page));
      console.log('✓ ' + path.relative(ROOT, out));
    });
  });
  fs.writeFileSync(path.join(ROOT, 'sitemap.xml'), sitemap());
  console.log('✓ sitemap.xml');
}

main();
