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

**Sudoku Sagax** is the app name (the store name adds a search term; see the ASO note). **Sagax Games** is the brand/publisher behind a family of
games (Memorex, Slidox, Sudoku Sagax, MasterCode).

Field length guidance:
- **App Store** — Name: 30 chars · Subtitle: 30 chars · Promotional text: 170 chars · Keywords: 100 chars · Description: 4000 chars.
- **Google Play** — Title: 30 chars · Short description: 80 chars · Full description: 4000 chars.

Notes:
- **ASO (store search).** The App Store searches only the **name**, **subtitle** and
  **keywords**, not the description or promotional text. Google Play searches the **title**,
  **short description** and **full description**, and has no keyword field. So:
  - The store name (also the Play title) is "Sudoku Sagax:" plus the main number-puzzle term in
    each language. On the device the app is still just Sudoku Sagax (`CFBundleDisplayName`,
    `android:label`).
  - The App Store subtitle carries the genre terms (logic puzzle, brain game). The Play short
    description repeats them, because Play has no subtitle.
  - App Store keywords: single words, commas without spaces, no word already in the name or
    subtitle (so never "sudoku"), no other app or brand names. Words combine across the three
    fields, so "brain" + `teaser` also match "brain teaser", and `mind` + "Game" match "mind
    game". Use the full 100 characters.
  - "Classic" (and its translations) goes only in the App Store subtitle and keywords, never in
    the Play fields (see the Metadata policy note).
  - The full description opens with the main terms and repeats them naturally a few times in
    the text, never as a keyword list (the Play Metadata policy bans repetitive or unrelated
    keywords).
  - After launch, check which search terms bring visitors (Play Console's store performance
    report by search term; App Store Connect's App Analytics, App Store Search source) and
    swap the keywords that bring nothing.
- The brain-benefit wording stays within what [research.md](research.md) supports
  (associations, not proof), like the app's Info screen. Keep it that way when editing.
- **Google Play Metadata policy:** the short and full descriptions carry no price or
  promotional claims ("free", "no ads", "no in-app purchases"), no ranking words
  ("the classic", "best", "top", "#1", "new") and no sales pitch. MasterCode 1.0.0 was
  rejected on 16 October 2026 for promotional content in its full description, so these
  listings follow the same rule. Ads, in-app purchases and price are declared in Play
  Console's own fields instead.

---

## 🇬🇧 English (UK) (en-GB)

**App name (App Store and Google Play, ≤30)**
Sudoku Sagax: Number Puzzle

**Subtitle (App Store, ≤30)**
Classic Logic & Brain Game

**Short description (Play Store, ≤80)**
Number puzzle & brain game: 9 levels of pure logic, from Beginner to Expert.

**Promotional text (App Store, ≤170)**
Every puzzle has one solution and is solved by logic alone. Nine levels from Beginner to Expert, pencil notes, hints and your best times on the scoreboard.

**Keywords (App Store, ≤100)**
9x9,grid,mind,teaser,offline,easy,hard,expert,deduction,training,memory,focus,relax,iq,challenge

**Full description**
Sudoku Sagax is a sudoku number puzzle: fill the 9×9 grid with the digits 1 to 9 using logic alone — no guessing, no maths.

HOW TO PLAY
Place the digits 1 to 9 so that every row, column and 3×3 box contains each one exactly once. Tap a cell, then a number; turn on Notes to pencil in a cell's candidates. Every puzzle is generated on your device, has a single solution and can be solved by deduction alone: a logic puzzle and brain game with a clean, modern design.

NINE LEVELS, BEGINNER TO EXPERT
Start with a gentle Beginner grid and work your way up to Expert. Easier levels can be solved one deduction at a time; at Hard and Expert you will need pencil notes and sharper techniques. There is always a challenge that fits.

FEATURES
• 9 difficulty levels, from 46 to 24 given numbers
• A different puzzle every game, always with a unique solution
• Notes: pencil in the candidates of a cell
• Undo and erase
• Timer with pause — or switch it off
• Show errors — optional, off by default
• Hint button fills in a correct number (+30 s) — optional
• Scoreboard per level: your 10 fastest times
• Relaxing music and sound effects (can be turned off)
• Clean, distraction-free interface for phones and tablets
• Play offline, anywhere — no internet connection needed
• In English, Portuguese, Spanish, French and German

THE SCIENCE BEHIND IT
Sudoku is pure deduction: no arithmetic, just logic. Large studies link regular number-puzzle play with better attention, reasoning and memory, and long-term research associates mentally stimulating games with healthier cognitive ageing. The app's Info screen summarises the science, with full scientific references.

Sudoku Sagax is for anyone who enjoys sudoku, number puzzles, logic games and brain teasers; play for two minutes or twenty, at your own pace.

A Sagax Games title. Developed by Tekinsight — Information Technologies.

**What's new (release notes)**
Welcome to Sudoku Sagax! Nine levels of pure logic, from Beginner to Expert. Thank you for playing.

---

## 🇵🇹 Português de Portugal (pt-PT)

**Nome da app (App Store e Google Play, ≤30)**
Sudoku Sagax: Jogo de Números

**Subtítulo (App Store, ≤30)**
Puzzle de Lógica e Raciocínio

**Descrição curta (Play Store, ≤80)**
Puzzle de lógica e raciocínio: preenche a grelha, de Iniciante a Especialista.

**Texto promocional (App Store, ≤170)**
Cada puzzle tem uma só solução e resolve-se apenas com lógica. Nove níveis, de Iniciante a Especialista, notas, ajudas e os teus melhores tempos nos recordes.

**Palavras-chave (App Store, ≤100)**
clássico,cérebro,quebra-cabeça,grelha,9x9,mental,treino,memória,foco,concentração,offline,desafio

**Descrição completa**
O Sudoku Sagax é um puzzle de números e lógica: preenche a grelha 9×9 com os algarismos de 1 a 9 apenas com lógica — sem adivinhar e sem contas.

COMO JOGAR
Coloca os algarismos de 1 a 9 de modo que cada linha, cada coluna e cada quadrado 3×3 os contenha uma única vez. Toca numa célula e depois num número; liga as Notas para marcar os candidatos de uma célula. Cada puzzle é gerado no teu dispositivo, tem uma só solução e resolve-se apenas por dedução: um jogo de lógica e raciocínio, com um design limpo e moderno.

NOVE NÍVEIS, DE INICIANTE A ESPECIALISTA
Começa com uma grelha suave de Iniciante e sobe até Especialista. Os níveis mais fáceis resolvem-se uma dedução de cada vez; nos níveis Difícil e Especialista vais precisar de notas e de técnicas mais apuradas. Há sempre um desafio à tua medida.

FUNCIONALIDADES
• 9 níveis de dificuldade, de 46 a 24 números dados
• Um puzzle diferente em cada jogo, sempre com solução única
• Notas: marca os candidatos de uma célula
• Desfazer e apagar
• Cronómetro com pausa — ou desliga-o
• Mostrar erros — opcional, desligado por predefinição
• Botão de ajuda que preenche um número correto (+30 s) — opcional
• Recordes por nível: os teus 10 tempos mais rápidos
• Música relaxante e efeitos sonoros (podem ser desligados)
• Interface limpa e sem distrações, para telemóveis e tablets
• Joga offline, em qualquer lugar — não precisas de internet
• Em português, inglês, espanhol, francês e alemão

A CIÊNCIA POR TRÁS
O sudoku é dedução pura: não há contas, só lógica. Grandes estudos associam a prática regular de puzzles numéricos a melhor atenção, raciocínio e memória, e a investigação de longo prazo associa jogos mentalmente estimulantes a um envelhecimento cognitivo mais saudável. O ecrã Info da app resume a ciência, com as referências científicas completas.

O Sudoku Sagax é para quem gosta de sudoku, puzzles de números, jogos de lógica e quebra-cabeças; joga dois minutos ou vinte, ao teu ritmo.

Um título Sagax Games. Desenvolvido pela Tekinsight — Tecnologias de Informação.

**Novidades (notas de versão)**
Bem-vindo ao Sudoku Sagax! Nove níveis de lógica pura, de Iniciante a Especialista. Obrigado por jogares.

---

## 🇩🇪 Deutsch (de-DE)

**App-Name (App Store und Google Play, ≤30)**
Sudoku Sagax: Zahlenrätsel

**Untertitel (App Store, ≤30)**
Logikspiel & Gehirnjogging

**Kurzbeschreibung (Play Store, ≤80)**
Logikspiel & Gehirnjogging: 9 Level reiner Logik, vom Anfänger bis zum Experten.

**Werbetext (App Store, ≤170)**
Jedes Rätsel hat genau eine Lösung, lösbar allein mit Logik. Neun Level vom Anfänger bis zum Experten, Notizen, Tipps und deine Bestzeiten in der Bestenliste.

**Schlüsselwörter (App Store, ≤100)**
denkspiel,logikrätsel,knobelspiel,klassisch,zahlen,rätsel,9x9,gehirn,training,gedächtnis,offline

**Vollständige Beschreibung**
Sudoku Sagax ist ein Zahlenrätsel und Logikspiel: Fülle das 9×9-Gitter mit den Ziffern 1 bis 9, allein mit Logik — ohne Raten und ohne Rechnen.

SO WIRD GESPIELT
Setze die Ziffern 1 bis 9 so, dass jede Zeile, jede Spalte und jeder 3×3-Block jede Ziffer genau einmal enthält. Tippe auf ein Feld und dann auf eine Zahl; schalte die Notizen ein, um die Kandidaten eines Feldes vorzumerken. Jedes Rätsel wird auf deinem Gerät erzeugt, hat genau eine Lösung und lässt sich allein durch Schlussfolgern lösen: ein Logikspiel und Gehirnjogging in klarem, modernem Design.

NEUN LEVEL, VOM ANFÄNGER ZUM EXPERTEN
Beginne mit einem sanften Anfänger-Gitter und arbeite dich bis zum Experten hoch. Leichtere Level lassen sich Schritt für Schritt erschließen; bei Schwer und Experte brauchst du Notizen und schärfere Techniken. Es gibt immer eine passende Herausforderung.

FUNKTIONEN
• 9 Schwierigkeitsstufen, von 46 bis 24 vorgegebenen Zahlen
• Jedes Spiel ein anderes Rätsel, immer mit eindeutiger Lösung
• Notizen: Kandidaten eines Feldes vormerken
• Rückgängig und Löschen
• Stoppuhr mit Pause — oder ausschalten
• Fehler anzeigen — optional, standardmäßig aus
• Tipp-Taste trägt eine richtige Zahl ein (+30 s) — optional
• Bestenliste pro Level: deine 10 schnellsten Zeiten
• Entspannende Musik und Soundeffekte (abschaltbar)
• Klare, ablenkungsfreie Oberfläche für Smartphones und Tablets
• Spiele offline, überall — ohne Internetverbindung
• Auf Deutsch, Englisch, Portugiesisch, Spanisch und Französisch

DIE WISSENSCHAFT DAHINTER
Sudoku ist reines Schlussfolgern: kein Rechnen, nur Logik. Große Studien bringen regelmäßiges Lösen von Zahlenrätseln mit besserer Aufmerksamkeit, besserem logischem Denken und Gedächtnis in Verbindung, und Langzeitforschung verbindet geistig anregende Spiele mit gesünderem kognitivem Altern. Der Info-Bildschirm der App fasst die Wissenschaft zusammen, mit vollständigen Quellenangaben.

Sudoku Sagax ist für alle, die Sudoku, Zahlenrätsel, Logikrätsel und Knobelspiele mögen; spiele zwei Minuten oder zwanzig, in deinem Tempo.

Ein Titel von Sagax Games. Entwickelt von Tekinsight — Informationstechnologien.

**Neuigkeiten (Versionshinweise)**
Willkommen bei Sudoku Sagax! Neun Level reiner Logik, vom Anfänger bis zum Experten. Danke fürs Spielen.

---

## 🇪🇸 Español de España (es-ES)

**Nombre de la app (App Store y Google Play, ≤30)**
Sudoku Sagax: Juego de Números

**Subtítulo (App Store, ≤30)**
Rompecabezas de Lógica

**Descripción breve (Play Store, ≤80)**
Rompecabezas de lógica y números: 9 niveles, de Principiante a Experto.

**Texto promocional (App Store, ≤170)**
Cada puzle tiene una única solución y se resuelve solo con lógica. Nueve niveles de Principiante a Experto, notas, pistas y tus mejores tiempos en los récords.

**Palabras clave (App Store, ≤100)**
puzle,clásico,mental,cerebro,cuadrícula,9x9,entrenamiento,memoria,concentración,acertijo,offline

**Descripción completa**
Sudoku Sagax es un rompecabezas de números y lógica: completa la cuadrícula de 9×9 con los dígitos del 1 al 9 solo con lógica, sin adivinar y sin hacer cuentas.

CÓMO SE JUEGA
Coloca los dígitos del 1 al 9 de modo que cada fila, cada columna y cada caja de 3×3 los contenga una sola vez. Toca una celda y luego un número; activa las Notas para anotar los candidatos de una celda. Cada puzle se genera en tu dispositivo, tiene una única solución y se resuelve solo por deducción: un juego mental de lógica pura, con un diseño limpio y moderno.

NUEVE NIVELES, DE PRINCIPIANTE A EXPERTO
Empieza con una cuadrícula suave de Principiante y avanza hasta Experto. Los niveles más fáciles se resuelven deducción a deducción; en Difícil y Experto necesitarás notas y técnicas más afinadas. Siempre hay un reto a tu medida.

CARACTERÍSTICAS
• 9 niveles de dificultad, de 46 a 24 números dados
• Un puzle distinto en cada partida, siempre con solución única
• Notas: anota los candidatos de una celda
• Deshacer y borrar
• Cronómetro con pausa, o desactívalo
• Mostrar errores: opcional, desactivado por defecto
• Botón de pista que rellena un número correcto (+30 s): opcional
• Récords por nivel: tus 10 tiempos más rápidos
• Música relajante y efectos de sonido (se pueden desactivar)
• Interfaz limpia y sin distracciones, pensada para móviles y tabletas
• Juega sin conexión, donde quieras: no necesitas internet
• En español, inglés, portugués, francés y alemán

LA CIENCIA DETRÁS
El sudoku es deducción pura: sin cálculos, solo lógica. Grandes estudios relacionan la práctica habitual de puzles numéricos con mejor atención, razonamiento y memoria, y la investigación a largo plazo asocia los juegos mentalmente estimulantes con un envejecimiento cognitivo más saludable. La pantalla Info de la app resume la ciencia con sus referencias completas.

Sudoku Sagax es para quien disfruta del sudoku, los puzles de números, los juegos de lógica y los rompecabezas; juega dos minutos o veinte, a tu ritmo.

Un título de Sagax Games. Desarrollado por Tekinsight — Tecnologías de la Información.

**Novedades (notas de la versión)**
¡Bienvenido a Sudoku Sagax! Nueve niveles de lógica pura, de Principiante a Experto. Gracias por jugar.

---

## 🇫🇷 Français (fr-FR)

**Nom de l'app (App Store et Google Play, ≤30)**
Sudoku Sagax : Jeu de Chiffres

**Sous-titre (App Store, ≤30)**
Casse-tête de logique

**Description courte (Play Store, ≤80)**
Casse-tête de logique et de réflexion : 9 niveaux, de Débutant à Expert.

**Texte promotionnel (App Store, ≤170)**
Chaque grille a une solution unique et se résout par la seule logique. Neuf niveaux de Débutant à Expert, notes, indices et vos meilleurs temps au classement.

**Mots-clés (App Store, ≤100)**
réflexion,classique,cerveau,cérébral,grille,9x9,mémoire,concentration,déduction,hors,ligne,défi

**Description complète**
Sudoku Sagax est un casse-tête de chiffres et de logique : remplissez la grille 9×9 avec les chiffres de 1 à 9 par la seule logique — sans deviner, sans calcul.

COMMENT JOUER
Placez les chiffres de 1 à 9 de sorte que chaque ligne, chaque colonne et chaque carré 3×3 les contienne une seule fois. Touchez une case, puis un chiffre ; activez les Notes pour inscrire les candidats d'une case. Chaque grille est générée sur votre appareil, a une solution unique et se résout par la seule déduction : un jeu de logique et de réflexion, au design épuré et moderne.

NEUF NIVEAUX, DE DÉBUTANT À EXPERT
Commencez par une grille Débutant en douceur et progressez jusqu'à Expert. Les niveaux faciles se résolvent une déduction à la fois ; en Difficile et Expert, il vous faudra des notes et des techniques plus fines. Il y a toujours un défi à votre mesure.

FONCTIONNALITÉS
• 9 niveaux de difficulté, de 46 à 24 chiffres donnés
• Une grille différente à chaque partie, toujours avec une solution unique
• Notes : inscrivez les candidats d'une case
• Annuler et effacer
• Chronomètre avec pause — ou désactivez-le
• Afficher les erreurs — en option, désactivé par défaut
• Bouton d'indice qui remplit un chiffre correct (+30 s) — en option
• Classement par niveau : vos 10 temps les plus rapides
• Musique relaxante et effets sonores (désactivables)
• Interface épurée et sans distraction, pour téléphones et tablettes
• Jouez hors ligne, partout — sans connexion Internet
• En français, anglais, portugais, espagnol et allemand

LA SCIENCE DERRIÈRE LE JEU
Le sudoku, c'est de la déduction pure : aucun calcul, seulement de la logique. De grandes études associent la pratique régulière des casse-têtes numériques à une meilleure attention, un meilleur raisonnement et une meilleure mémoire, et la recherche à long terme relie les jeux stimulants à un vieillissement cognitif en meilleure santé. L'écran Info de l'app résume la science, avec les références complètes.

Sudoku Sagax s'adresse à tous ceux qui aiment le sudoku, les casse-têtes de chiffres, les jeux de logique et les énigmes ; jouez deux minutes ou vingt, à votre rythme.

Un titre Sagax Games. Développé par Tekinsight — Technologies de l'Information.

**Nouveautés (notes de version)**
Bienvenue dans Sudoku Sagax ! Neuf niveaux de logique pure, de Débutant à Expert. Merci de jouer.

---

## 🇺🇸 English (US) (en-US)

**App name (App Store and Google Play, ≤30)**
Sudoku Sagax: Number Puzzle

**Subtitle (App Store, ≤30)**
Classic Logic & Brain Game

**Short description (Play Store, ≤80)**
Number puzzle & brain game: 9 levels of pure logic, from Beginner to Expert.

**Promotional text (App Store, ≤170)**
Every puzzle has one solution and is solved by logic alone. Nine levels from Beginner to Expert, pencil notes, hints and your best times on the scoreboard.

**Keywords (App Store, ≤100)**
9x9,grid,mind,teaser,offline,easy,hard,expert,deduction,training,memory,focus,relax,iq,challenge

**Full description**
Sudoku Sagax is a sudoku number puzzle: fill the 9×9 grid with the digits 1 to 9 using logic alone — no guessing, no math.

HOW TO PLAY
Place the digits 1 to 9 so that every row, column and 3×3 box contains each one exactly once. Tap a cell, then a number; turn on Notes to pencil in a cell's candidates. Every puzzle is generated on your device, has a single solution and can be solved by deduction alone: a logic puzzle and brain game with a clean, modern design.

NINE LEVELS, BEGINNER TO EXPERT
Start with a gentle Beginner grid and work your way up to Expert. Easier levels can be solved one deduction at a time; at Hard and Expert you will need pencil notes and sharper techniques. There is always a challenge that fits.

FEATURES
• 9 difficulty levels, from 46 to 24 given numbers
• A different puzzle every game, always with a unique solution
• Notes: pencil in the candidates of a cell
• Undo and erase
• Timer with pause — or switch it off
• Show errors — optional, off by default
• Hint button fills in a correct number (+30 s) — optional
• Scoreboard per level: your 10 fastest times
• Relaxing music and sound effects (can be turned off)
• Clean, distraction-free interface for phones and tablets
• Play offline, anywhere — no internet connection needed
• In English, Portuguese, Spanish, French and German

THE SCIENCE BEHIND IT
Sudoku is pure deduction: no arithmetic, just logic. Large studies link regular number-puzzle play with better attention, reasoning and memory, and long-term research associates mentally stimulating games with healthier cognitive aging. The app's Info screen summarizes the science, with full scientific references.

Sudoku Sagax is for anyone who enjoys sudoku, number puzzles, logic games and brain teasers; play for two minutes or twenty, at your own pace.

A Sagax Games title. Developed by Tekinsight — Information Technologies.

**What's new (release notes)**
Welcome to Sudoku Sagax! Nine levels of pure logic, from Beginner to Expert. Thank you for playing.

---

## 🇧🇷 Português do Brasil (pt-BR)

**Nome do app (App Store e Google Play, ≤30)**
Sudoku Sagax: Jogo de Números

**Subtítulo (App Store, ≤30)**
Quebra-Cabeça de Lógica

**Descrição curta (Play Store, ≤80)**
Quebra-cabeça de lógica e raciocínio: 9 níveis, do Iniciante ao Especialista.

**Texto promocional (App Store, ≤170)**
Cada quebra-cabeça tem uma só solução e se resolve apenas com lógica. Nove níveis, do Iniciante ao Especialista, notas, ajudas e seus melhores tempos nos recordes.

**Palavras-chave (App Store, ≤100)**
raciocínio,clássico,cérebro,grade,9x9,mente,mental,treino,memória,foco,concentração,offline,desafio

**Descrição completa**
O Sudoku Sagax é um quebra-cabeça de números e lógica: preencha a grade 9×9 com os algarismos de 1 a 9 usando só a lógica — sem chutar e sem fazer contas.

COMO JOGAR
Coloque os algarismos de 1 a 9 de modo que cada linha, cada coluna e cada quadrado 3×3 tenha cada um deles uma única vez. Toque em uma célula e depois em um número; ative as Notas para marcar os candidatos de uma célula. Cada quebra-cabeça é gerado no seu aparelho, tem uma só solução e pode ser resolvido apenas por dedução: um jogo de lógica e raciocínio, com um visual limpo e moderno.

NOVE NÍVEIS, DO INICIANTE AO ESPECIALISTA
Comece com uma grade tranquila de Iniciante e avance até o Especialista. Os níveis mais fáceis se resolvem uma dedução por vez; nos níveis Difícil e Especialista, você vai precisar de notas e de técnicas mais apuradas. Sempre há um desafio na sua medida.

RECURSOS
• 9 níveis de dificuldade, de 46 a 24 números dados
• Um quebra-cabeça diferente a cada partida, sempre com solução única
• Notas: marque os candidatos de uma célula
• Desfazer e apagar
• Cronômetro com pausa — ou desligue-o
• Mostrar erros — opcional, desligado por padrão
• Botão de ajuda que preenche um número correto (+30 s) — opcional
• Recordes por nível: seus 10 tempos mais rápidos
• Música relaxante e efeitos sonoros (podem ser desligados)
• Interface limpa e sem distrações, para celulares e tablets
• Jogue offline, em qualquer lugar — sem precisar de internet
• Em português, inglês, espanhol, francês e alemão

A CIÊNCIA POR TRÁS
O sudoku é dedução pura: não há contas, só lógica. Grandes estudos associam a prática regular de quebra-cabeças numéricos a melhor atenção, raciocínio e memória, e pesquisas de longo prazo associam jogos mentalmente estimulantes a um envelhecimento cognitivo mais saudável. A tela Info do app resume a ciência, com as referências científicas completas.

O Sudoku Sagax é para quem gosta de sudoku, jogos de números, jogos de lógica e quebra-cabeças; jogue dois minutos ou vinte, no seu ritmo.

Um título Sagax Games. Desenvolvido pela Tekinsight — Tecnologias da Informação.

**Novidades (notas da versão)**
Bem-vindo ao Sudoku Sagax! Nove níveis de lógica pura, do Iniciante ao Especialista. Obrigado por jogar.

---

## 🌎 Español de Latinoamérica (es-419)

**Nombre de la app (App Store y Google Play, ≤30)**
Sudoku Sagax: Juego de Números

**Subtítulo (App Store, ≤30)**
Rompecabezas de Lógica

**Descripción breve (Play Store, ≤80)**
Rompecabezas de lógica y números: 9 niveles, de Principiante a Experto.

**Texto promocional (App Store, ≤170)**
Cada rompecabezas tiene una única solución y se resuelve solo con lógica. Nueve niveles de Principiante a Experto, notas, pistas y tus mejores tiempos en los récords.

**Palabras clave (App Store, ≤100)**
clásico,mental,cerebro,cuadrícula,9x9,entrenamiento,memoria,concentración,acertijo,internet,reto

**Descripción completa**
Sudoku Sagax es un rompecabezas de números y lógica: completa la cuadrícula de 9×9 con los dígitos del 1 al 9 solo con lógica, sin adivinar y sin hacer cuentas.

CÓMO SE JUEGA
Coloca los dígitos del 1 al 9 de modo que cada fila, cada columna y cada caja de 3×3 los contenga una sola vez. Toca una celda y luego un número; activa las Notas para anotar los candidatos de una celda. Cada rompecabezas se genera en tu dispositivo, tiene una única solución y se resuelve solo por deducción: un juego mental de lógica pura, con un diseño limpio y moderno.

NUEVE NIVELES, DE PRINCIPIANTE A EXPERTO
Empieza con una cuadrícula suave de Principiante y avanza hasta Experto. Los niveles más fáciles se resuelven deducción a deducción; en Difícil y Experto necesitarás notas y técnicas más afinadas. Siempre hay un reto a tu medida.

CARACTERÍSTICAS
• 9 niveles de dificultad, de 46 a 24 números dados
• Un rompecabezas distinto en cada partida, siempre con solución única
• Notas: anota los candidatos de una celda
• Deshacer y borrar
• Cronómetro con pausa, o desactívalo
• Mostrar errores: opcional, desactivado por defecto
• Botón de pista que completa un número correcto (+30 s): opcional
• Récords por nivel: tus 10 tiempos más rápidos
• Música relajante y efectos de sonido (se pueden desactivar)
• Interfaz limpia y sin distracciones, pensada para celulares y tabletas
• Juega sin internet, donde quieras
• En español, inglés, portugués, francés y alemán

LA CIENCIA DETRÁS
El sudoku es deducción pura: sin cálculos, solo lógica. Grandes estudios relacionan la práctica habitual de rompecabezas numéricos con mejor atención, razonamiento y memoria, y la investigación a largo plazo asocia los juegos mentalmente estimulantes con un envejecimiento cognitivo más saludable. La pantalla Info de la app resume la ciencia con sus referencias completas.

Sudoku Sagax es para quien disfruta del sudoku, los rompecabezas de números, los juegos de lógica y los acertijos; juega dos minutos o veinte, a tu ritmo.

Un título de Sagax Games. Desarrollado por Tekinsight — Tecnologías de la Información.

**Novedades (notas de la versión)**
¡Bienvenido a Sudoku Sagax! Nueve niveles de lógica pura, de Principiante a Experto. Gracias por jugar.

---

## Release notes

All languages in the multi-language format that Google Play Console accepts in
a release's *Release notes* field: paste the block as-is (≤500 characters per
language). App Store Connect takes one language at a time — use the matching
*What's new* text from each language section above.

**Version 1.0.0 (1)**

```
<en-GB>
Welcome to Sudoku Sagax! Nine levels of pure logic, from Beginner to Expert. Thank you for playing.
</en-GB>
<de-DE>
Willkommen bei Sudoku Sagax! Neun Level reiner Logik, vom Anfänger bis zum Experten. Danke fürs Spielen.
</de-DE>
<es-ES>
¡Bienvenido a Sudoku Sagax! Nueve niveles de lógica pura, de Principiante a Experto. Gracias por jugar.
</es-ES>
<fr-FR>
Bienvenue dans Sudoku Sagax ! Neuf niveaux de logique pure, de Débutant à Expert. Merci de jouer.
</fr-FR>
<pt-PT>
Bem-vindo ao Sudoku Sagax! Nove níveis de lógica pura, de Iniciante a Especialista. Obrigado por jogares.
</pt-PT>
<en-US>
Welcome to Sudoku Sagax! Nine levels of pure logic, from Beginner to Expert. Thank you for playing.
</en-US>
<pt-BR>
Bem-vindo ao Sudoku Sagax! Nove níveis de lógica pura, do Iniciante ao Especialista. Obrigado por jogar.
</pt-BR>
<es-419>
¡Bienvenido a Sudoku Sagax! Nueve niveles de lógica pura, de Principiante a Experto. Gracias por jugar.
</es-419>
```

---

## App Store Connect — App Review information

App Review asks for six things with a submission (or in a reply when it holds one). Paste the
block below, as it is, in the version's **App Review Information → Notes** field, and as the
**reply** to App Review in App Store Connect when it asks. The 1.0 submission was held under
*Guideline 2.1 – Information Needed* until Apple received exactly these answers, so keep the
block in the Notes field for every future submission. Attach the screen recording to the reply.
App Review reads English, so there are no translations. Keep it in sync with the app when
features change.

Before pasting, fill in the iOS version in item 1 (`[XX.X]`) with the version the recording was
made on. Also set **Sign-in required: No** (leave the demo account off) and fill in the contact
details on the same page.

### Screen recording (item 1)

Record on a physical iPhone running the latest iOS, not the simulator (the store preview video
does not count either). Install the build through TestFlight (or a release build; see
[publishing.md, "Testing on a physical device"](publishing.md#testing-on-a-physical-device)),
add *Screen Recording* to Control Center, start recording from Control Center, then:

1. on the home screen, tap the Sudoku Sagax icon (the video must begin with the launch);
2. play a Beginner game through to the win: enter digits, turn on Notes, use a hint, undo,
   pause and resume;
3. after the win summary, open the **Scoreboard**, **Options** and **Info**.

Attach the video to the reply in App Store Connect, or link to an unlisted upload that opens
without signing in.

### Notes (paste as it is)

```text
1. Screen recording
Attached: a recording made on a physical iPhone running iOS [XX.X]. It starts with launching the app and shows the typical flow: choosing a level, playing (digits, notes, hint, undo, pause), finishing a puzzle, the scoreboard, the options and the Info screen.
The app has no account registration or login, no user-generated content, and no paid content or in-app purchases.

2. Purpose and target audience
Sudoku Sagax is a classic 9x9 sudoku game for casual and experienced puzzle players of all ages (rated 4+). It generates a new puzzle every game, each with a single solution that can be reached by logic alone, across 9 difficulty levels from Beginner (46 givens) to Expert (24 givens). It gives players a calm, ad-free way to exercise attention and reasoning. Features: pencil notes, undo/erase, optional hints, optional error highlighting, a timer with pause, and a local scoreboard of the 10 best times per level. The Info screen summarises published research on number puzzles and cognition, with references.

3. Setup and access
No login, account or setup is needed. Launch the app, tap PLAY, choose a level and start playing. Tap a cell, then a number to fill it; use the Notes toggle to pencil in candidates, and the Hint button to fill a correct cell (+30 s). Options (sound, timer, show errors, hints, language) and the Scoreboard are on the home screen. The app works fully offline.

4. External services
The game runs entirely on the device and needs no external service for its core functionality. It uses Google Firebase Analytics (anonymous usage statistics) and Firebase Crashlytics (crash reports) only to improve the app. Options and scores are stored only on the device. No ads, no payment processors, no authentication and no AI services.

5. Regional differences
The app works the same in all regions. It is localised in English, Portuguese, Spanish, French and German; only the interface language changes.

6. Regulated industry / third-party material
Not applicable. The app is not in a regulated industry and contains no protected third-party material. Puzzles are generated on the device, and the icon, logo and graphics are original. The music ("Solar Sail" by Vitalezzz, OpenGameArt) and sound effects ("Digital Audio" by Kenney.nl) are public domain under Creative Commons CC0 1.0. The bundled fonts (Exo 2, Inter) are under the SIL Open Font License 1.1. All of them are credited on the app's Info screen.
```

---

## Shared metadata (all locales)

- **Developer / Publisher:** Sagax Games (Tekinsight — Information Technologies)
- **Category:** Games › Puzzle (App Store secondary: Games › Board)
- **Content rating:** Everyone / 4+ (no objectionable content)
- **Price:** Free
- **In-app purchases:** None · **Ads:** None
- **Internet required:** No (plays fully offline). When online, anonymous usage
  statistics and crash reports are sent via Firebase Analytics and Crashlytics —
  declare them in Play *Data safety* and App Store *App Privacy* (see [publishing.md](publishing.md)).
- **Graphics:** feature graphics `docs/google-play/feature-graphic-<lang>.png`,
  Play icon `docs/google-play/icon-512.png`, screenshots in
  `docs/google-play/screenshots/` and `docs/app-store/screenshots/`
- **Credits:** Music — "Solar Sail" by Vitalezzz · Sounds — Digital Audio by Kenney Vleugels (Kenney.nl) · License — Creative Commons CC0
