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
- For `biblatex`-managed documents (`ling_201c_final_paper.tex`, `ling_205_final_paper.tex`, `deverbals3.tex`, `weaving.tex`), hanging indentation was made explicit and uniform with `\setlength{\bibhang}{0.5in}` alongside `apa` style hanging indentation.
- For manual bibliographies (such as syllabus text lists and precis references), hanging indentation environments (`\begin{hangparas}{.25in}{1}`) are preserved.

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
- **Formatting**:
  - Explicit hanging indentation: `\setlength{\bibhang}{0.5in}` added to preamble with `biblatex`.
- **Spelling / Grammar**:
  - Line 266: Fixed `A consituent is` $\rightarrow$ `A constituent is`.

#### 3. `ling_205_final_paper.tex`
- **Formatting**:
  - Explicit hanging indentation: `\setlength{\bibhang}{0.5in}` added to preamble with `biblatex`.
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
