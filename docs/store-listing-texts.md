# Sudoku Sagax — Store Listing Texts

Marketing and metadata copy for the App Store (iOS) and Google Play (Android), localized
in all languages supported by the app: **English, Portuguese, German, Spanish, French**.
English, Portuguese and Spanish each have two store listings, one per large market, with that
market's spelling, vocabulary and search terms. The app itself has one translation per language
and picks it from the device's language (pt-BR uses `pt`, en-US `en`, es-MX `es`), so the extra
listings need no change in the app.

| Listing | Play Console language | App Store Connect localization | Screenshots and artwork |
|---|---|---|---|
| en-GB | English (United Kingdom) – en-GB | English (U.K.) | `en` |
| en-US | English (United States) – en-US | English (U.S.) | `en` |
| pt-PT | Portuguese (Portugal) – pt-PT | Portuguese (Portugal) | `pt` |
| pt-BR | Portuguese (Brazil) – pt-BR | Portuguese (Brazil) | `pt` |
| es-ES | Spanish (Spain) – es-ES | Spanish (Spain) | `es` |
| es-419 | Spanish (Latin America) – es-419 | Spanish (Mexico) | `es` |
| fr-FR | French (France) – fr-FR | French | `fr` |
| de-DE | German (Germany) – de-DE | German | `de` |

The screenshots and artwork are captured from the app, so the pt-BR and es-419 listings show
the app's Portuguese (from Portugal) and Spanish (from Spain), and en-US its British spelling.
For the same reason, feature names in the descriptions (Daily puzzle, Notes, Mark conflicts…)
use the app's own words in each language, also in the pt-BR and es-419 listings.

**Sudoku Sagax** is the app name (the store name adds a search term; see the ASO note). **Sagax Games** is the brand/publisher behind a family of
games (Memorex, Slidox, Sudoku Sagax, MasterCode).

Field length guidance:
- **App Store** — Name: 30 chars · Subtitle: 30 chars · Promotional text: 170 chars · Keywords: 100 chars · Description: 4000 chars.
- **Google Play** — Title: 30 chars · Short description: 80 chars · Full description: 4000 chars.

Notes:
- **What sets the app apart (Guideline 4.3).** Sudoku is one of the most crowded puzzle
  categories, so every listing leads with what a standard sudoku doesn't have: the logic
  coach, levels graded by technique, guided lessons and the game review, then the daily
  puzzle and sharing. Keep that order when editing, and keep the App Review notes below in
  step with it.
- **ASO (store search).** The App Store searches only the **name**, **subtitle** and
  **keywords**, not the description or promotional text. Google Play searches the **title**,
  **short description** and **full description**, and has no keyword field. So:
  - The store name (also the Play title) is "Sudoku Sagax:" plus the main number-puzzle term in
    each language. On the device the app is still just Sudoku Sagax (`CFBundleDisplayName`,
    `android:label`).
  - The App Store subtitle carries a genre term (logic, brain game) and the logic coach, the
    app's main difference. The Play short description says the same, because Play has no
    subtitle.
  - App Store keywords: single words, commas without spaces, no word already in the name or
    subtitle (so never "sudoku"), no other app or brand names. Words combine across the three
    fields, so "brain" + `teaser` also match "brain teaser", and `daily` + "Puzzle" match
    "daily puzzle". Use as much of the 100 characters as fits.
  - "Classic" (and its translations) goes only in the App Store keywords, never in the Play
    fields (see the Metadata policy note).
  - The full description opens with the main terms and repeats them naturally a few times in
    the text, never as a keyword list (the Play Metadata policy bans repetitive or unrelated
    keywords).
  - After launch, check which search terms bring visitors (Play Console's store performance
    report by search term; App Store Connect's App Analytics, App Store Search source) and
    swap the keywords that bring nothing.
- The brain-benefit wording stays within what [research.md](research.md) supports
  (associations, not proof), like the app's Info screen. Keep it that way when editing. The
  sentence on grading by logic steps comes from Pelánek (2014) in research.md.
- **Google Play Metadata policy:** the short and full descriptions carry no price or
  promotional claims ("free", "no ads", "no in-app purchases"), no ranking words
  ("the classic", "best", "top", "#1", "new") and no sales pitch. MasterCode 1.0.0 was
  rejected on 16 October 2026 for promotional content in its full description, so these
  listings follow the same rule. Ads, in-app purchases and price are declared in Play
  Console's own fields instead.
- **Platform lines.** Each listing ends with lines for one store only: Game Center and iPhone
  Duo on the App Store, Google Play Games on Google Play. Add the Play Games line only once
  Play Games is live in the app (the IDs in `lib/game/play_games_ids.dart`; see
  [play-games.md](google-play/play-games.md)).

---

## 🇬🇧 English (UK) (en-GB)

**App name (App Store and Google Play, ≤30)**
Sudoku Sagax: Number Puzzle

**Subtitle (App Store, ≤30)**
Logic Coach & Brain Game

**Short description (Play Store, ≤80)**
Number puzzle & brain game with a logic coach that explains every hint.

**Promotional text (App Store, ≤170)**
A logic coach that shows where to look and why, levels graded by technique, guided lessons, a review of every game and a daily puzzle, the same for everyone.

**Keywords (App Store, ≤100)**
classic,9x9,grid,mind,teaser,daily,learn,lessons,tutor,tips,deduction,training,offline,hard,expert

**Full description**
Sudoku Sagax is a sudoku number puzzle with a logic coach: fill the 9×9 grid with the digits 1 to 9 using logic alone, and learn the techniques that solve it — no guessing, no maths.

HOW TO PLAY
Place the digits 1 to 9 so that every row, column and 3×3 box contains each one exactly once. Tap a cell, then a number, or pick a number first and tap every cell it goes in; turn on Notes to pencil in a cell's candidates. A logic puzzle and brain game with a clean, modern design.

LEARN TO SOLVE, ONE TECHNIQUE AT A TIME
• Logic coach: stuck? A hint first shows where to look, then why — the cells, the candidates and the technique, from hidden singles to the X-Wing — and only then places the digit (+30 s)
• Levels graded by technique: each level needs one technique and nothing harder, so every puzzle is solved by logic, never by guessing, with steps the coach can explain
• Eight guided lessons, one per technique, on real boards: the app explains, you make the move.
• Game review: after a win, see the techniques the puzzle needed and each of your hints and mistakes, with the step that was available just before it

A PUZZLE A DAY, AND ONE TO SHARE
• Daily puzzle: the same grid for everyone each day, easier early in the week and harder at the weekend, with a streak and a calendar of the days solved
• Share a puzzle: send a friend the code of a grid you solved, with your time; they paste it into the app to play the same puzzle

NINE LEVELS, BEGINNER TO EXPERT
• Levels 1–5, Beginner to Medium: singles, one deduction at a time
• Level 6, Medium: pointing pairs and box-line reductions
• Levels 7–8, Hard: pairs, then triples
• Level 9, Expert: the X-Wing
From 46 down to 24 given numbers, always with a unique solution, and a different puzzle every game.

FEATURES
• Notes, with Fill notes to pencil in every candidate at once on the harder levels
• Undo and redo
• Mark conflicts, and Show errors (optional, off by default)
• Leave a game at any time and continue it later
• Statistics per level: games solved, fastest and average time, wins without hints or mistakes, day streak
• Scoreboard per level: your 10 fastest times
• Accessibility: screen reader labels for every cell and key, shapes as well as colours, a high contrast option, your device's text size and a left-handed layout
• Light and dark themes: follow your device or choose one
• Timer with pause — or switch it off
• Relaxing music, sound effects and vibration (each can be turned off)
• Designed for phones and tablets, upright or sideways
• Play offline, anywhere — no internet connection needed
• In English, Portuguese, Spanish, French and German

THE SCIENCE BEHIND IT
Sudoku is pure deduction: no arithmetic, just logic. Large studies link regular number-puzzle play with better attention, reasoning and memory, and long-term research associates mentally stimulating games with healthier cognitive ageing. Research on puzzle difficulty also shows that the logic steps a puzzle needs predict how hard it is far better than its number of givens: that is how the levels are graded. The app's Info screen summarises the science, with full scientific references.

Sudoku Sagax is for anyone who enjoys sudoku, number puzzles, logic games and brain teasers; play for two minutes or twenty, at your own pace.

A Sagax Games title. Developed by Tekinsight — Information Technologies.

**App Store only: add at the end of the FEATURES list** (Game Center and iPhone Duo are iOS features)
• Game Center leaderboards (each level and the daily puzzle) and 14 achievements
• Made for iPhone Duo: the grid on one side of the fold, the controls on the other

**Google Play only, once Play Games is live: add at the end of the FEATURES list**
• Google Play Games leaderboards (each level and the daily puzzle) and 14 achievements

**What's new (release notes)**
Learn to solve like an expert: a logic coach that shows where to look and why, levels graded by technique, eight guided lessons and a review of every game. Plus a daily puzzle with a streak, puzzles to share with friends, save and continue, statistics, redo, fill notes, mark conflicts, screen reader support, high contrast, a light theme, and Game Center leaderboards and achievements. Thank you for playing!

---

## 🇵🇹 Português de Portugal (pt-PT)

**Nome da app (App Store e Google Play, ≤30)**
Sudoku Sagax: Jogo de Números

**Subtítulo (App Store, ≤30)**
Puzzle de Lógica com Treinador

**Descrição curta (Play Store, ≤80)**
Puzzle de lógica e raciocínio, com um treinador que explica cada ajuda.

**Texto promocional (App Store, ≤170)**
Um treinador de lógica que mostra onde olhar e porquê, níveis graduados por técnica, lições guiadas, a revisão de cada jogo e um puzzle diário, igual para todos.

**Palavras-chave (App Store, ≤100)**
raciocínio,clássico,cérebro,quebra-cabeça,diário,lições,aprender,grelha,9x9,mental,memória,foco

**Descrição completa**
O Sudoku Sagax é um puzzle de números com um treinador de lógica: preenche a grelha 9×9 com os algarismos de 1 a 9 apenas com lógica, e aprende as técnicas que a resolvem — sem adivinhar e sem contas.

COMO JOGAR
Coloca os algarismos de 1 a 9 de modo que cada linha, cada coluna e cada quadrado 3×3 os contenha uma única vez. Toca numa célula e depois num número, ou escolhe primeiro um número e toca em todas as células onde vai; liga as Notas para marcar os candidatos de uma célula. Um jogo de lógica e raciocínio, com um design limpo e moderno.

APRENDE A RESOLVER, UMA TÉCNICA DE CADA VEZ
• Treinador de lógica: não sabes como avançar? A ajuda mostra primeiro onde olhar, depois porquê — as células, os candidatos e a técnica, da única posição ao X-Wing — e só então coloca o número (+30 s)
• Níveis graduados por técnica: cada nível pede uma técnica e nada mais difícil, por isso cada puzzle resolve-se com lógica, nunca a adivinhar, com passos que o treinador sabe explicar
• Oito lições guiadas, uma por técnica, em tabuleiros reais: a app explica, tu fazes a jogada.
• Revisão do jogo: depois de ganhares, vê as técnicas que o puzzle pedia e cada uma das tuas ajudas e erros, com o passo que estava disponível logo antes

UM PUZZLE POR DIA, E OUTRO PARA PARTILHAR
• Puzzle diário: a mesma grelha para todos, todos os dias, mais fácil no início da semana e mais difícil ao fim de semana, com uma sequência e um calendário dos dias resolvidos
• Partilha um puzzle: envia a um amigo o código de uma grelha que resolveste, com o teu tempo; ele cola-o na app para jogar o mesmo puzzle

NOVE NÍVEIS, DE INICIANTE A ESPECIALISTA
• Níveis 1–5, de Iniciante a Médio: únicos, uma dedução de cada vez
• Nível 6, Médio: pares apontadores e reduções linha-quadrado
• Níveis 7–8, Difícil: pares, depois trios
• Nível 9, Especialista: o X-Wing
De 46 a 24 números dados, sempre com solução única, e um puzzle diferente em cada jogo.

FUNCIONALIDADES
• Notas, com Preencher notas para marcar todos os candidatos de uma vez nos níveis mais difíceis
• Desfazer e refazer
• Marcar conflitos, e Mostrar erros (opcional, desligado por predefinição)
• Sai a meio de um jogo e continua-o mais tarde
• Estatísticas por nível: jogos resolvidos, tempo mais rápido e médio, vitórias sem ajudas nem erros, sequência de dias
• Recordes por nível: os teus 10 tempos mais rápidos
• Acessibilidade: etiquetas para leitor de ecrã em cada célula e tecla, formas além das cores, opção de alto contraste, o tamanho de texto do teu dispositivo e modo canhoto
• Tema claro e escuro: segue o dispositivo ou escolhe um
• Cronómetro com pausa — ou desliga-o
• Música relaxante, efeitos sonoros e vibração (cada um pode ser desligado)
• Pensado para telemóveis e tablets, na vertical ou na horizontal
• Joga offline, em qualquer lugar — não precisas de internet
• Em português, inglês, espanhol, francês e alemão

A CIÊNCIA POR TRÁS
O sudoku é dedução pura: não há contas, só lógica. Grandes estudos associam a prática regular de puzzles numéricos a melhor atenção, raciocínio e memória, e a investigação de longo prazo associa jogos mentalmente estimulantes a um envelhecimento cognitivo mais saudável. A investigação sobre a dificuldade dos puzzles mostra também que os passos de lógica que um puzzle pede preveem a sua dificuldade muito melhor do que o número de dados: é assim que os níveis são graduados. O ecrã Info da app resume a ciência, com as referências científicas completas.

O Sudoku Sagax é para quem gosta de sudoku, puzzles de números, jogos de lógica e quebra-cabeças; joga dois minutos ou vinte, ao teu ritmo.

Um título Sagax Games. Desenvolvido pela Tekinsight — Tecnologias de Informação.

**App Store only: add at the end of the FEATURES list** (Game Center and iPhone Duo are iOS features)
• Classificações do Game Center (cada nível e o puzzle diário) e 14 conquistas
• Pensado para o iPhone Duo: a grelha de um lado da dobra e os controlos do outro

**Google Play only, once Play Games is live: add at the end of the FEATURES list**
• Classificações do Google Play Games (cada nível e o puzzle diário) e 14 conquistas

**Novidades (notas de versão)**
Aprende a resolver como um especialista: um treinador de lógica que mostra onde olhar e porquê, níveis graduados por técnica, oito lições guiadas e a revisão de cada jogo. E ainda um puzzle diário com sequência, puzzles para partilhar com amigos, guardar e continuar, estatísticas, refazer, preencher notas, marcar conflitos, leitor de ecrã, alto contraste, tema claro, e classificações e conquistas do Game Center. Obrigado por jogares!

---

## 🇩🇪 Deutsch (de-DE)

**App-Name (App Store und Google Play, ≤30)**
Sudoku Sagax: Zahlenrätsel

**Untertitel (App Store, ≤30)**
Logik-Trainer & Gehirnjogging

**Kurzbeschreibung (Play Store, ≤80)**
Logikspiel & Gehirnjogging mit einem Logik-Trainer, der jeden Tipp erklärt.

**Werbetext (App Store, ≤170)**
Ein Logik-Trainer, der zeigt, wo du schauen sollst und warum, nach Technik gestufte Level, geführte Lektionen, ein Rückblick auf jedes Spiel und ein Tagesrätsel für alle.

**Schlüsselwörter (App Store, ≤100)**
täglich,lernen,denkspiel,logikrätsel,knobelspiel,klassisch,zahlen,rätsel,9x9,gehirn,offline,training

**Vollständige Beschreibung**
Sudoku Sagax ist ein Zahlenrätsel mit Logik-Trainer: Fülle das 9×9-Gitter mit den Ziffern 1 bis 9, allein mit Logik, und lerne die Techniken, die es lösen — ohne Raten und ohne Rechnen.

SO WIRD GESPIELT
Setze die Ziffern 1 bis 9 so, dass jede Zeile, jede Spalte und jeder 3×3-Block jede Ziffer genau einmal enthält. Tippe auf ein Feld und dann auf eine Zahl, oder wähle zuerst eine Zahl und tippe auf alle Felder, in die sie gehört; schalte die Notizen ein, um die Kandidaten eines Feldes vorzumerken. Ein Logikspiel und Gehirnjogging in klarem, modernem Design.

LÖSEN LERNEN, TECHNIK FÜR TECHNIK
• Logik-Trainer: Du kommst nicht weiter? Ein Tipp zeigt zuerst, wo du schauen sollst, dann warum — die Felder, die Kandidaten und die Technik, vom versteckten Single bis zum X-Wing — und setzt erst dann die Zahl (+30 s)
• Nach Technik gestufte Level: Jedes Level braucht eine Technik und nichts Schwierigeres, also ist jedes Rätsel mit Logik lösbar, nie durch Raten, mit Schritten, die der Trainer erklären kann
• Acht geführte Lektionen, eine pro Technik, auf echten Spielfeldern: Die App erklärt, du machst den Zug.
• Spielrückblick: Nach einem Sieg siehst du die Techniken, die das Rätsel brauchte, und jeden deiner Tipps und Fehler, mit dem Schritt, der kurz davor möglich war

EIN RÄTSEL AM TAG, UND EINS ZUM TEILEN
• Tagesrätsel: jeden Tag dasselbe Gitter für alle, am Wochenanfang leichter, am Wochenende schwerer, mit einer Serie und einem Kalender der gelösten Tage
• Rätsel teilen: Schicke einem Freund den Code eines gelösten Gitters mit deiner Zeit; er fügt ihn in der App ein und spielt dasselbe Rätsel

NEUN LEVEL, VOM ANFÄNGER ZUM EXPERTEN
• Level 1–5, Anfänger bis Mittel: Singles, ein Schluss nach dem anderen
• Level 6, Mittel: zeigende Paare und Linie-Block-Reduktionen
• Level 7–8, Schwer: Paare, dann Tripel
• Level 9, Experte: der X-Wing
Von 46 bis 24 vorgegebenen Zahlen, immer mit eindeutiger Lösung, und jedes Spiel ein anderes Rätsel.

FUNKTIONEN
• Notizen, mit „Notizen füllen“, um in den schwereren Leveln alle Kandidaten auf einmal einzutragen
• Rückgängig und Wiederholen
• Konflikte markieren und Fehler anzeigen (optional, standardmäßig aus)
• Ein Spiel jederzeit verlassen und später fortsetzen
• Statistik pro Level: gelöste Spiele, schnellste und mittlere Zeit, Siege ohne Tipps oder Fehler, Tagesserie
• Bestenliste pro Level: deine 10 schnellsten Zeiten
• Barrierefreiheit: Screenreader-Beschriftungen für jedes Feld und jede Taste, Formen zusätzlich zu Farben, eine Option für hohen Kontrast, die Textgröße deines Geräts und ein Linkshänder-Layout
• Helles und dunkles Design: folgt deinem Gerät, oder du wählst eines
• Stoppuhr mit Pause — oder ausschalten
• Entspannende Musik, Soundeffekte und Vibration (jeweils abschaltbar)
• Für Smartphones und Tablets gestaltet, hochkant oder quer
• Spiele offline, überall — ohne Internetverbindung
• Auf Deutsch, Englisch, Portugiesisch, Spanisch und Französisch

DIE WISSENSCHAFT DAHINTER
Sudoku ist reines Schlussfolgern: kein Rechnen, nur Logik. Große Studien bringen regelmäßiges Lösen von Zahlenrätseln mit besserer Aufmerksamkeit, besserem logischem Denken und Gedächtnis in Verbindung, und Langzeitforschung verbindet geistig anregende Spiele mit gesünderem kognitivem Altern. Forschung zur Schwierigkeit von Rätseln zeigt außerdem, dass die Logikschritte, die ein Rätsel braucht, seine Schwierigkeit viel besser vorhersagen als die Zahl der Vorgaben: Danach sind die Level gestuft. Der Info-Bildschirm der App fasst die Wissenschaft zusammen, mit vollständigen Quellenangaben.

Sudoku Sagax ist für alle, die Sudoku, Zahlenrätsel, Logikrätsel und Knobelspiele mögen; spiele zwei Minuten oder zwanzig, in deinem Tempo.

Ein Titel von Sagax Games. Entwickelt von Tekinsight — Informationstechnologien.

**App Store only: add at the end of the FEATURES list** (Game Center and iPhone Duo are iOS features)
• Game-Center-Bestenlisten (jedes Level und das Tagesrätsel) und 14 Erfolge
• Für das iPhone Duo gestaltet: das Gitter auf der einen Seite der Faltkante, die Steuerung auf der anderen

**Google Play only, once Play Games is live: add at the end of the FEATURES list**
• Google-Play-Games-Bestenlisten (jedes Level und das Tagesrätsel) und 14 Erfolge

**Neuigkeiten (Versionshinweise)**
Lösen lernen wie ein Profi: ein Logik-Trainer, der zeigt, wo du schauen sollst und warum, nach Technik gestufte Level, acht geführte Lektionen und ein Rückblick auf jedes Spiel. Dazu ein Tagesrätsel mit Serie, Rätsel zum Teilen mit Freunden, Spiel speichern und fortsetzen, Statistik, Wiederholen, Notizen füllen, Konflikte markieren, Screenreader-Unterstützung, hoher Kontrast, ein helles Design sowie Game-Center-Bestenlisten und -Erfolge. Danke fürs Spielen!

---

## 🇪🇸 Español de España (es-ES)

**Nombre de la app (App Store y Google Play, ≤30)**
Sudoku Sagax: Juego de Números

**Subtítulo (App Store, ≤30)**
Entrenador de Lógica y Mente

**Descripción breve (Play Store, ≤80)**
Rompecabezas de lógica y números con un entrenador que explica cada pista.

**Texto promocional (App Store, ≤170)**
Un entrenador de lógica que muestra dónde mirar y por qué, niveles graduados por técnica, lecciones guiadas, la revisión de cada partida y un puzle diario para todos.

**Palabras clave (App Store, ≤100)**
rompecabezas,puzle,clásico,diario,lecciones,aprender,cerebro,cuadrícula,9x9,memoria,acertijo,offline

**Descripción completa**
Sudoku Sagax es un rompecabezas de números con un entrenador de lógica: completa la cuadrícula de 9×9 con los dígitos del 1 al 9 solo con lógica y aprende las técnicas que la resuelven, sin adivinar y sin hacer cuentas.

CÓMO SE JUEGA
Coloca los dígitos del 1 al 9 de modo que cada fila, cada columna y cada caja de 3×3 los contenga una sola vez. Toca una celda y luego un número, o elige primero un número y toca todas las celdas donde va; activa las Notas para anotar los candidatos de una celda. Un juego mental de lógica pura, con un diseño limpio y moderno.

APRENDE A RESOLVER, TÉCNICA A TÉCNICA
• Entrenador de lógica: ¿atascado? Una pista te muestra primero dónde mirar y después por qué (las celdas, los candidatos y la técnica, del único oculto al X-Wing), y solo entonces coloca el número (+30 s)
• Niveles graduados por técnica: cada nivel pide una técnica y nada más difícil, así que cada puzle se resuelve con lógica, nunca adivinando, con pasos que el entrenador sabe explicar
• Ocho lecciones guiadas, una por técnica, en tableros reales: la app explica, tú haces la jugada.
• Revisión de la partida: tras ganar, mira las técnicas que pedía el puzle y cada una de tus pistas y errores, con el paso que estaba disponible justo antes

UN PUZLE AL DÍA, Y OTRO PARA COMPARTIR
• Puzle diario: la misma cuadrícula para todos cada día, más fácil a principios de semana y más difícil el fin de semana, con una racha y un calendario de los días resueltos
• Comparte un puzle: envía a un amigo el código de una cuadrícula que hayas resuelto, con tu tiempo; lo pega en la app y juega el mismo puzle

NUEVE NIVELES, DE PRINCIPIANTE A EXPERTO
• Niveles 1–5, de Principiante a Medio: únicos, deducción a deducción
• Nivel 6, Medio: parejas apuntadoras y reducciones línea-caja
• Niveles 7–8, Difícil: parejas y luego tríos
• Nivel 9, Experto: el X-Wing
De 46 a 24 números dados, siempre con solución única, y un puzle distinto en cada partida.

CARACTERÍSTICAS
• Notas, con Rellenar notas para anotar todos los candidatos de una vez en los niveles más difíciles
• Deshacer y rehacer
• Marcar conflictos, y Mostrar errores (opcional, desactivado por defecto)
• Deja una partida cuando quieras y continúala más tarde
• Estadísticas por nivel: partidas resueltas, tiempo más rápido y medio, victorias sin pistas ni errores, racha de días
• Récords por nivel: tus 10 tiempos más rápidos
• Accesibilidad: etiquetas para lector de pantalla en cada celda y tecla, formas además de colores, opción de alto contraste, el tamaño de texto de tu dispositivo y modo zurdo
• Tema claro y oscuro: sigue a tu dispositivo o elige uno
• Cronómetro con pausa, o desactívalo
• Música relajante, efectos de sonido y vibración (cada uno se puede desactivar)
• Pensado para móviles y tabletas, en vertical u horizontal
• Juega sin conexión, donde quieras: no necesitas internet
• En español, inglés, portugués, francés y alemán

LA CIENCIA DETRÁS
El sudoku es deducción pura: sin cálculos, solo lógica. Grandes estudios relacionan la práctica habitual de puzles numéricos con mejor atención, razonamiento y memoria, y la investigación a largo plazo asocia los juegos mentalmente estimulantes con un envejecimiento cognitivo más saludable. La investigación sobre la dificultad de los puzles muestra además que los pasos lógicos que pide un puzle predicen su dificultad mucho mejor que la cantidad de números dados: así se gradúan los niveles. La pantalla Info de la app resume la ciencia con sus referencias completas.

Sudoku Sagax es para quien disfruta del sudoku, los puzles de números, los juegos de lógica y los rompecabezas; juega dos minutos o veinte, a tu ritmo.

Un título de Sagax Games. Desarrollado por Tekinsight — Tecnologías de la Información.

**App Store only: add at the end of the FEATURES list** (Game Center and iPhone Duo are iOS features)
• Clasificaciones de Game Center (cada nivel y el puzle diario) y 14 logros
• Diseñado para el iPhone Duo: la cuadrícula a un lado del pliegue y los controles al otro

**Google Play only, once Play Games is live: add at the end of the FEATURES list**
• Clasificaciones de Google Play Games (cada nivel y el puzle diario) y 14 logros

**Novedades (notas de la versión)**
Aprende a resolver como un experto: un entrenador de lógica que muestra dónde mirar y por qué, niveles graduados por técnica, ocho lecciones guiadas y la revisión de cada partida. Además, un puzle diario con racha, puzles para compartir con amigos, guardar y continuar, estadísticas, rehacer, rellenar notas, marcar conflictos, lector de pantalla, alto contraste, tema claro, y clasificaciones y logros de Game Center. ¡Gracias por jugar!

---

## 🇫🇷 Français (fr-FR)

**Nom de l'app (App Store et Google Play, ≤30)**
Sudoku Sagax : Jeu de Chiffres

**Sous-titre (App Store, ≤30)**
Entraîneur de logique & défis

**Description courte (Play Store, ≤80)**
Casse-tête de logique avec un entraîneur qui explique chaque indice.

**Texte promotionnel (App Store, ≤170)**
Un entraîneur de logique qui montre où regarder et pourquoi, des niveaux gradués par technique, des leçons guidées, le bilan de chaque partie et une grille du jour.

**Mots-clés (App Store, ≤100)**
casse-tête,réflexion,classique,quotidien,apprendre,cerveau,grille,9x9,mémoire,déduction,hors,ligne

**Description complète**
Sudoku Sagax est un casse-tête de chiffres avec un entraîneur de logique : remplissez la grille 9×9 avec les chiffres de 1 à 9 par la seule logique, et apprenez les techniques qui la résolvent — sans deviner, sans calcul.

COMMENT JOUER
Placez les chiffres de 1 à 9 de sorte que chaque ligne, chaque colonne et chaque carré 3×3 les contienne une seule fois. Touchez une case, puis un chiffre, ou choisissez d'abord un chiffre et touchez toutes les cases où il va ; activez les Notes pour inscrire les candidats d'une case. Un jeu de logique et de réflexion, au design épuré et moderne.

APPRENDRE À RÉSOUDRE, UNE TECHNIQUE À LA FOIS
• Entraîneur de logique : bloqué ? Un indice montre d'abord où regarder, puis pourquoi — les cases, les candidats et la technique, du singleton caché au X-Wing — avant de placer le chiffre (+30 s)
• Niveaux gradués par technique : chaque niveau demande une technique et rien de plus difficile, donc chaque grille se résout par la logique, jamais au hasard
• Huit leçons guidées, une par technique, sur de vraies grilles : l'app explique, vous jouez le coup.
• Bilan de la partie : après une victoire, voyez les techniques que la grille demandait et chacun de vos indices et erreurs, avec l'étape possible juste avant

UNE GRILLE PAR JOUR, ET UNE À PARTAGER
• Grille du jour : la même grille pour tout le monde chaque jour, plus facile en début de semaine et plus difficile le week-end, avec une série et un calendrier des jours résolus
• Partagez une grille : envoyez à un ami le code d'une grille résolue, avec votre temps ; il le colle dans l'app pour jouer la même grille

NEUF NIVEAUX, DE DÉBUTANT À EXPERT
• Niveaux 1–5, de Débutant à Moyen : singletons, une déduction à la fois
• Niveau 6, Moyen : paires pointantes et réductions ligne-carré
• Niveaux 7–8, Difficile : paires, puis triplets
• Niveau 9, Expert : le X-Wing
De 46 à 24 chiffres donnés, toujours avec une solution unique, et une grille différente à chaque partie.

FONCTIONNALITÉS
• Notes, avec Remplir les notes pour inscrire tous les candidats d'un coup aux niveaux difficiles
• Annuler et rétablir
• Signaler les conflits, et Afficher les erreurs (en option, désactivé par défaut)
• Quittez une partie à tout moment et reprenez-la plus tard
• Statistiques par niveau : parties résolues, temps le plus rapide et moyen, victoires sans indice ni erreur, série de jours
• Records par niveau : vos 10 temps les plus rapides
• Accessibilité : libellés pour lecteur d'écran sur chaque case et touche, formes en plus des couleurs, option de contraste élevé, la taille de texte de votre appareil et mode gaucher
• Thème clair et sombre : suivez votre appareil ou choisissez
• Chronomètre avec pause — ou désactivez-le
• Musique relaxante, effets sonores et vibrations (chacun désactivable)
• Conçu pour téléphones et tablettes, à la verticale ou à l'horizontale
• Jouez hors ligne, partout — sans connexion Internet
• En français, anglais, portugais, espagnol et allemand

LA SCIENCE DERRIÈRE LE JEU
Le sudoku, c'est de la déduction pure : aucun calcul, seulement de la logique. De grandes études associent la pratique régulière des casse-têtes numériques à une meilleure attention, un meilleur raisonnement et une meilleure mémoire, et la recherche à long terme relie les jeux stimulants à un vieillissement cognitif en meilleure santé. La recherche montre aussi que les étapes logiques qu'une grille demande prédisent sa difficulté bien mieux que le nombre de chiffres donnés : les niveaux sont gradués ainsi. L'écran Info de l'app résume la science, avec les références complètes.

Sudoku Sagax s'adresse à tous ceux qui aiment le sudoku, les casse-têtes de chiffres, les jeux de logique et les énigmes ; jouez deux minutes ou vingt, à votre rythme.

Un titre Sagax Games. Développé par Tekinsight — Technologies de l'Information.

**App Store only: add at the end of the FEATURES list** (Game Center and iPhone Duo are iOS features)
• Classements Game Center (chaque niveau et la grille du jour) et 14 succès
• Conçu pour l'iPhone Duo : la grille d'un côté du pli, les commandes de l'autre

**Google Play only, once Play Games is live: add at the end of the FEATURES list**
• Classements Google Play Games (chaque niveau et la grille du jour) et 14 succès

**Nouveautés (notes de version)**
Apprenez à résoudre comme un expert : un entraîneur de logique qui montre où regarder et pourquoi, des niveaux gradués par technique, huit leçons guidées et le bilan de chaque partie. Et aussi une grille du jour avec série, des grilles à partager entre amis, la sauvegarde de la partie, des statistiques, rétablir, remplir les notes, signaler les conflits, le lecteur d'écran, le contraste élevé, un thème clair, et les classements et succès Game Center. Merci de jouer !

---

## 🇺🇸 English (US) (en-US)

**App name (App Store and Google Play, ≤30)**
Sudoku Sagax: Number Puzzle

**Subtitle (App Store, ≤30)**
Logic Coach & Brain Game

**Short description (Play Store, ≤80)**
Number puzzle & brain game with a logic coach that explains every hint.

**Promotional text (App Store, ≤170)**
A logic coach that shows where to look and why, levels graded by technique, guided lessons, a review of every game and a daily puzzle, the same for everyone.

**Keywords (App Store, ≤100)**
classic,9x9,grid,mind,teaser,daily,learn,lessons,tutor,tips,deduction,training,offline,hard,expert

**Full description**
Sudoku Sagax is a sudoku number puzzle with a logic coach: fill the 9×9 grid with the digits 1 to 9 using logic alone, and learn the techniques that solve it — no guessing, no math.

HOW TO PLAY
Place the digits 1 to 9 so that every row, column and 3×3 box contains each one exactly once. Tap a cell, then a number, or pick a number first and tap every cell it goes in; turn on Notes to pencil in a cell's candidates. A logic puzzle and brain game with a clean, modern design.

LEARN TO SOLVE, ONE TECHNIQUE AT A TIME
• Logic coach: stuck? A hint first shows where to look, then why — the cells, the candidates and the technique, from hidden singles to the X-Wing — and only then places the digit (+30 s)
• Levels graded by technique: each level needs one technique and nothing harder, so every puzzle is solved by logic, never by guessing, with steps the coach can explain
• Eight guided lessons, one per technique, on real boards: the app explains, you make the move.
• Game review: after a win, see the techniques the puzzle needed and each of your hints and mistakes, with the step that was available just before it

A PUZZLE A DAY, AND ONE TO SHARE
• Daily puzzle: the same grid for everyone each day, easier early in the week and harder on the weekend, with a streak and a calendar of the days solved
• Share a puzzle: send a friend the code of a grid you solved, with your time; they paste it into the app to play the same puzzle

NINE LEVELS, BEGINNER TO EXPERT
• Levels 1–5, Beginner to Medium: singles, one deduction at a time
• Level 6, Medium: pointing pairs and box-line reductions
• Levels 7–8, Hard: pairs, then triples
• Level 9, Expert: the X-Wing
From 46 down to 24 given numbers, always with a unique solution, and a different puzzle every game.

FEATURES
• Notes, with Fill notes to pencil in every candidate at once on the harder levels
• Undo and redo
• Mark conflicts, and Show errors (optional, off by default)
• Leave a game at any time and continue it later
• Statistics per level: games solved, fastest and average time, wins without hints or mistakes, day streak
• Scoreboard per level: your 10 fastest times
• Accessibility: screen reader labels for every cell and key, shapes as well as colors, a high contrast option, your device's text size and a left-handed layout
• Light and dark themes: follow your device or choose one
• Timer with pause — or switch it off
• Relaxing music, sound effects and vibration (each can be turned off)
• Designed for phones and tablets, upright or sideways
• Play offline, anywhere — no internet connection needed
• In English, Portuguese, Spanish, French and German

THE SCIENCE BEHIND IT
Sudoku is pure deduction: no arithmetic, just logic. Large studies link regular number-puzzle play with better attention, reasoning and memory, and long-term research associates mentally stimulating games with healthier cognitive aging. Research on puzzle difficulty also shows that the logic steps a puzzle needs predict how hard it is far better than its number of givens: that is how the levels are graded. The app's Info screen summarizes the science, with full scientific references.

Sudoku Sagax is for anyone who enjoys sudoku, number puzzles, logic games and brain teasers; play for two minutes or twenty, at your own pace.

A Sagax Games title. Developed by Tekinsight — Information Technologies.

**App Store only: add at the end of the FEATURES list** (Game Center and iPhone Duo are iOS features)
• Game Center leaderboards (each level and the daily puzzle) and 14 achievements
• Made for iPhone Duo: the grid on one side of the fold, the controls on the other

**Google Play only, once Play Games is live: add at the end of the FEATURES list**
• Google Play Games leaderboards (each level and the daily puzzle) and 14 achievements

**What's new (release notes)**
Learn to solve like an expert: a logic coach that shows where to look and why, levels graded by technique, eight guided lessons and a review of every game. Plus a daily puzzle with a streak, puzzles to share with friends, save and continue, statistics, redo, fill notes, mark conflicts, screen reader support, high contrast, a light theme, and Game Center leaderboards and achievements. Thank you for playing!

---

## 🇧🇷 Português do Brasil (pt-BR)

**Nome do app (App Store e Google Play, ≤30)**
Sudoku Sagax: Jogo de Números

**Subtítulo (App Store, ≤30)**
Treinador de Lógica e Mente

**Descrição curta (Play Store, ≤80)**
Quebra-cabeça de lógica com um treinador que explica cada ajuda.

**Texto promocional (App Store, ≤170)**
Um treinador de lógica que mostra onde olhar e por quê, níveis graduados por técnica, lições guiadas, a revisão de cada partida e um puzzle diário, igual para todos.

**Palavras-chave (App Store, ≤100)**
quebra-cabeça,raciocínio,clássico,diário,lições,aprender,cérebro,grade,9x9,memória,foco,desafio

**Descrição completa**
O Sudoku Sagax é um quebra-cabeça de números com um treinador de lógica: preencha a grade 9×9 com os algarismos de 1 a 9 usando só a lógica, e aprenda as técnicas que a resolvem — sem chutar e sem fazer contas.

COMO JOGAR
Coloque os algarismos de 1 a 9 de modo que cada linha, cada coluna e cada quadrado 3×3 tenha cada um deles uma única vez. Toque em uma célula e depois em um número, ou escolha primeiro um número e toque em todas as células onde ele vai; ative as Notas para marcar os candidatos de uma célula. Um jogo de lógica e raciocínio, com um visual limpo e moderno.

APRENDA A RESOLVER, UMA TÉCNICA POR VEZ
• Treinador de lógica: travou? A ajuda mostra primeiro onde olhar, depois por quê — as células, os candidatos e a técnica, da única posição ao X-Wing — e só então coloca o número (+30 s)
• Níveis graduados por técnica: cada nível pede uma técnica e nada mais difícil, então cada quebra-cabeça se resolve com lógica, nunca no chute, com passos que o treinador sabe explicar
• Oito lições guiadas, uma por técnica, em tabuleiros reais: o app explica, você faz a jogada.
• Revisão do jogo: depois de vencer, veja as técnicas que o quebra-cabeça pedia e cada uma das suas ajudas e erros, com o passo que estava disponível logo antes

UM QUEBRA-CABEÇA POR DIA, E OUTRO PARA COMPARTILHAR
• Puzzle diário: a mesma grade para todos, todos os dias, mais fácil no começo da semana e mais difícil no fim de semana, com uma sequência e um calendário dos dias resolvidos
• Compartilhe um quebra-cabeça: envie a um amigo o código de uma grade que você resolveu, com o seu tempo; ele cola no app para jogar o mesmo quebra-cabeça

NOVE NÍVEIS, DO INICIANTE AO ESPECIALISTA
• Níveis 1–5, do Iniciante ao Médio: únicos, uma dedução por vez
• Nível 6, Médio: pares apontadores e reduções linha-quadrado
• Níveis 7–8, Difícil: pares, depois trios
• Nível 9, Especialista: o X-Wing
De 46 a 24 números dados, sempre com solução única, e um quebra-cabeça diferente a cada partida.

RECURSOS
• Notas, com Preencher notas para marcar todos os candidatos de uma vez nos níveis mais difíceis
• Desfazer e refazer
• Marcar conflitos, e Mostrar erros (opcional, desligado por padrão)
• Saia de uma partida quando quiser e continue depois
• Estatísticas por nível: partidas resolvidas, tempo mais rápido e médio, vitórias sem ajudas nem erros, sequência de dias
• Recordes por nível: seus 10 tempos mais rápidos
• Acessibilidade: rótulos para leitor de tela em cada célula e tecla, formas além das cores, opção de alto contraste, o tamanho de texto do seu aparelho e modo canhoto
• Tema claro e escuro: segue o aparelho ou escolha um
• Cronômetro com pausa — ou desligue-o
• Música relaxante, efeitos sonoros e vibração (cada um pode ser desligado)
• Feito para celulares e tablets, na vertical ou na horizontal
• Jogue offline, em qualquer lugar — sem precisar de internet
• Em português, inglês, espanhol, francês e alemão

A CIÊNCIA POR TRÁS
O sudoku é dedução pura: não há contas, só lógica. Grandes estudos associam a prática regular de quebra-cabeças numéricos a melhor atenção, raciocínio e memória, e pesquisas de longo prazo associam jogos mentalmente estimulantes a um envelhecimento cognitivo mais saudável. Pesquisas sobre a dificuldade dos quebra-cabeças mostram também que os passos de lógica que um quebra-cabeça pede preveem a sua dificuldade muito melhor do que a quantidade de números dados: é assim que os níveis são graduados. A tela Info do app resume a ciência, com as referências científicas completas.

O Sudoku Sagax é para quem gosta de sudoku, jogos de números, jogos de lógica e quebra-cabeças; jogue dois minutos ou vinte, no seu ritmo.

Um título Sagax Games. Desenvolvido pela Tekinsight — Tecnologias da Informação.

**App Store only: add at the end of the FEATURES list** (Game Center and iPhone Duo are iOS features)
• Classificações do Game Center (cada nível e o puzzle diário) e 14 conquistas
• Feito para o iPhone Duo: a grade de um lado da dobra e os controles do outro

**Google Play only, once Play Games is live: add at the end of the FEATURES list**
• Classificações do Google Play Games (cada nível e o puzzle diário) e 14 conquistas

**Novidades (notas da versão)**
Aprenda a resolver como um especialista: um treinador de lógica que mostra onde olhar e por quê, níveis graduados por técnica, oito lições guiadas e a revisão de cada partida. E mais: um puzzle diário com sequência, quebra-cabeças para compartilhar com amigos, salvar e continuar, estatísticas, refazer, preencher notas, marcar conflitos, leitor de tela, alto contraste, tema claro, e classificações e conquistas do Game Center. Obrigado por jogar!

---

## 🌎 Español de Latinoamérica (es-419)

**Nombre de la app (App Store y Google Play, ≤30)**
Sudoku Sagax: Juego de Números

**Subtítulo (App Store, ≤30)**
Entrenador de Lógica y Mente

**Descripción breve (Play Store, ≤80)**
Rompecabezas de lógica y números con un entrenador que explica cada pista.

**Texto promocional (App Store, ≤170)**
Un entrenador de lógica que muestra dónde mirar y por qué, niveles graduados por técnica, lecciones guiadas, la revisión de cada partida y un puzle diario para todos.

**Palabras clave (App Store, ≤100)**
rompecabezas,clásico,diario,lecciones,aprender,cerebro,cuadrícula,9x9,memoria,acertijo,internet,reto

**Descripción completa**
Sudoku Sagax es un rompecabezas de números con un entrenador de lógica: completa la cuadrícula de 9×9 con los dígitos del 1 al 9 solo con lógica y aprende las técnicas que la resuelven, sin adivinar y sin hacer cuentas.

CÓMO SE JUEGA
Coloca los dígitos del 1 al 9 de modo que cada fila, cada columna y cada caja de 3×3 los contenga una sola vez. Toca una celda y luego un número, o elige primero un número y toca todas las celdas donde va; activa las Notas para anotar los candidatos de una celda. Un juego mental de lógica pura, con un diseño limpio y moderno.

APRENDE A RESOLVER, TÉCNICA POR TÉCNICA
• Entrenador de lógica: ¿no sabes cómo seguir? Una pista te muestra primero dónde mirar y después por qué (las celdas, los candidatos y la técnica, del único oculto al X-Wing), y solo entonces coloca el número (+30 s)
• Niveles graduados por técnica: cada nivel pide una técnica y nada más difícil, así que cada rompecabezas se resuelve con lógica, nunca adivinando, con pasos que el entrenador sabe explicar
• Ocho lecciones guiadas, una por técnica, en tableros reales: la app explica, tú haces la jugada.
• Revisión de la partida: después de ganar, mira las técnicas que pedía el rompecabezas y cada una de tus pistas y errores, con el paso que estaba disponible justo antes

UN ROMPECABEZAS AL DÍA, Y OTRO PARA COMPARTIR
• Puzle diario: la misma cuadrícula para todos cada día, más fácil a principios de semana y más difícil el fin de semana, con una racha y un calendario de los días resueltos
• Comparte un rompecabezas: envía a un amigo el código de una cuadrícula que hayas resuelto, con tu tiempo; lo pega en la app y juega el mismo rompecabezas

NUEVE NIVELES, DE PRINCIPIANTE A EXPERTO
• Niveles 1–5, de Principiante a Medio: únicos, deducción a deducción
• Nivel 6, Medio: parejas apuntadoras y reducciones línea-caja
• Niveles 7–8, Difícil: parejas y luego tríos
• Nivel 9, Experto: el X-Wing
De 46 a 24 números dados, siempre con solución única, y un rompecabezas distinto en cada partida.

CARACTERÍSTICAS
• Notas, con Rellenar notas para anotar todos los candidatos de una vez en los niveles más difíciles
• Deshacer y rehacer
• Marcar conflictos, y Mostrar errores (opcional, desactivado por defecto)
• Deja una partida cuando quieras y continúala más tarde
• Estadísticas por nivel: partidas resueltas, tiempo más rápido y promedio, victorias sin pistas ni errores, racha de días
• Récords por nivel: tus 10 tiempos más rápidos
• Accesibilidad: etiquetas para lector de pantalla en cada celda y tecla, formas además de colores, opción de alto contraste, el tamaño de texto de tu dispositivo y modo zurdo
• Tema claro y oscuro: sigue a tu dispositivo o elige uno
• Cronómetro con pausa, o desactívalo
• Música relajante, efectos de sonido y vibración (cada uno se puede desactivar)
• Pensado para celulares y tabletas, en vertical u horizontal
• Juega sin internet, donde quieras
• En español, inglés, portugués, francés y alemán

LA CIENCIA DETRÁS
El sudoku es deducción pura: sin cálculos, solo lógica. Grandes estudios relacionan la práctica habitual de rompecabezas numéricos con mejor atención, razonamiento y memoria, y la investigación a largo plazo asocia los juegos mentalmente estimulantes con un envejecimiento cognitivo más saludable. La investigación sobre la dificultad de los rompecabezas muestra además que los pasos lógicos que pide un rompecabezas predicen su dificultad mucho mejor que la cantidad de números dados: así se gradúan los niveles. La pantalla Info de la app resume la ciencia con sus referencias completas.

Sudoku Sagax es para quien disfruta del sudoku, los rompecabezas de números, los juegos de lógica y los acertijos; juega dos minutos o veinte, a tu ritmo.

Un título de Sagax Games. Desarrollado por Tekinsight — Tecnologías de la Información.

**App Store only: add at the end of the FEATURES list** (Game Center and iPhone Duo are iOS features)
• Clasificaciones de Game Center (cada nivel y el puzle diario) y 14 logros
• Diseñado para el iPhone Duo: la cuadrícula a un lado del pliegue y los controles al otro

**Google Play only, once Play Games is live: add at the end of the FEATURES list**
• Clasificaciones de Google Play Games (cada nivel y el puzle diario) y 14 logros

**Novedades (notas de la versión)**
Aprende a resolver como un experto: un entrenador de lógica que muestra dónde mirar y por qué, niveles graduados por técnica, ocho lecciones guiadas y la revisión de cada partida. Además, un puzle diario con racha, rompecabezas para compartir con amigos, guardar y continuar, estadísticas, rehacer, rellenar notas, marcar conflictos, lector de pantalla, alto contraste, tema claro, y clasificaciones y logros de Game Center. ¡Gracias por jugar!

---

## Release notes

All languages in the multi-language format that Google Play Console accepts in
a release's *Release notes* field: paste the block as-is (≤500 characters per
language). App Store Connect takes one language at a time — use the matching
*What's new* text from each language section above (they name Game Center).

The Play block leaves out leaderboards and achievements, because Play Games stays off until
its IDs are in the app. If it is live by the release, add "Google Play Games leaderboards and
achievements" (in each language, as in the Play-only lines above) before "Thank you for
playing", keeping each language under 500 characters.

**Version 1.1.0 (logic coach, levels graded by technique, lessons, game review, daily puzzle, sharing, save and resume, statistics, accessibility, light theme, Game Center)**

```
<en-GB>
Learn to solve like an expert: a logic coach that shows where to look and why, levels graded by technique, eight guided lessons and a review of every game. Plus a daily puzzle with a streak, puzzles to share with friends, save and continue, statistics, redo, fill notes, mark conflicts, screen reader support, high contrast and a light theme. Thank you for playing!
</en-GB>
<de-DE>
Lösen lernen wie ein Profi: ein Logik-Trainer, der zeigt, wo du schauen sollst und warum, nach Technik gestufte Level, acht geführte Lektionen und ein Rückblick auf jedes Spiel. Dazu ein Tagesrätsel mit Serie, Rätsel zum Teilen mit Freunden, Spiel speichern und fortsetzen, Statistik, Wiederholen, Notizen füllen, Konflikte markieren, Screenreader-Unterstützung, hoher Kontrast und ein helles Design. Danke fürs Spielen!
</de-DE>
<es-ES>
Aprende a resolver como un experto: un entrenador de lógica que muestra dónde mirar y por qué, niveles graduados por técnica, ocho lecciones guiadas y la revisión de cada partida. Además, un puzle diario con racha, puzles para compartir con amigos, guardar y continuar, estadísticas, rehacer, rellenar notas, marcar conflictos, lector de pantalla, alto contraste y tema claro. ¡Gracias por jugar!
</es-ES>
<fr-FR>
Apprenez à résoudre comme un expert : un entraîneur de logique qui montre où regarder et pourquoi, des niveaux gradués par technique, huit leçons guidées et le bilan de chaque partie. Et aussi une grille du jour avec série, des grilles à partager entre amis, la sauvegarde de la partie, des statistiques, rétablir, remplir les notes, signaler les conflits, le lecteur d'écran, le contraste élevé et un thème clair. Merci de jouer !
</fr-FR>
<pt-PT>
Aprende a resolver como um especialista: um treinador de lógica que mostra onde olhar e porquê, níveis graduados por técnica, oito lições guiadas e a revisão de cada jogo. E ainda um puzzle diário com sequência, puzzles para partilhar com amigos, guardar e continuar, estatísticas, refazer, preencher notas, marcar conflitos, leitor de ecrã, alto contraste e tema claro. Obrigado por jogares!
</pt-PT>
<en-US>
Learn to solve like an expert: a logic coach that shows where to look and why, levels graded by technique, eight guided lessons and a review of every game. Plus a daily puzzle with a streak, puzzles to share with friends, save and continue, statistics, redo, fill notes, mark conflicts, screen reader support, high contrast and a light theme. Thank you for playing!
</en-US>
<pt-BR>
Aprenda a resolver como um especialista: um treinador de lógica que mostra onde olhar e por quê, níveis graduados por técnica, oito lições guiadas e a revisão de cada partida. E mais: um puzzle diário com sequência, quebra-cabeças para compartilhar com amigos, salvar e continuar, estatísticas, refazer, preencher notas, marcar conflitos, leitor de tela, alto contraste e tema claro. Obrigado por jogar!
</pt-BR>
<es-419>
Aprende a resolver como un experto: un entrenador de lógica que muestra dónde mirar y por qué, niveles graduados por técnica, ocho lecciones guiadas y la revisión de cada partida. Además, un puzle diario con racha, rompecabezas para compartir con amigos, guardar y continuar, estadísticas, rehacer, rellenar notas, marcar conflictos, lector de pantalla, alto contraste y tema claro. ¡Gracias por jugar!
</es-419>
```

---

## App Store Connect — App Review information

App Review asks for six things with a submission (or in a reply when it holds one). Paste the
block below, as it is, in the version's **App Review Information → Notes** field (up to 4000
characters; this block fits), and as the **reply** to App Review in App Store Connect when it
asks. The 1.0 submission was held under *Guideline 2.1 – Information Needed* until Apple
received exactly these answers, so keep the block in the Notes field for every future
submission. Attach the screen recording to the reply. App Review reads English, so there are no
translations. Keep it in sync with the app when features change. Item 2 says plainly what the
app offers beyond a standard sudoku (Guideline 4.3), with the most distinctive features first.

Before pasting, fill in the iOS version in item 1 (`[XX.X]`) with the version the recording was
made on. Also set **Sign-in required: No** (leave the demo account off) and fill in the contact
details on the same page.

### Screen recording (item 1)

Record on a physical iPhone running the latest iOS, not the simulator (the store preview video
does not count either). Install the build through TestFlight (or a release build; see
[publishing.md, "Testing on a physical device"](publishing.md#testing-on-a-physical-device)),
add *Screen Recording* to Control Center, start recording from Control Center, then:

1. on the home screen, tap the Sudoku Sagax icon (the video must begin with the launch; if
   Game Center asks you to sign in, let it show and continue);
2. **Lessons**: open the first lesson, tap **Show me**, and make the move;
3. back home, **PLAY** a Beginner game through to the win: enter digits both ways (a cell then
   a number, and a number then cells), turn on Notes and tap the status line to fill notes (or
   show it on a level 6 game), tap **Hint** and go through its three stages (where to look,
   **Show me**, **Apply**), undo and redo, pause and resume;
4. on the win summary, tap **Review** and scroll through it; then **Share** and choose
   **Copy**;
5. back home, tap **Code**, paste the copied message to show the puzzle it finds, and go back;
6. **Daily**: show the calendar and the streak, open today's puzzle for a few moves, go back;
7. **Scoreboard**: Best times, then Statistics (and the Game Center buttons if signed in);
8. **Options**: turn **High contrast** on and off, and switch **Appearance** to Light and back;
9. **Info**, scrolling through the benefits and references;
10. change the language from the home screen and back.

Attach the video to the reply in App Store Connect, or link to an unlisted upload that opens
without signing in.

### Notes (paste as it is)

```text
1. Screen recording
Attached: a recording made on a physical iPhone running iOS [XX.X]. It starts with launching the app and shows a lesson, a game with a hint from the logic coach, the game review, sharing and opening a puzzle code, the daily puzzle, the Scoreboard and statistics, Options, Info and changing the language.
The app has no account registration or login, no user-generated content, and no paid content or in-app purchases. A shared puzzle code holds only a puzzle's level and digits; the app checks it is a valid puzzle before playing it.

2. Purpose and target audience
Sudoku Sagax is a 9x9 sudoku game that teaches the logic of solving, for casual and experienced puzzle players of all ages (rated 4+). Beyond a standard sudoku, it offers:
- A logic coach. A hint names the technique that applies (from hidden singles to the X-Wing), shows where to look, then why (the cells, the candidates and the eliminations on the board), and only then places the digit.
- Nine levels graded by technique, not only by the number of givens (46 to 24): each level needs one technique and nothing harder, so every puzzle is solvable by logic, with steps the coach can explain.
- Eight guided lessons, one per technique, on real boards where the player makes the move.
- A game review after each win: the techniques the puzzle needed, and each hint and mistake with the logical step that was available just before it.
- A daily puzzle that is the same for everyone and works offline, with a streak and a calendar; and sharing a puzzle with a friend as a code.
- Accessibility: VoiceOver labels for every cell and key, marks that don't rely on colour alone, a high contrast option, the system text size and a left-handed layout. Light and dark themes.
- Game Center leaderboards (each level and the daily puzzle) and 14 achievements; layouts for iPad and iPhone Duo.
It also has notes and fill notes, undo and redo, mark conflicts, optional error highlighting, save and resume, statistics, a timer with pause and a local scoreboard. The Info screen summarises published research on number puzzles and cognition, with references.

3. Setup and access
No login, account or setup is needed. Launch the app, choose a level and tap PLAY. Tap a cell then a number, or a number then cells; the Notes toggle pencils in candidates. Hint opens the logic coach in place of the keys: Show me, then Apply (+30 s). After a win, Review opens the game review and Share sends the time and the puzzle code. The home screen also has Continue, Scoreboard (with statistics and Game Center), Daily, Info, Lessons, Code (paste a friend's code), Options and the language. The app works fully offline.

4. External services
The game runs entirely on the device and needs no external service for its core functionality. Game Center is used for leaderboards and achievements when the player is signed in; it is optional. Sharing uses the system share sheet (text only: the time, the puzzle code and the website link). The app uses Google Firebase Analytics (anonymous usage statistics) and Firebase Crashlytics (crash reports) only to improve the app. Options, scores, statistics and the game in progress are stored only on the device. No ads, no payment processors, no other authentication and no AI services.

5. Regional differences
The app works the same in all regions. It is localised in English, Portuguese, Spanish, French and German; only the interface language changes.

6. Regulated industry / third-party material
Not applicable. The app is not in a regulated industry and contains no protected third-party material. Puzzles are generated and graded by the app's own solver, and the icon, logo and graphics are original. The music ("Solar Sail" by Vitalezzz, OpenGameArt) and sound effects ("Digital Audio" by Kenney.nl) are public domain under Creative Commons CC0 1.0. The bundled fonts (Exo 2, Inter) are under the SIL Open Font License 1.1. All of them are credited on the app's Info screen.
```

---

## Shared metadata (all locales)

- **Developer / Publisher:** Sagax Games (Tekinsight — Information Technologies)
- **Category:** Games › Puzzle (App Store secondary: Games › Board)
- **Content rating:** Everyone / 4+ (no objectionable content)
- **Price:** Free
- **In-app purchases:** None · **Ads:** None
- **Internet required:** No (plays fully offline). When online, anonymous usage
  statistics and crash reports are sent via Firebase Analytics and Crashlytics, and
  scores and achievements go to Game Center (iOS) or Google Play Games (Android) for a
  signed-in player — declare them in Play *Data safety* and App Store *App Privacy* (see
  [publishing.md](publishing.md), [game-center.md](app-store/game-center.md) and
  [play-games.md](google-play/play-games.md)).
- **Graphics:** feature graphics `docs/google-play/feature-graphic-<lang>.png`,
  Play icon `docs/google-play/icon-512.png`, screenshots in
  `docs/google-play/screenshots/` and `docs/app-store/screenshots/`
- **Credits:** Music — "Solar Sail" by Vitalezzz · Sounds — Digital Audio by Kenney Vleugels (Kenney.nl) · License — Creative Commons CC0
