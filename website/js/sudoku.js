// Sudoku jogável da página inicial: um puzzle de nível 1 (Iniciante) gerado no
// browser com o mesmo método da app (lib/game/sudoku_generator.dart): grelha
// resolvida aleatória e remoção de células enquanto o puzzle continuar
// resolúvel só com "singles" — o que garante solução única.
(function () {
  'use strict';

  var CLUES = 46; // nível 1 da app (sudokuLevels)

  // --- Geometria ---
  function rowOf(i) { return (i / 9) | 0; }
  function colOf(i) { return i % 9; }
  function boxOf(i) { return ((i / 27) | 0) * 3 + (((i % 9) / 3) | 0); }

  var units = [];
  for (var u = 0; u < 9; u++) {
    var row = [], col = [], box = [];
    for (var k = 0; k < 9; k++) {
      row.push(u * 9 + k);
      col.push(k * 9 + u);
      box.push((((u / 3) | 0) * 3 + ((k / 3) | 0)) * 9 + (u % 3) * 3 + (k % 3));
    }
    units.push(row, col, box);
  }

  var peers = [];
  for (var i = 0; i < 81; i++) {
    var list = [];
    for (var j = 0; j < 81; j++) {
      if (j !== i && (rowOf(j) === rowOf(i) || colOf(j) === colOf(i) || boxOf(j) === boxOf(i))) list.push(j);
    }
    peers.push(list);
  }

  function shuffled(arr) {
    var a = arr.slice();
    for (var i = a.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var tmp = a[i]; a[i] = a[j]; a[j] = tmp;
    }
    return a;
  }

  // --- Gerador ---
  function solvedGrid() {
    var g = new Array(81).fill(0);
    function fits(i, d) {
      for (var p = 0; p < peers[i].length; p++) if (g[peers[i][p]] === d) return false;
      return true;
    }
    function fill(i) {
      if (i === 81) return true;
      var digits = shuffled([1, 2, 3, 4, 5, 6, 7, 8, 9]);
      for (var n = 0; n < 9; n++) {
        if (fits(i, digits[n])) {
          g[i] = digits[n];
          if (fill(i + 1)) return true;
        }
      }
      g[i] = 0;
      return false;
    }
    fill(0);
    return g;
  }

  function digitOf(bit) { var d = 1; while (bit > 1) { bit >>= 1; d++; } return d; }

  // Resolúvel só com naked singles e hidden singles (como solvableWithSingles na app)
  function solvableWithSingles(board) {
    var cells = board.slice();
    var cand = new Array(81).fill(0);
    var empty = 0;
    for (var i = 0; i < 81; i++) {
      if (cells[i]) continue;
      empty++;
      var used = 0;
      peers[i].forEach(function (p) { if (cells[p]) used |= 1 << (cells[p] - 1); });
      cand[i] = 511 & ~used;
      if (!cand[i]) return false;
    }
    function place(i, bit) {
      cells[i] = digitOf(bit);
      cand[i] = 0;
      peers[i].forEach(function (p) { cand[p] &= ~bit; });
      empty--;
    }
    var progress = true;
    while (empty > 0 && progress) {
      progress = false;
      for (var c = 0; c < 81; c++) {
        if (cells[c]) continue;
        var m = cand[c];
        if (!m) return false;
        if ((m & (m - 1)) === 0) { place(c, m); progress = true; }
      }
      for (var u = 0; u < units.length; u++) {
        for (var bit = 1; bit <= 256; bit <<= 1) {
          var spot = -1, spots = 0, present = false;
          for (var n = 0; n < 9; n++) {
            var cell = units[u][n];
            if (cells[cell]) { if (1 << (cells[cell] - 1) === bit) present = true; }
            else if (cand[cell] & bit) { spot = cell; spots++; }
          }
          if (present) continue;
          if (!spots) return false;
          if (spots === 1) { place(spot, bit); progress = true; }
        }
      }
    }
    return empty === 0;
  }

  function generate() {
    var solution = solvedGrid();
    var givens = solution.slice();
    var clues = 81;
    var order = shuffled(Array.from({ length: 81 }, function (_, i) { return i; }));
    for (var n = 0; n < order.length && clues > CLUES; n++) {
      var i = order[n];
      var kept = givens[i];
      givens[i] = 0;
      if (solvableWithSingles(givens)) clues--;
      else givens[i] = kept;
    }
    return { givens: givens, solution: solution };
  }

  // --- Estado e interface ---
  var board, cells = [], pad = [], timeEl, mistakesEl, statusEl;
  var puzzle, values, selected = -1, mistakes = 0, seconds = 0, solved = false;
  var t = null;

  function formatTime(s) { return Math.floor(s / 60) + ':' + String(s % 60).padStart(2, '0'); }

  function isGiven(i) { return puzzle.givens[i] !== 0; }

  function render() {
    var selValue = selected >= 0 ? values[selected] : 0;
    for (var i = 0; i < 81; i++) {
      var c = cells[i];
      var v = values[i];
      c.textContent = v ? String(v) : '';
      var peer = selected >= 0 && i !== selected &&
        (rowOf(i) === rowOf(selected) || colOf(i) === colOf(selected) || boxOf(i) === boxOf(selected));
      c.classList.toggle('given', isGiven(i));
      c.classList.toggle('selected', i === selected);
      c.classList.toggle('peer', peer);
      c.classList.toggle('same', selValue !== 0 && v === selValue && i !== selected);
      c.classList.toggle('wrong', v !== 0 && v !== puzzle.solution[i]);
      c.tabIndex = i === (selected >= 0 ? selected : 0) ? 0 : -1;
    }
    for (var d = 1; d <= 9; d++) {
      var count = values.filter(function (x) { return x === d; }).length;
      pad[d - 1].classList.toggle('done', count >= 9);
    }
    mistakesEl.textContent = String(mistakes);
    board.classList.toggle('solved', solved);
    renderStatus();
  }

  function renderStatus() {
    if (!t) return;
    var full = values.indexOf(0) === -1;
    statusEl.classList.toggle('win', solved);
    statusEl.textContent = solved ? t.statusWin.replace('{t}', formatTime(seconds))
      : full ? t.statusFull
      : t.statusPlaying;
  }

  function select(i, focus) {
    if (solved) return;
    selected = i;
    render();
    if (focus) cells[i].focus();
  }

  function enter(d) {
    if (solved || selected < 0 || isGiven(selected)) return;
    if (values[selected] === d) {
      values[selected] = 0;
    } else {
      values[selected] = d;
      if (d !== puzzle.solution[selected]) mistakes++;
    }
    solved = values.every(function (v, i) { return v === puzzle.solution[i]; });
    if (solved) selected = -1;
    render();
  }

  function erase() {
    if (solved || selected < 0 || isGiven(selected)) return;
    values[selected] = 0;
    render();
  }

  function newPuzzle() {
    puzzle = generate();
    values = puzzle.givens.slice();
    selected = -1;
    mistakes = 0;
    seconds = 0;
    solved = false;
    timeEl.textContent = formatTime(0);
    render();
  }

  function onKey(e) {
    if (e.key >= '1' && e.key <= '9') { enter(Number(e.key)); e.preventDefault(); return; }
    if (e.key === 'Backspace' || e.key === 'Delete' || e.key === '0') { erase(); e.preventDefault(); return; }
    var moves = { ArrowUp: -9, ArrowDown: 9, ArrowLeft: -1, ArrowRight: 1 };
    if (!(e.key in moves)) return;
    e.preventDefault();
    var from = selected >= 0 ? selected : 40;
    var r = rowOf(from), c = colOf(from);
    if (e.key === 'ArrowUp') r = (r + 8) % 9;
    if (e.key === 'ArrowDown') r = (r + 1) % 9;
    if (e.key === 'ArrowLeft') c = (c + 8) % 9;
    if (e.key === 'ArrowRight') c = (c + 1) % 9;
    select(r * 9 + c, true);
  }

  function build() {
    board = document.getElementById('sudoku');
    if (!board) return;
    timeEl = document.getElementById('demo-time');
    mistakesEl = document.getElementById('demo-mistakes');
    statusEl = document.getElementById('demo-status');

    for (var i = 0; i < 81; i++) {
      var cell = document.createElement('button');
      cell.type = 'button';
      cell.className = 'cell';
      cell.setAttribute('role', 'gridcell');
      cell.setAttribute('aria-label', (rowOf(i) + 1) + ',' + (colOf(i) + 1));
      cell.addEventListener('click', (function (idx) {
        return function () { select(idx, false); };
      })(i));
      cells.push(cell);
      board.append(cell);
    }
    board.addEventListener('keydown', onKey);

    var numpad = document.getElementById('numpad');
    for (var d = 1; d <= 9; d++) {
      var key = document.createElement('button');
      key.type = 'button';
      key.textContent = String(d);
      key.addEventListener('click', (function (digit) {
        return function () { enter(digit); };
      })(d));
      pad.push(key);
      numpad.append(key);
    }
    numpad.addEventListener('keydown', onKey);

    document.getElementById('demo-erase').addEventListener('click', erase);
    document.getElementById('demo-new').addEventListener('click', newPuzzle);

    // O relógio só conta com a página visível e o puzzle por resolver
    setInterval(function () {
      if (solved || document.hidden) return;
      seconds++;
      timeEl.textContent = formatTime(seconds);
    }, 1000);

    newPuzzle();
  }

  document.addEventListener('sudoku:lang', function (e) {
    t = e.detail.t;
    if (board) renderStatus();
  });

  document.addEventListener('DOMContentLoaded', build);

  // Para testes: o gerador sem a interface
  window.SudokuSagaxDemo = { generate: generate, solvableWithSingles: solvableWithSingles };
})();
