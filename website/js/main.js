(function () {
  'use strict';

  // Os textos já vêm traduzidos no HTML (gerado por tools/build.js a partir de js/i18n.js).
  // A escolha automática do idioma corre num script inline no <head> de cada página.
  var STORAGE_KEY = 'sudokusagax.lang';

  function writeStored(lang) {
    try { localStorage.setItem(STORAGE_KEY, lang); } catch (e) { /* sem storage */ }
  }

  // Guarda a escolha e mantém a secção atual (#hash) ao mudar de idioma
  function setupLangBar() {
    document.querySelectorAll('.lang-bar a[hreflang]').forEach(function (a) {
      a.addEventListener('click', function () {
        writeStored(a.getAttribute('hreflang'));
        if (location.hash) a.setAttribute('href', a.getAttribute('href').split('#')[0] + location.hash);
      });
    });
  }

  // Lightbox dos screenshots
  function setupLightbox() {
    var lightbox = document.getElementById('lightbox');
    if (!lightbox) return;
    var lightboxImg = lightbox.querySelector('img');
    var lastFocus;

    function open(img) {
      lastFocus = document.activeElement;
      lightboxImg.src = img.currentSrc || img.src;
      lightboxImg.alt = img.alt;
      lightbox.classList.add('open');
      lightbox.focus();
    }
    function close() {
      if (!lightbox.classList.contains('open')) return;
      lightbox.classList.remove('open');
      if (lastFocus) lastFocus.focus();
    }

    document.querySelectorAll('#screenshots button').forEach(function (btn) {
      btn.addEventListener('click', function () { open(btn.querySelector('img')); });
    });
    lightbox.addEventListener('click', close);
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') close();
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    setupLangBar();
    setupLightbox();
    var year = document.getElementById('year');
    if (year) year.textContent = String(new Date().getFullYear());
  });
})();
