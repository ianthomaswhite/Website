# Academic Samples: Changelog & Cleanup Documentation

This document records all changes applied to the sample documents in `documents/academic/samples/` across the three subdirectories: `linguistics`, `literature`, and `teaching`.

---

## 1. Global Standardization Changes

### Header and Page Numbering
- **Left Header**: Standardized to `\lhead{Ian Thomas White}` across all documents.
- **Right Header**: Standardized to `\rhead{\thepage \ of \pageref{LastPage}}` across all documents.
- **First / Title Page**: Headers are suppressed on page 1 via `\thispagestyle{empty}`.
- **Header Activation**: Configured `\pagestyle{fancy}` uniformly.

### Bibliography Indentation
- For `biblatex`-managed documents (`ling_205_final_paper.tex`, `deverbals3.tex`, `weaving.tex`), hanging indentation was made explicit and uniform with `\setlength{\bibhang}{0.5in}` alongside `apa` style hanging indentation.
- For all documents with built-in/manual bibliographies (`ling_200b_paper.tex`, `ling_200c_paper.tex`, `ling_201c_final_paper.tex`, `ling_209_paper.tex`, `MA_precis.tex`, `1301w_syllabus_materials.tex`), hanging indentation was standardized with `\begin{hangparas}{.25in}{1}` and single spacing.

---

## 2. Document-Specific Changes

### Category: `academic/samples/linguistics/`

#### 1. `MA_precis.tex` (Includes Appendix: Conversions and Derivations from `ling_MA_main.tex`)
- **Structure & Appendix**:
  - Combined `ling_MA_main.tex` into `MA_precis.tex` as a new appendix section: `\appendix\section{Grammar Conversions and Derivations}` following the References.
  - The unmerged scratch version `ling_MA_main.tex` has been removed.
- **Formatting**:
  - Header standardized with `\lhead{Ian Thomas White}` and `\rhead{\thepage \ of \pageref{LastPage}}`.
  - Added `\thispagestyle{empty}` to the title page.
  - Bibliography formatted with `hangparas` for hanging indentation.
- **Spelling / Grammar**:
  - In appendix derivations: Fixed `five lads younr` $\rightarrow$ `five lads young`.

#### 2. `ling_201c_final_paper.tex`
- **Formatting & References**:
  - Added dedicated `\section{References}` using `\begin{hangparas}{.25in}{1}` and `\small` single spacing.
  - Added complete citations including Barker, Bernardi, & Shan (2010, *SALT* 20: 109–127, https://doi.org/10.3765/salt.v20i0.2569), Bernardi & Moortgat (2010), Kubota & Uegaki (2009), Murray (2010), and Potts (2005).
  - Loaded `\usepackage{hanging}`.
- **Spelling / Grammar**:
  - Line 266: Fixed `A consituent is` $\rightarrow$ `A constituent is`.

#### 3. `ling_205_final_paper.tex`
- **Formatting & References**:
  - Added `\tableofcontents` and `\newpage`.
  - Converted external `\printbibliography` to built-in `\section{References}` using `\begin{hangparas}{.25in}{1}` and `\small` single spacing.
  - Added complete citations directly in `.tex` for Alexiadou & Doron (2012), Bobaljik (2000), Embick (1997), Grestenberger (2015, 2019), Halle & Marantz (1993), Merchant (2015), Ramón (2014), Reed (2014), Schreiner (2021), and Tronci (2018).
  - Cleaned `hangparas` definition to eliminate active quote interference in math mode.
- **Spelling / Grammar**:
  - Line 423: Fixed `Panini's prinicple` $\rightarrow$ `Panini's principle`.
  - Line 457: Fixed `Panini's prinicple` $\rightarrow$ `Panini's principle`.
  - Line 457: Fixed `dissocaiated` $\rightarrow$ `dissociated`.

#### 4. `deverbals3.tex`
- **Formatting**:
  - Explicit hanging indentation: `\setlength{\bibhang}{0.5in}` added to preamble with `biblatex`.
- **Spelling / Grammar**:
  - Line 98: Fixed `definitionly` $\rightarrow$ `definitionally`.
  - Line 434: Fixed `Pylkännen` $\rightarrow$ `Pylkkänen`.
  - Line 438: Fixed `Harely` $\rightarrow$ `Harley`.
  - Line 477: Fixed `aboive` $\rightarrow$ `above`.
  - Line 478: Fixed `ommission` $\rightarrow$ `omission`.
  - Line 502: Fixed `arguemnt` $\rightarrow$ `argument`.
  - Line 606: Fixed `rgument` $\rightarrow$ `argument`.
  - Line 697: Fixed `distintegrated` $\rightarrow$ `disintegrated`.
  - Line 835: Fixed `destuction` $\rightarrow$ `destruction`.
  - Line 853: Fixed `explantion` $\rightarrow$ `explanation`.
  - Line 910: Fixed `instrutionalization` $\rightarrow$ `instructionalization`.
  - Line 912: Fixed `occurence` $\rightarrow$ `occurrence`.
  - Line 1060: Fixed `nore` $\rightarrow$ `nor`.
  - Line 1109: Fixed `unaccsuative` $\rightarrow$ `unaccusative`.
  - Line 1222: Fixed `seleting` $\rightarrow$ `selecting`.
  - Line 1284: Fixed `possibilties` $\rightarrow$ `possibilities`.
  - Line 1618: Fixed `obligitoriness` $\rightarrow$ `obligatoriness`.

---

### Category: `academic/samples/literature/`

#### 5. `weaving.tex`
- **Formatting**:
  - Explicit hanging indentation: `\setlength{\bibhang}{0.5in}` added to preamble with `biblatex`.
- **Spelling / Grammar**:
  - Line 224: Fixed `oversess` $\rightarrow$ `oversees`.
  - Line 224: Fixed `determins` $\rightarrow$ `determines`.
  - Line 230: Fixed `rided` $\rightarrow$ `ridden`.
  - Line 245: Fixed `extention` $\rightarrow$ `extension`.
  - Line 268: Fixed `aslo` $\rightarrow$ `also`.
  - Line 278: Fixed `sitching` $\rightarrow$ `stitching`.
  - Line 336: Fixed `supercede` $\rightarrow$ `supersede`.
  - Line 346: Fixed `Clayon` $\rightarrow$ `Clayton`.
  - Line 354: Fixed `begger` $\rightarrow$ `beggar`.
  - Line 500: Fixed `embededness` $\rightarrow$ `embeddedness`.
  - Line 590: Fixed `metonomy` $\rightarrow$ `metonymy`.
  - Line 598: Fixed `Clatyon` $\rightarrow$ `Clayton`.
  - Line 611: Fixed `Calpyso` $\rightarrow$ `Calypso`.
  - Line 654: Fixed `prophesizes` $\rightarrow$ `prophesies`.
  - Line 656: Fixed `moreoever` $\rightarrow$ `moreover`.
  - Line 673: Fixed `manfifests` $\rightarrow$ `manifests`.
  - Line 675: Fixed `unennding` $\rightarrow$ `unending`.

---

### Category: `academic/samples/teaching/`

#### 6. `gram2.tex` (Standalone)
- **Formatting**:
  - Header updated to `\lhead{Ian Thomas White}` and `\rhead{\thepage \ of \pageref{LastPage}}`.
  - First page header suppressed with `\thispagestyle{empty}`.
- **Spelling / Grammar**:
  - Line 510: Fixed `semicolos` $\rightarrow$ `semicolons`.
  - Line 553: Fixed `protatis` $\rightarrow$ `protasis`.
  - Line 590: Fixed `dangling modifers` $\rightarrow$ `dangling modifiers`.

#### 7. `1301w_syllabus_materials.tex` (Combined from `cscl1301w` and `rubrics`)
- **Structure & TOC**:
  - Title: *CSCL 1301W: Syllabus and Assignment Materials*
  - Merged into two cohesive parts:
    - `\part{Syllabus}` (Course Description, Texts, Requirements, Grades, Policies and Resources, Schedule)
    - `\part{Assignment Guidelines and Rubrics}` (Theory Outlines, Lyric Claims, Close Reading Papers, Final Paper New Option, Final Paper Original Option)
  - Single consolidated `\tableofcontents`.
- **Formatting**:
  - Standardized header `\lhead{Ian Thomas White}` and `\rhead{\thepage \ of \pageref{LastPage}}`.
  - Suppressed title page header with `\thispagestyle{empty}`.
- **Spelling / Grammar**:
  - Fixed `All texts str available` $\rightarrow$ `All texts are available`.

#### 8. `1301w_teaching_materials.tex` (Combined from `overviews`, `against`, `chomsky`, `cratylus`, `saussure`)
- **Structure & TOC**:
  - Title: *CSCL 1301W: Teaching Materials and Text Notes*
  - Merged into five distinct parts:
    - `\part{Lecture and Reading Overviews}`
    - `\part{Notes on Plato's \textit{Cratylus}}`
    - `\part{Notes on Sextus Empiricus' ``Against the Grammarians''}`
    - `\part{Notes on Saussure's \textit{Course in General Linguistics}}`
    - `\part{Notes on Chomsky's \textit{Syntactic Structures}}`
  - Single consolidated `\tableofcontents`.
- **Formatting**:
  - Standardized header `\lhead{Ian Thomas White}` and `\rhead{\thepage \ of \pageref{LastPage}}`.
  - Suppressed title page header with `\thispagestyle{empty}`.
- **Spelling / Grammar**:
  - *Overviews*: Fixed `sometomes` $\rightarrow$ `sometimes`, `occured` $\rightarrow$ `occurred`, `descendent` $\rightarrow$ `descendant`.
  - *Cratylus*: Fixed `supposeldy` $\rightarrow$ `supposedly`, `dialectition` $\rightarrow$ `dialectician`, `patriarhical` $\rightarrow$ `patriarchal`, `astonomers` $\rightarrow$ `astronomers`, `philospher` $\rightarrow$ `philosopher`, `lingusitic` $\rightarrow$ `linguistic`, `deciever` $\rightarrow$ `deceiver`, `degress` $\rightarrow$ `degrees`, `symphathizers` $\rightarrow$ `sympathizers`, `strenghth` $\rightarrow$ `strength`, `Primary Philosphical Names` $\rightarrow$ `Primary Philosophical Names`, `dont' write it` $\rightarrow$ `don't write it`, `philosphical` $\rightarrow$ `philosophical`.
  - *Against*: Fixed `self-taught philospher` $\rightarrow$ `self-taught philosopher`, `among philosphers` $\rightarrow$ `among philosophers`, `definiton` $\rightarrow$ `definition`, `foonote` $\rightarrow$ `footnote`, `not usefl` $\rightarrow$ `not useful`, `negative verstion` $\rightarrow$ `negative version`, `philospher` $\rightarrow$ `philosopher`.
  - *Saussure*: Fixed `despite ther getting little` $\rightarrow$ `despite their getting little`, `psycholingusitics` $\rightarrow$ `psycholinguistics`, `Abstact` $\rightarrow$ `Abstract`, `change occured` $\rightarrow$ `change occurred`, `verificaiton` $\rightarrow$ `verification`, `relabled` $\rightarrow$ `relabeled`, `syntamgatic` $\rightarrow$ `syntagmatic`, `lingusitics` $\rightarrow$ `linguistics`.
  - *Chomsky*: Fixed `Structuralistm` $\rightarrow$ `Structuralism`, `somthing like this` $\rightarrow$ `something like this`, `simplicification` $\rightarrow$ `simplification`, `can be prased in` $\rightarrow$ `can be parsed in`, `inuitive` $\rightarrow$ `intuitive`, `semanitc` $\rightarrow$ `semantic`.

---

## 3. Title Capitalization Pass (All Academic Samples)

Applied Title Case capitalization across document titles and all sections, subsections, and subsubsections (excluding numbered linguistic examples and mathematical notation):
- **`samples/literature/weaving.tex`**: Capitalized title (*The Metonymy of Weaving and Speech in the Odyssey*), sections, subsections, and subsubsections.
- **`samples/teaching/1301w_teaching_materials.tex`**: Standardized Title Case across all parts, lecture overviews, and text notes.
- **`samples/teaching/1301w_syllabus_materials.tex`**: Standardized Title Case across all syllabus and assignment headings.
- **`samples/teaching/gram2.tex`**: Capitalized document title (*English Grammar: Rules and Guidelines*) and all section headings.
- **`samples/linguistics/MA_precis.tex`**: Capitalized all sections, subsections, and appendix headings.
- **`samples/linguistics/ling_201c_final_paper.tex`**: Capitalized title (*On the Syntax of Turkish Copular Clauses*) and all section/subsection titles.
- **`samples/linguistics/ling_200b_paper.tex`**: Standardized section and subsection headings to Title Case.
- **`samples/linguistics/ling_200c_paper.tex`**: Standardized section and subsection headings to Title Case.
- **`samples/linguistics/deverbals3.tex`**: Capitalized document title (*The Argument Structure of Nominalizations*) and all section/subsection headers.
- **`samples/linguistics/ling_209_paper.tex`**: Standardized section and subsection headings to Title Case.
- **`samples/linguistics/ling_205_final_paper.tex`**: Standardized section and subsection headings to Title Case.

---

## 4. Teaching Materials Part Formatting

Updated the `\part` styling in `1301w_syllabus_materials.tex` and `1301w_teaching_materials.tex`:
- Removed explicit "Part 1", "Part 2", etc., numbering prefixes from headers.
- Scaled part title font to `\large\bfseries` (one font size up from the part-internal `\normalsize` / `\medium` section headers).
- Preserved part entries in `\tableofcontents`.

---

## 5. Linguistics: `MA_precis.tex` Landscape Appendix & MG Tree Fixes

- **Landscape Appendix**:
  - Implemented `\usepackage{pdflscape}`.
  - Wrapped the appendix in `\begin{landscape} ... \end{landscape}` immediately following the references.
  - Keeps the main body (pages 1–7) in portrait orientation while displaying the wide grammar derivations and trees (pages 8–47) in landscape.
- **MG Tree Rendering & Compilation Fixes**:
  - Provided `\providecommand{\medium}{\normalsize}` to prevent undefined macro errors.
  - Corrected math syntax inside `forest` nodes (e.g. `\N'` $\rightarrow$ `N'`, `\epsislon` $\rightarrow$ `\epsilon`).
  - Escaped out-of-math `\ast` occurrences in `tabularx` tables (`$*$` / `*`).
  - Removed dangling line breaks `\\` on section headings.
  - Successfully verified error-free compilation and full rendering of all CCG, LIG, and MG tree diagrams.

---

## 6. Table of Contents & References Updates

- **Table of Contents (TOC) Added**:
  - Added `\tableofcontents` and `\newpage` following `\maketitle` in:
    - `ling_209_paper.tex` (*Review: Tree Adjoining Grammars*)
    - `MA_precis.tex` (*Permutation Power in MGs and CCGs*)
    - `ling_205_final_paper.tex` (*Attic Greek Aorist/Future Passives*)
    - `ling_200b_paper.tex` (*Head Movement: PF?*)
    - `ling_200c_paper.tex` (*Barker 2002: Continuations and the Nature of Quantification*)
    - `ling_201c_final_paper.tex` (*Barker, Bernardi, Shan 2010: Principles of Interdimensional Meaning Interaction*)
- **TAGs (209) PDF Compilation Fix**:
  - The `hanging` package was redefining active punctuation marks (`'` and `` ` ``), causing infinite recursion and `TeX capacity exceeded` errors whenever prime symbols (`\gamma'`) occurred in math mode.
  - Replaced `\usepackage{hanging}` with an isolated macro definition of `hangparas` (`\hangindent` + `\hangafter` via `\everypar`), allowing full, clean PDF generation in VS Code without TeX capacity or math mode collision errors.
- **Hanging Indentation Standardization**:
  - Standardized `MA_precis.tex`, `ling_209_paper.tex`, `ling_200b_paper.tex`, `ling_200c_paper.tex`, `ling_201c_final_paper.tex`, and `ling_205_final_paper.tex` to have uniform hanging indentation (`\begin{hangparas}{.25in}{1}`) with single spacing.
- **Attic Greek (205) Built-in References**:
  - Converted bibliography from `biblatex`/`biber` to a built-in `\section{References}` using `\begin{hangparas}{.25in}{1}` containing the full citations for all cited authors (Alexiadou & Doron 2012, Bobaljik 2000, Embick 1997, Grestenberger 2015/2019, Halle & Marantz 1993, Merchant 2015, Ramón 2014, Reed 2014, Schreiner 2021, Tronci 2018).

---

## 7. Literature: `academic/samples/literature/` Additions

Created and standardized three papers converted from Google Docs markdown sources in `academic/samples/literature/`:

### 1. `adormo_baudelaire.tex` (*Boredom in Adorno, Baudelaire, and Benjamin*)
- **Layout & Structure**: 12pt article, 1-inch margins, `\doublespacing` body, `fancyhdr` header (`Ian Thomas White` / `\thepage \ of \pageref{LastPage}`), title page suppression (`\thispagestyle{empty}`), and `\tableofcontents` with `\newpage`.
- **Foreign Language & Accents**: Loaded fontenc `[LGR, T1]`, babel `[greek.ancient, english]`, and alphabeta for French and German accents (*ennui*, *ménagerie*, *vie moderne*, *Gallerte*, *Kristall*, etc.).
- **Typography & Quotes**: Formatted extended excerpts as single-spaced blockquotes. Structured Baudelaire's poem *Au Lecteur* in an appendix with proper LaTeX `verse` environment.
- **Footnotes & Citations**: Transformed all 53 markdown endnotes into proper in-text `\footnote{...}` elements. Built-in `Works Cited` section with hanging indentation (`\begin{hangparas}{.25in}{1}`).
- **Spelling & Objective Grammar Corrections**:
  - Fixed typos: `extolation` $\rightarrow$ `extollation`, `defacto` $\rightarrow$ `de facto`, `apparati` $\rightarrow$ `apparatuses`, `insofar as something they comprise` $\rightarrow$ `insofar as they comprise`, `It maybe possible` $\rightarrow$ `It may be possible`, `while Adorno does, like Baudelaire, maintains` $\rightarrow$ `while Adorno, like Baudelaire, maintains`, `aporiai` $\rightarrow$ `aporiae`.
  - Punctuation/cleanups: Footnote 39 `Nor is this “mistake” seem negatively motivating` $\rightarrow$ `Nor does this “mistake” seem negatively motivating`.

### 2. `lysistrata.tex` (*Lysistrata's Unproductive Wool-Working and Its Origin in Penelope*)
- **Layout & Structure**: 12pt article, 1-inch margins, `\doublespacing` body, `fancyhdr` header (`Ian Thomas White` / `\thepage \ of \pageref{LastPage}`), `\thispagestyle{empty}`, and `\tableofcontents`. All original document paragraph divisions and indentations preserved.
- **Section Heading**: Bibliography section titled `\section*{References}` with corresponding TOC entry.
- **Foreign Language & Greek Typography**: Polytonic Greek rendered cleanly across the text (e.g., ὑπερῷον, καταβαίνω, πόλεμον τολυπεύειν, δόλους τολυπεύω, ποιήσαι τολύπην μεγάλην, φᾶρος, χλαῖνα, etc.).
- **Tables**:
  - **Table 1 (Scansions)**: Formatted with shaded light gray columns for feet 5 and 7 (`>{\columncolor{graycol}}c`), dark gray accent for the frame line (`\cellcolor{darkergray}`), vertical borders on speech blocks, and proper caesura dividers ($\mid$).
  - **Table 2 (Conversational Sequence)**: Two-tier header structure (`Lysistrata` | `Proboulos` | `Lysistrata`) with precise vertical separators matching source design.
  - **Table 3 (Wool Sequences Matrix)**: Multi-row spanned cells, solid horizontal section dividers (`\hline`), and dashed horizontal/vertical borders (`\hdashline`, `:c:c:...:`) via `arydshln`.
- **Footnotes & Citations**:
  - Fixed footnote numbering sequence around Table 1: Footnote 26 is placed in the preceding paragraph, Footnote 27 is attached to line 585 in Table 1 (`\footnotemark` / `\footnotetext`), and Footnote 28 begins the subsequent text ("I don't want to be accused of special pleading..."), maintaining a complete 1-to-1 correspondence across all 54 footnotes.
  - References formatted with standard inverted/hanging indentation (`\begin{hangparas}{.25in}{1}`).
- **Spelling & Objective Grammar Corrections**:
  - Fixed typos: `PRoboulos` $\rightarrow$ `Proboulos`, `fit the the sense` $\rightarrow$ `fit the sense`, `stripp` $\rightarrow$ `strip`, `divied up map` $\rightarrow$ `divided up map`, `Penelope’s rouse` $\rightarrow$ `Penelope’s ruse`, `sheering` $\rightarrow$ `shearing`, `“to performe` $\rightarrow$ `“to perform`, `identical citationa` $\rightarrow$ `identical citations`, `the *hyperoone* refers` $\rightarrow$ `the *hyperoon* refers`, `dis-and-rerobing` $\rightarrow$ `dis- and rerobing`, `share the use one particular word` $\rightarrow$ `share the use of one particular word`, `which is doesn’t vary` $\rightarrow$ `which doesn’t vary`, `tactic tantalization` $\rightarrow$ `tactile tantalization`, `useable` $\rightarrow$ `usable`.

### 3. `marx_aristotle.tex` (*Commodity Value in Marx and Aristotle*)
- **Layout & Structure**: Title set to *Commodity Value in Marx and Aristotle*. Standard 12pt article, 1-inch margins, `fancyhdr` header (`Ian Thomas White` / `\thepage \ of \pageref{LastPage}`), `\thispagestyle{empty}`, and `\tableofcontents`.
- **Foreign Language & Greek/German Typography**: Full polytonic Greek support for Aristotle quotations and terminology (e.g., οὔτ᾿ ἰσότης μὴ οὔσης συμμετρίας, τῇ μὲν οὖν ἀληθείᾳ, νόμισμα, μέσος, ὑποκείμενον, οὐσία, etc.), and German economic terminology (*Gallerte*, *Kristall*, *Substanz*, *Kommensurabilität*).
- **Tables & Quotes**: Converted the Substratum argument progression comparison into a formatted `tabularx` table with clear column headers. Formatted Marx and Aristotle excerpts into single-spaced blockquotes.
- **Footnotes & Citations**: Converted all 48 markdown endnotes into in-text `\footnote{...}` commands. Built-in `Works Cited` with hanging indentation (`\begin{hangparas}{.25in}{1}`).
- **Spelling & Objective Grammar Corrections**:
  - Fixed typos: `Tranlsated` $\rightarrow$ `Translated`, `Intersting` $\rightarrow$ `Interesting`, `in tum` $\rightarrow$ `in turn`, `heiddeger` $\rightarrow$ `Heidegger`, `germaine` $\rightarrow$ `germane`, `.Let us now` $\rightarrow$ `Let us now`, `capital one` $\rightarrow$ `chapter one`.
  - Normalized placeholder works cited entries for Postone, Derrida, Heidegger, and Marx's doctoral dissertation.

