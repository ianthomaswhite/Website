% Student template for LING 200B.
%
% Author:        Ethan Poole
% Last modified: 6 November 2020

% Base the handout class on the article class.
\LoadClass[11pt]{article}

% Text area dimensions.
%\settypeblocksize{7.75in}{32pc}{*}
%\setlrmargins{*}{*}{1}
%\setulmargins{*}{*}{1}
\checkandfixthelayout
%\raggedbottom


% Packages.
\usepackage{expex}
\usepackage[linguistics]{forest}
\usepackage{soulutf8}
\usepackage{xspace}
\usepackage{pifont}


% Point markers.
\let\oldmarginpar\marginpar
\renewcommand{\marginpar}[1]{\-\oldmarginpar[#1]{\itshape #1}}
\setlength{\marginparsep}{1.5em}
\setlength{\marginparwidth}{1.3in}

% Exercise number markers.
\newcounter{Ex}
\newcommand{\exercise}[1]{%
    \vspace*{0.4in}%
    \noindent%
    \refstepcounter{Ex}%
    \begin{flushright}
        \fbox{\fontsize{19pt}{19pt}\sans\hspace*{3.5em}%
        \arabic{Ex}\hspace{.5ex}}\marginpar{#1}%
    \end{flushright}
    \vspace{-2.5em}
    \noindent}

% Examples.
\lingset{
    aboveglftskip=-1.25em,
    belowglpreambleskip=0pt,
    everyglpreamble=\it,
    everygla={},
    aboveexskip=1.5ex,
    %belowexskip=0.25ex,
    interpartskip=0em}
}
\gathertags

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% General macros.
\newcommand{\ml}[2][]{\textit{#2}\ifx&#1&\else\ `#1'\fi}
\newcommand{\br}[1]{$[$\,#1\,$]$}
\newcommand{\lb}[2]{\ensuremath{[_\text{#1}\,\text{#2}\,]}}
\newcommand{\gap}[0]{\rule[-1.25pt]{1.5em}{0.75pt}\,}
\newcommand{\ind}[1]{\ensuremath{_{#1}}}
\newcommand{\exnum}[1]{(\getfullref{#1})}
\newcommand{\unpronounced}[1]{\st{\mbox{#1}}}

% Phrase structure macros.
\newcommand{\head}[1]{#1$^0$}
\newcommand{\spec}[1]{\mbox{[Spec, #1]}}
\newcommand{\comp}[1]{\mbox{[Comp, #1]}}
\newcommand{\xbar}[1]{$\overline{\textrm{#1}}$}

% Features.
\newcommand{\feature}[1]{{\scshape [#1]}}
\newcommand{\ja}[0]{\ding{51}}
\newcommand{\hf}[1]{\feature{$+$#1$+$}}
\newcommand{\shf}[1]{\hphantom{\scriptsize\,\ja}\hf{#1}{\scriptsize\,\ja}}
\newcommand{\mf}[1]{\feature{$\bullet$#1$\bullet$}}
\newcommand{\smf}[1]{\hphantom{\scriptsize\,\ja}\mf{#1}{\scriptsize\,\ja}}

% Shorthands.
\newcommand{\vP}[0]{\textit{v}P\xspace}
\newcommand{\littlev}[0]{\textit{v}\xspace}
\newcommand{\Merge}[0]{\textssc{Merge}\xspace}
\newcommand{\Agree}[0]{\textssc{Agree}\xspace}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\usepackage{tikz}
\usetikzlibrary{
    arrows,
    decorations.markings,
    positioning
}

% Default styles.
\tikzset{
    text height=0.65em,
    >=stealth
}
\tikzstyle{every picture}+=[>=stealth, anchor=base, text depth=0ex]

% In-line Tikz nodes.
\newcommand{\tkn}[2]{%
    ~\tikz[na]{\node[yshift=-0.2ex](#1){\hspace*{-0.5ex}#2};~}}
\tikzstyle{na} = [remember picture,
                  baseline=-0.2ex,
                  inner xsep=0pt,
                  inner ysep=4pt,
                  outer xsep=0ex]

% Bracket diagrams.
\newenvironment{tikzbracket}{\begin{tikzpicture}[overlay, remember
    picture]}{\end{tikzpicture}}

% Basic line styles.
\tikzset{
    mvt/.style = {rounded corners=1pt, semithick},
    binding/.style = {rounded corners=1pt, semithick},
    agree/.style = {rounded corners=1pt, dotted, very thick},
    reconstruct/.style = {densely dashed},
    predication/.style = {densely dashed},
    %
    focus/.style = {
        semithick, decorate,
        decoration={snake, amplitude=0.4ex, segment length=1.25ex,
        post length=0.75ex}, transform canvas={yshift=-1ex}},
    %
    o/.style = {
        shorten >=#1,
        shorten <=#1,
        decoration={
            markings,
            mark= at position 0 with
                { \fill circle [xshift=#1,radius=#1]; } ,
            mark= at position 1 with
                { \fill circle [xshift=-#1,radius=#1]; } ,
        },
        postaction=decorate
    },
    o/.default=1.75pt
}

% Arrow labels.
\tikzset{
    arrow-label/.style = {pos=0.25, yshift=0.9ex, font=\itshape\small},
    arrow-label-below/.style = {
        pos=0.25, below, font=\itshape\small, yshift=0.4ex},
    mvt-type/.style = {font=\scshape},
    arrow-icon/.style = {pos=0.25, yshift=-0.7ex}
}

% Movement arrows.
\tikzset{
    pics/mvt/.style n args={2}{code={
        \draw [->, mvt] (#1.south) -- ++(0, -\ArrowHeight) -| (#2.south);
    }},
    pics/mvt-above/.style n args={2}{code={
        \draw [->, mvt] (#1.north) -- ++(0, \ArrowHeight) -| (#2.north);
    }},
    pics/mvt-label/.style n args={3}{code={
        \draw [->, mvt] (#1.south) -- ++(0, -\ArrowHeight) -| (#2.south)
            node [arrow-label] {#3};
    }},
    pics/mvt-above-label/.style n args={3}{code={
        \draw [->, mvt] (#1.north) -- ++(0, \ArrowHeight) -| (#2.north)
            node [arrow-label-below] {#3};
    }},
}

% Lengths.
\newlength{\ArrowHeight}
\setlength{\ArrowHeight}{2.5ex}
\newlength{\BelowArrowSkip}
\setlength{\BelowArrowSkip}{2.75ex}
\newlength{\AboveArrowSkip}
\setlength{\AboveArrowSkip}{2.75ex}
\newlength{\AboveArrowSkipWithHeader}
\setlength{\AboveArrowSkipWithHeader}{3.25ex}

% Trees.
\forestset{
    default preamble = {for tree={
        text height=1em, inner ysep=0.5ex, s sep=1em, edge={semithick},
        text depth={}, l sep=1em
    }},
    unpronounced/.style = {text=gray, for descendants={text=gray, edge=gray}},
}
