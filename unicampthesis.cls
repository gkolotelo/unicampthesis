%
% LaTeX class for UNICAMP styled monographs, dissertations and theses,
% compliant with INFORMAÇÃO CCPG/001/2015 to the best of my knowledge.
%
% Tested with pdflatex, Version 3.14159265-2.6-1.40.18 (MiKTeX 2.9.6350 64-bit)
%
% Copyright (c) 2018 Guilherme Kairalla Kolotelo.
%
% This document is available at "https://github.com/gkolotelo/unicampthesis".
% Please, let me know if there any any problems with this version by submitting an issue.
%
% This work is licensed under the terms of the MIT license.
% For a copy, see <https://opensource.org/licenses/MIT>.
%
% Packages required by unicampthesis class:
%   abntex2cite, amsmath, amssymb, amstext, amsthm, babel, etoolbox,
%   fancyhead, fontenc, graphicx, hyperref, hyphenat, ifthen, indentfirst,
%   inputenc, layout, microtype, nomencl, setspace, tocloft, url, xcolor
%
%
% The following line executes makeindex to generate required files for nomencl,
% add it to the top of main tex file. "--shell-escape" flag is required.
% \immediate\write18{makeindex -s nomencl.ist -o "\jobname.nls" "\jobname.nlo"}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{unicampthesis}[2018/06/09 unicampthesis_v1.4] % Added nomencl support and fixed references style, along with minor fixes (gkk)
%\ProvidesClass{unicampthesis}[2018/06/06 unicampthesis_v1.3] % Minor Fixes (gkk)
%\ProvidesClass{unicampthesis}[2018/04/12 unicampthesis_v1.2] % Minor Fixes (gkk)
%\ProvidesClass{unicampthesis}[2018/02/14 unicampthesis_v1.1] % Major revamp (gkk)
%\ProvidesClass{unicampthesis}[2017/09/06 unicampthesis_v1.0] % Initial concept (gkk)

% To-dos:
%   - Implement list of algorithms, annex, appendix, approval
%   - Support multiple supervisors automatically
%   - French and Spanish language defaults


% ---------------------------------------------------------------------------
% ------------------------------- Class Options -----------------------------
% ---------------------------------------------------------------------------

% Load base report class
\LoadClass[]{report}

% onesided or twosided
\DeclareOption{oneside}{
    \PassOptionsToClass{\CurrentOption}{report}
    \gdef\@oneside
}
\DeclareOption{twoside}{
    \PassOptionsToClass{\CurrentOption}{report}
    \gdef\@twoside
}

% upcase: Small caps selection
\DeclareOption{upcaseauthor}{
    \typeout{unicampthesis info: Small caps on author name.}
    \gdef\choosecaseauthor#1{\textsc{\expandafter{#1}}}
}
\def\choosecaseauthor#1{#1}

\DeclareOption{upcasetitle}{
    \typeout{unicampthesis info: Small caps on thesis title.}
    \gdef\choosecasetitle#1{\textsc{\expandafter{#1}}}
}
\def\choosecasetitle#1{#1}

\DeclareOption{upcaseheadtitle}{
    \typeout{unicampthesis info: Small caps on section titles.}
    \gdef\choosecasehead#1{\textsc{\expandafter{#1}}}
}
\def\choosecasehead#1{#1}

% Sets babel to brazil and sets up envoronment for single language
\DeclareOption{brazil}{
    \typeout{unicampthesis info: Portuguese set as main language}
    \gdef\@mainlanguage{brazil}
}
% Sets babel to foreing lang and sets up envoronment for multi-lang
\DeclareOption{USenglish}{
    \typeout{unicampthesis info: English set as main language}
    \gdef\@mainlanguage{USenglish}
}
\DeclareOption{spanish}{
    \typeout{unicampthesis info: Spanish set as main language}
    \gdef\@mainlanguage{spanish}
}
\DeclareOption{french}{
    \typeout{unicampthesis info: French set as main language}
    \gdef\@mainlanguage{french}
}

% Sets environment for selected style
\DeclareOption{undergrad}{
    \typeout{unicampthesis info: Undergrad Thesis} % Monografia
    \gdef\@undergrad{}
    \gdef\@thesistypedefined{}
}
\DeclareOption{masters}{
    \typeout{unicampthesis info: Masters Thesis} % Dissertacao
    \gdef\@masters{}
    \gdef\@thesistypedefined{}
}
\DeclareOption{doctorate}{
    \typeout{unicampthesis info: Doctorate Thesis} % Tese
    \gdef\@doctorate{}
    \gdef\@thesistypedefined{}
}

% ABNT arabic citation style
\DeclareOption{abnt-num}{
  \typeout{unicampthesis info: Reference style anbt-num}
  \gdef\@citationformat{abntex2-num}
  \gdef\@citationformatabntex{num}
}

% ABNT name/year citation style
\DeclareOption{abnt-alf}{
  \typeout{unicampthesis info: Reference style abnt-alf}
  \gdef\@citationformat{abntex2-alf}
  \gdef\@citationformatabntex{alf}
}

% Pass non-treated options to report class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

\ProcessOptions\relax

% Check options
\ifdefined\@mainlanguage\else
    \gdef\@mainlanguage{brazil}
    %\ClassError{unicampthesis}{Main language undefined!}
\fi
\ifdefined\@thesistypedefined\else
    \ClassError{unicampthesis}{Thesis type undefined!}
\fi
\ifdefined\@citationformat\else
    \typeout{unicampthesis info: Reference style ieeetr}
    \gdef\@citationformat{ieeetr}
\fi


% ---------------------------------------------------------------------------
% ---------------------------- Required Packages ----------------------------
% ---------------------------------------------------------------------------

% Supporting packages
\RequirePackage{etoolbox}
\RequirePackage{ifthen}
\RequirePackage{graphicx}
\RequirePackage{url}
\RequirePackage{xcolor}
\RequirePackage{hyphenat}
\RequirePackage{tocloft}
\RequirePackage{titlesec}

% Math packages
\RequirePackage{amsmath, amssymb, amstext, amsthm}

% Support for T1 (8-bit) font encoding and UTF-8 file encoding
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
% Better font expansion and character protrusion
\RequirePackage{microtype}

% Color definitions
\definecolor{link_blue}{RGB}{1,106,125}
\definecolor{link_darkblue}{RGB}{24,78,91}

% References hyperlinking and customization
\RequirePackage{hyperref}
\hypersetup{
    breaklinks = true,
    colorlinks=true, % set true if you want colored links
    linktoc=all,     % set to all if you want both sections and subsections linked
    linkcolor=link_blue, % choose some color if you want links to stand out
    urlcolor=link_blue,
    citecolor=link_blue,
    % testing:
    debug = true,
    plainpages = false,
    bookmarksopen = true,
    bookmarksnumbered = true,
    %hyperindex = true,
    verbose = true,
    pdfpagelayout = SinglePage,
    pdfdisplaydoctitle = true
}

% Nomenclature
\RequirePackage{nomencl}
\makenomenclature

% Headers and footers
\RequirePackage{fancyhdr}
% Used to redefine titles of chapters, sections, etc...

% Babel
\RequirePackage[\@mainlanguage]{babel}

% Margins and paragraphs
\RequirePackage[top=3cm,bottom=3cm,right=2cm,left=2cm]{geometry}
\setlength{\parindent}{1cm}
% USenglish does not indent first paragraph
\ifthenelse{\equal{\@mainlanguage}{USenglish}}{}{
    %\let\@afterindentfalse\@afterindenttrue
    \RequirePackage{indentfirst}
}


% ABsurd Norms for TeX setup
% \ifdefined\@citationformat
%     \RequirePackage[
%         \@citationformatabntex,
%         % testing:
%         abnt-and-type = &,
%         abnt-emphasize = bf,
%         abnt-etal-cite = 2,
%         abnt-etal-list = 3,
%           % abnt-etal-text = it,
%         abnt-repeated-title-omit = yes,
%         abnt-show-options = warn,
%         abnt-verbatim-entry = no,
%         abnt-url-package = url
%         abnt-doi = doi
%     ]{abntex2cite}
% \fi

% For 1.5 line spacing
\RequirePackage{setspace}
\spacing{1.5} % (in accordance to CCPG/001/2015))
\selectfont


% ---------------------------------------------------------------------------
% ---------------------- Language Specific Definitions ----------------------
% ---------------------------------------------------------------------------

% Portuguese defaults
\ifthenelse{\equal{\@mainlanguage}{brazil}}{    
    \def\@namecover{Capa}
    \def\@nametitlepage{Contra Capa}
    \def\@namecatalogcard{Ficha Catalográfica}
    \def\@nameapproval{Página de Aprovação}
    \def\@nameabstract{Resumo}
    \def\@namededications{Dedicatórias}
    \def\@nameack{Agradecimentos}
    \def\@namefigures{Lista de Figuras}
    \def\@nametables{Lista de Tabelas}
    \def\@namealgorithms{Lista de Algorítmos}
    \def\@namenomenclature{Nomenclatura}
    \def\@nametoc{Sumário}
    \def\@namebib{Referências Bibliográficas}
    \def\@nameappendix{Apêndice}
    \def\@nameannex{Anexo}
    \def\@namekeywords{Palavras-Chave}
}{}
\def\@nameabstractBR{Resumo}
\ifdefined\@undergrad
    \def\@nametitleBR{Bacharel}
    \def\@namethesisBR{Monografia}
\fi
\ifdefined\@masters
    \def\@nametitleBR{Mestre}
    \def\@namethesisBR{Dissertação}
\fi
\ifdefined\@doctorate              
    \def\@nametitleBR{Doutor}
    \def\@namethesisBR{Tese}
\fi
\def\@namesupervisorBR{Orientador}
\def\@namesupervisorfemalesuffixBR{a}
\def\@fillertitleBRI{apresentada à}
\def\@fillertitleBRII{da Universidade Estadual de Campinas como parte dos requisitos exigidos para a obtenção do título de}
\def\@fillertitleBRIII{na área de}

% Foreign languages:
\ifthenelse{\equal{\@mainlanguage}{USenglish}}{    
    \def\@namecover{Cover}
    \def\@nametitlepage{Title Page}
    \def\@namecatalogcard{Catalog Card}
    \def\@nameapproval{Approval Page}
    \def\@nameabstract{Abstract}
    \def\@namededications{Dedications Page}
    \def\@nameack{Acknowledgements}
    \def\@namefigures{List of Figures}
    \def\@nametables{List of Tables}
    \def\@namealgorithms{List of Algorithms}
    \def\@namenomenclature{Nomenclature}
    \def\@nametoc{Table of Contents}
    \def\@namebib{References}
    \def\@nameappendix{Appendix}
    \def\@nameannex{Annex}
    \def\@namekeywords{Keywords}
    \ifdefined\@undergrad
        \def\@nametitleFGN{Bachelor}
        \def\@namethesisFGN{Monograph}
    \fi
    \ifdefined\@masters
        \def\@nametitleFGN{Master of Science}
        \def\@namethesisFGN{Dissertation}
    \fi
    \ifdefined\@doctorate              
        \def\@nametitleFGN{Doctor of Philosophy}
        \def\@namethesisFGN{Thesis}
    \fi
    \def\@namesupervisorFGN{Supervisor}
    \def\@namesupervisorfemalesuffixFGN{}
    % Filler texts:
    \def\@fillertitleFGNI{presented to the}
    \def\@fillertitleFGNII{of the University of Campinas in partial fulfillment of the requirements for the degree of}
    \def\@fillertitleFGNIII{in the field of}
}{}
% To-do:
\ifthenelse{\equal{\@mainlanguage}{french}}{    
    \def\@namecover{fill_in_the_blank!}
    \def\@nametitlepage{fill_in_the_blank!}
    \def\@namecatalogcard{fill_in_the_blank!}
    \def\@nameapproval{fill_in_the_blank!}
    \def\@nameabstract{fill_in_the_blank!}
    \def\@namededications{fill_in_the_blank!}
    \def\@nameack{fill_in_the_blank!}
    \def\@namefigures{fill_in_the_blank!}
    \def\@nametables{fill_in_the_blank!}
    \def\@namealgorithms{fill_in_the_blank!}
    \def\@namenomenclature{fill_in_the_blank!}
    \def\@nametoc{fill_in_the_blank!}
    \def\@namebib{fill_in_the_blank!}
    \def\@nameappendix{fill_in_the_blank!}
    \def\@nameannex{fill_in_the_blank!}
    \def\@namekeywords{fill_in_the_blank!}
    \ifdefined\@undergrad
        \def\@nametitleFGN{fill_in_the_blank!}
        \def\@namethesisFGN{fill_in_the_blank!}
    \fi
    \ifdefined\@masters
        \def\@nametitleFGN{fill_in_the_blank!}
        \def\@namethesisFGN{fill_in_the_blank!}
    \fi
    \ifdefined\@doctorate              
        \def\@nametitleFGN{fill_in_the_blank!}
        \def\@namethesisFGN{fill_in_the_blank!}
    \fi
    \def\@namesupervisorFGN{fill_in_the_blank!}
    \def\@namesupervisorfemalesuffixFGN{fill_in_the_blank!}
    % Filler texts:
    \def\@fillertitleFGNI{fill_in_the_blank!}
    \def\@fillertitleFGNII{fill_in_the_blank!}
    \def\@fillertitleFGNIII{fill_in_the_blank!}
}{}
\ifthenelse{\equal{\@mainlanguage}{spanish}}{    
    \def\@namecover{fill_in_the_blank!}
    \def\@nametitlepage{fill_in_the_blank!}
    \def\@namecatalogcard{fill_in_the_blank!}
    \def\@nameapproval{fill_in_the_blank!}
    \def\@nameabstract{fill_in_the_blank!}
    \def\@namededications{fill_in_the_blank!}
    \def\@nameack{fill_in_the_blank!}
    \def\@namefigures{fill_in_the_blank!}
    \def\@nametables{fill_in_the_blank!}
    \def\@namealgorithms{fill_in_the_blank!}
    \def\@namenomenclature{fill_in_the_blank!}
    \def\@nametoc{fill_in_the_blank!}
    \def\@namebib{fill_in_the_blank!}
    \def\@nameappendix{fill_in_the_blank!}
    \def\@nameannex{fill_in_the_blank!}
    \def\@namekeywords{fill_in_the_blank!}
    \ifdefined\@undergrad
        \def\@nametitleFGN{fill_in_the_blank!}
    \fi
    \ifdefined\@masters
        \def\@nametitleFGN{fill_in_the_blank!}
        \def\@namethesisFGN{fill_in_the_blank!}
    \fi
    \ifdefined\@doctorate              
        \def\@nametitleFGN{fill_in_the_blank!}
        \def\@namethesisFGN{fill_in_the_blank!}
    \fi
    \def\@namesupervisorFGN{fill_in_the_blank!}
    \def\@namesupervisorfemalesuffixFGN{fill_in_the_blank!}
    % Filler texts:
    \def\@fillertitleFGNI{fill_in_the_blank!}
    \def\@fillertitleFGNII{fill_in_the_blank!}
    \def\@fillertitleFGNIII{fill_in_the_blank!}
}{}


% ---------------------------------------------------------------------------
% --------------------------- General Definitions ---------------------------
% ---------------------------------------------------------------------------

% UNICAMP name
\def\Unicamp{Universidade Estadual de Campinas}

% Department (e.g.: Faculdade de Engenharia Mecânica)
\def\department#1#2{\gdef\@departmentFGN{#1}\gdef\@departmentBR{#2}}
\def\@departmentBR{\@latex@error{No \noexpand\department given}\@ehc}

% Abstract
\def\textabstract#1#2{\gdef\@textabstractFGN{#1}\gdef\@textabstractBR{#2}}
\def\@textabstractBR{\@latex@error{No \noexpand\textabstract given}\@ehc}

% Month and year
% \def\degreemonth#1{\gdef\@degreemonth{#1}}
% \def\@degreemonth{\@latex@error{No \noexpand\degreemonth given}\@ehc}
\def\degreeyear#1{\gdef\@degreeyear{#1}}
\def\@degreeyear{\@latex@error{No \noexpand\degreeyear given}\@ehc}

% Author
\def\author#1{\gdef\@author{#1}}
\def\@author{\@latex@error{No \noexpand\author given}\@ehc}

% Supervisors and cosupervisors
\def\supervisor#1{\gdef\@supervisor{#1}}
\def\@supervisor{\@latex@error{No \noexpand\supervisor given}\@ehc}

\def\supervisorII#1{\gdef\@supervisorII{#1}}
\def\supervisorIII#1{\gdef\@supervisorIII{#1}}

\def\cosupervisor#1{\gdef\@cosupervisor{#1}}
\def\cosupervisorII#1{\gdef\@cosupervisorII{#1}}
\def\cosupervisorIII#1{\gdef\@cosupervisorIII{#1}}

% Thesis title \title{FGN (leave blank if pt only)}{PT}
\def\title#1#2{
    \ifthenelse{\equal{\@mainlanguage}{brazil}}{
        \gdef\@titleFGN{}
    }{
        \gdef\@titleFGN{#1}
    }
    \gdef\@titleBR{#2}
}
\def\@titleBR{\@latex@error{No \noexpand\title given}\@ehc}

% Degree name \degree{FGN (leave blank if pt only)}{PT}
\def\degree#1#2{
\ifthenelse{\equal{\@mainlanguage}{brazil}}{
        \gdef\@degreeFGN{}
    }{
        \gdef\@degreeFGN{#1}
    }
    \gdef\@degreeBR{#2}
}
\def\@degreeBR{\@latex@error{No \noexpand\degree given}\@ehc}

% Field/area. Comment out if not applicable. \field{FGN (leave blank if pt only)}{PT}
\def\field#1#2{
\ifthenelse{\equal{\@mainlanguage}{brazil}}{
        \gdef\@fieldFGN{}
    }{
        \gdef\@fieldFGN{#1}
    }
    \gdef\@fieldBR{#2}
}


% ---------------------------------------------------------------------------
% ---------------------------- Style Definitions ----------------------------
% ---------------------------------------------------------------------------

% How many levels of section head would you like numbered?
% 0= no section numbers, 1= section, 2= subsection, 3= subsubsection
\setcounter{secnumdepth}{3}

% How many levels of section head would you like to appear in the Table of Contents?
% 0= chapter titles, 1= section titles, 2= subsection titles, 
% 3= subsubsection titles.
\setcounter{tocdepth}{2}

% Section spacing
\titlespacing*{\section}{0pt}{1\baselineskip}{1\baselineskip}
\titlespacing*{\subsection}{0pt}{0.5\baselineskip}{0.5\baselineskip}
\titlespacing*{\subsubsection}{0pt}{0.5\baselineskip}{0.5\baselineskip}

% Section font size
\titleformat{\section}{\normalfont\fontsize{18}{22}\bfseries}{\thesection}{1em}{}
\titleformat{\subsection}{\normalfont\fontsize{16}{18}\bfseries}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\normalfont\fontsize{14}{18}\bfseries}{\thesubsubsection}{1em}{}

% Chapter font
\DeclareFontFamily{T1}{cinzel}{}
% T1 encoding, Cinzel family, Medium series, Normal shape as all sizes Cinzel-Regular-lf-t1
\DeclareFontShape{T1}{cinzel}{m}{n}{<->s * Cinzel-Regular-lf-t1}{}
% T1 encoding, Cinzel family, Bold series, Normal shape as all sizes Cinzel-Bold-lf-t1
% \DeclareFontShape{T1}{cinzel}{b}{n}{<->s * Cinzel-Bold-lf-t1}{}

% Sections header title appearance
\def\headfont#1{\bfseries\expandafter{#1}}
\def\headtitle#1{\centering\huge\headfont{\choosecasehead{\expandafter{#1}}}}

% Custom page styles
% First sections do not have page numbering in accordance to CCPG/001/2015
\fancypagestyle{frontmatter}{
    \fancyhf{}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
    \setlength{\headsep}{10pt}
    \setlength{\marginparwidth}{45pt}
}

\fancypagestyle{mainmatter}{
    \fancyhf{}
    \renewcommand{\headrulewidth}{0.3pt}
    \renewcommand{\footrulewidth}{0pt}
    \setlength{\headsep}{20pt}
    \setlength{\marginparwidth}{45pt}
    \ifdefined\@oneside
        \fancyhead[R]{\thepage}
        \fancyhead[L]{\leftmark}
    \else
        \fancyhead[LO]{\leftmark}
        \fancyhead[RE]{\rightmark}
        \fancyhead[LE,RO]{\thepage}
    \fi
}

\fancypagestyle{chapmatter}{
    \fancyhf{}
    \renewcommand{\headrulewidth}{0.3pt}
    \renewcommand{\footrulewidth}{0pt}
    \setlength{\headsep}{10pt}
    \setlength{\marginparwidth}{45pt}
    \ifdefined\@oneside
        \fancyhead[R]{\thepage}
    \else
        \fancyhead[LE,RO]{\thepage}
    \fi
}

\fancypagestyle{refmatter}{
    \fancyhf{}
    \renewcommand{\headrulewidth}{0.3pt}
    \renewcommand{\footrulewidth}{0pt}
    \setlength{\headsep}{10pt}
    \ifdefined\@oneside
        \fancyhead[R]{\thepage}
        \fancyhead[L]{\leftmark}
    \else
        \fancyhead[LO]{\leftmark}
        \fancyhead[RE]{\rightmark}
        \fancyhead[LE,RO]{\thepage}
    \fi
}

% Redefinition of chapter header for custom font and format.
%\patchcmd{\chapter}{\thispagestyle{plain}}{\thispagestyle{mainmatter}}{}{}
\renewcommand{\@makechapterhead}[1]{
    \cleardoublepage
    \pagestyle{mainmatter}
    \thispagestyle{chapmatter}
    \spacing{1}
    \begin{flushleft}
        \parindent\z@\normalfont\fontfamily{cinzel}\fontseries{m}\selectfont\@chapapp\space\thechapter\linebreak
        \LARGE#1\par\nobreak
        \vspace{12pt}
        \hrule width \hsize height 0.3pt \kern .5mm
    \end{flushleft}
    \vspace{18pt}
    \spacing{1.5}
}

% Redefinition of chapter* to fix nomenclature
\renewcommand{\@makeschapterhead}[1]{
    \thispagestyle{frontmatter}
    \vspace*{-12pt}
    \begin{center}
        \headtitle{#1}
    \end{center}
}

% Redefinition of thebibliography to fix pagestyles
\renewenvironment{thebibliography}[1]{
    \chapter*{\refname}%
    \pagestyle{refmatter}
    \thispagestyle{chapmatter}
    \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
    \list{
        \@biblabel{\@arabic\c@enumiv}
    }%
    {
        \settowidth\labelwidth{\@biblabel{#1}}%
        \leftmargin\labelwidth
        \advance\leftmargin\labelsep
        \@openbib@code
        \usecounter{enumiv}%
        \let\p@enumiv\@empty
        \renewcommand\theenumiv{\@arabic\c@enumiv}
    }%
    \sloppy
    \clubpenalty4000
    \@clubpenalty \clubpenalty
    \widowpenalty4000%
    \sfcode`\.\@m
}
{\def\@noitemerr{\@latex@warning{unicampthesis info: Empty `thebibliography' environment}}\endlist}


% ---------------------------------------------------------------------------
% ---------------------- Preliminary Pages Definitions ----------------------
% ---------------------------------------------------------------------------

% ---------------------------------- Cover ----------------------------------
\def\makecover{
    \setcounter{page}{1}
    \clearpage
    \pdfbookmark[0]{\@namecover}{cover}
    \hypersetup{pageanchor=false}
    \pagestyle{frontmatter}
    \spacing{1}\selectfont
    \begin{minipage}[c]{0.17\textwidth}
        \includegraphics[scale = 0.15]{uec}
    \end{minipage}
    \begin{minipage}[c]{0.77\textwidth}
        \begin{center}
            {\LARGE \textsc{\Unicamp}} \\
            \vspace{0.2cm}
            {\large \textsc{\@departmentBR}}
        \end{center}
    \end{minipage}
    \vspace{1cm}
    \begin{center}
        \setlength{\parskip}{2mm}
        \vspace{2cm}
        {\Large  \choosecaseauthor{\@author}}
        \par
        \vspace{2cm}
        {\def\baselinestretch{1.2}\huge\bf\choosecasetitle{\@titleFGN}\par}
        \par
        \vspace{1cm}
        {\def\baselinestretch{1.2}\huge\bf\choosecasetitle{\@titleBR}\par}
    \end{center}
    \vfill
    \begin{center}
        {\large\textbf{\textsc{Campinas}}}
        \par
        {\large\textbf{\textsc{\@degreeyear}}}
    \end{center}
}

% -------------------------------- Title Page -------------------------------
\def\maketitle{
    \clearpage
    \pdfbookmark[0]{\@nametitlepage}{titlepage}
    \hypersetup{pageanchor=false}
    \pagestyle{frontmatter}
    \spacing{1}\selectfont
    \begin{minipage}[c]{0.17\textwidth}
        \includegraphics[scale = 0.15]{uec}
    \end{minipage}
    \begin{minipage}[c]{0.77\textwidth}
        \begin{center}
            {\LARGE \textsc{\Unicamp}} \\
            \vspace{0.2cm}
            {\large \textsc{\@departmentBR}}
        \end{center}
    \end{minipage}
    \par
    \vspace{0.6cm}
    \begin{center}
        {\large\choosecaseauthor{\@author}}
        \par
        \vspace{0.6cm}
        \ifthenelse{\equal{\@mainlanguage}{brazil}}{
            \vspace{\baselineskip}
        }{
            {\def\baselinestretch{1.2}\Large\bf\choosecasetitle{\@titleFGN}\par}
        }
        \par
        \vspace{0.2cm}
        {\def\baselinestretch{1.2}\Large\bf\choosecasetitle{\@titleBR}\par}
    \end{center}
    \begin{center}
    \vfill
        \begin{minipage}[c]{.45\textwidth}
            \vspace{4cm}
            \openup 0.2em
            \ifthenelse{\equal{\@mainlanguage}{brazil}}{
                \ifdefined\femaleSupervisor
                    {\noindent\textbf{\@namesupervisorBR\@namesupervisorfemalesuffixBR:}}
                \else
                    {\noindent\textbf{\@namesupervisorBR:}}
                \fi
                \nohyphens\@supervisor\\
                \ifdefined\@supervisorII
                    \ifdefined\femaleSupervisorII
                        {\noindent\textbf{\@namesupervisorBR\@namesupervisorfemalesuffixBR:}}
                    \else
                        {\noindent\textbf{\@namesupervisorBR:}}
                    \fi
                    \nohyphens\@supervisorII\\
                \fi
                \ifdefined\@supervisorIII
                    \ifdefined\femaleSupervisorIII
                        {\noindent\textbf{\@namesupervisorBR\@namesupervisorfemalesuffixBR:}}
                    \else
                        {\noindent\textbf{\@namesupervisorBR:}}
                    \fi
                    \nohyphens\@supervisorIII\\
                \fi
                \ifdefined\@cosupervisor
                    \ifdefined\femaleCosupervisor
                        {\noindent\textbf{Co-\@namesupervisorBR\@namesupervisorfemalesuffixBR:}}
                    \else
                        {\noindent\textbf{Co-\@namesupervisorBR:}}
                    \fi
                    \nohyphens\@cosupervisor\\
                \fi
                \ifdefined\@cosupervisorII
                    \ifdefined\femaleCosupervisorII
                        {\noindent\textbf{Co-\@namesupervisorBR\@namesupervisorfemalesuffixBR:}}
                    \else
                        {\noindent\textbf{Co-\@namesupervisorBR:}}
                    \fi
                    \nohyphens\@cosupervisorII\\
                \fi
                \ifdefined\@cosupervisorIII
                    \ifdefined\femaleCosupervisorIII
                        {\noindent\textbf{Co-\@namesupervisorBR\@namesupervisorfemalesuffixBR:}}
                    \else
                        {\noindent\textbf{Co-\@namesupervisorBR:}}
                    \fi
                    \nohyphens\@cosupervisorIII\\
                \fi
            }{
                \ifdefined\femaleSupervisor
                    {\noindent\textbf{\@namesupervisorFGN\@namesupervisorfemalesuffixFGN:}}
                \else
                    {\noindent\textbf{\@namesupervisorFGN:}}
                \fi
                \@supervisor\\
                \ifdefined\@supervisorII
                    \ifdefined\femaleSupervisorII
                        {\noindent\textbf{\@namesupervisorFGN\@namesupervisorfemalesuffixFGN:}}
                    \else
                        {\noindent\textbf{\@namesupervisorFGN:}}
                    \fi
                    \nohyphens\@supervisorII\\
                \fi
                \ifdefined\@supervisorIII
                    \ifdefined\femaleSupervisorIII
                        {\noindent\textbf{\@namesupervisorFGN\@namesupervisorfemalesuffixFGN:}}
                    \else
                        {\noindent\textbf{\@namesupervisorFGN:}}
                    \fi
                    \nohyphens\@supervisorIII\\ 
                \fi
                \ifdefined\@cosupervisor
                    \ifdefined\femaleCosupervisor
                        {\noindent\textbf{Co-\@namesupervisorFGN\@namesupervisorfemalesuffixFGN:}}
                    \else
                        {\noindent\textbf{Co-\@namesupervisorFGN:}}
                    \fi
                    \nohyphens\@cosupervisor\\
                \fi
                \ifdefined\@cosupervisorII
                    \ifdefined\femaleCosupervisorII
                        {\noindent\textbf{Co-\@namesupervisorFGN\@namesupervisorfemalesuffixFGN:}}
                    \else
                        {\noindent\textbf{Co-\@namesupervisorFGN:}}
                    \fi
                    \nohyphens\@cosupervisorII\\
                \fi
                \ifdefined\@cosupervisorIII
                    \ifdefined\femaleCosupervisorIII
                        {\noindent\textbf{Co-\@namesupervisorFGN\@namesupervisorfemalesuffixFGN:}}
                    \else
                        {\noindent\textbf{Co-\@namesupervisorFGN:}}
                    \fi
                    \nohyphens\@cosupervisorIII\\
                \fi
            }

            % Line intentionally left blank
            \openup -0.2em
            % To-do: automate for multiple supervisor/cosupervisor
            \ifdefined\finalversiontext
               \footnotesize\textsc{\noindent\ignorespaces\finalversiontext}
            \fi
            % {\footnotesize\textsc{Este exemplar corresponde à versão final da \MakeLowercase{\@namethesisBR}\space defendida
            % \ifdefined\femaleAuthor
            %    pela aluna
            % \else
            %    pelo aluno
            % \fi
            % \nohyphens\@author,
            % e orientada
            % \ifdefined\femaleSupervisor
            %    pela Profa. Dra.
            % \else
            %    pelo Prof. Dr.
            % \fi
            % \nohyphens\@supervisor
            % \ifdefined\@supervisorII
            %     \ifdefined\@supervisorIII
            %         ,
            %     \else
            %         e
            %     \fi
            %     \ifdefined\femaleSupervisor
            %        pela Profa. Dra.
            %     \else
            %        pelo Prof. Dr.
            %     \fi
            %     \nohyphens\@supervisorII
            % \fi
            % }}
        \end{minipage}
        \hfill
        \begin{minipage}[b]{.45\textwidth}
            \ifthenelse{\equal{\@mainlanguage}{brazil}}{}{
                \@namethesisFGN \space
                \@fillertitleFGNI \space
                \@departmentFGN \space
                \@fillertitleFGNII \space
                \@degreeFGN\unskip
                \ifdefined\@fieldFGN
                    ,\space\@fillertitleFGNIII\space\@fieldFGN\unskip
                \fi
                .
                \par
                \vspace{1cm}
            }
            \@namethesisBR \space
            \@fillertitleBRI \space
            \@departmentBR \space\unskip
            \@fillertitleBRII \space
            \@degreeBR\unskip
            \ifdefined\@fieldBR
                ,\space\@fillertitleBRIII\space\@fieldBR\unskip
            \fi
            .
            \vspace{1cm}
            \ifthenelse{\equal{\@mainlanguage}{brazil}}{\vspace{2.5cm}}{}
        \end{minipage}
    \vfill
    \end{center}
    \noindent
    % Signature field not needed
    % {\small\textbf{Assinatura
    % \ifdefined\femaleSupervisor
    %     {\noindent\textbf{da orientadora:}}
    % \else
    %     {\noindent\textbf{do orientador:}}
    % \fi
    % }
    % \par
    % \vspace{.3cm}
    % \noindent
    % \rule[1pt]{7cm}{.5pt}  % Linha para assinatura do orientador
    % }
    % \vspace{.4cm}
    % \ifdefined\@cosupervisor
    % \noindent
    % {\small\textbf{Assinatura
    % \ifdefined\femaleCosupervisor
    %     {\noindent\textbf{da coorientadora:}}
    % \else
    %     {\noindent\textbf{do coorientador:}}
    % \fi
    % }
    % \par
    % \vspace{.3cm}
    % \noindent
    % \rule[1pt]{7cm}{.5pt}  % Linha para assinatura do coorientador
    % }
    % \fi
    \vfill
    \begin{center}
        {\large\textbf{\textsc{Campinas}}}
        \par
        {\large\textbf{\textsc{\@degreeyear}}}
    \end{center}
}

% ------------------------------ Approval Page ------------------------------
% Not yet implemented
% \def\makeapprovalpage{
%     \pdfbookmark[0]{\@nameapproval}{approval}
% }

% ----------------------------- Dedications Page ----------------------------
\def\makededications{
    \clearpage
    \pagestyle{frontmatter}
    \pdfbookmark[0]{\@namededications}{dedications}
    \begin{center}
        \vspace*{\fill}
            \centering
            \large\textdedications
        \vspace*{\fill}
    \end{center}
    \cleardoublepage
}

% ----------------------------- Acknowledgements ----------------------------
\def\makeacknowledgements{
    \clearpage
    \pagestyle{frontmatter}
    \pdfbookmark[0]{\@nameack}{acknowledgements}
    \vspace*{0pt}
    \begin{center}
        \headtitle{\@nameack}
    \end{center}
    \vskip 2\baselineskip
    \textacknowledgements
}

% -------------------------------- Abstract ---------------------------------
\def\makeabstract{
    \cleardoublepage
    \pagestyle{frontmatter}
    \hypersetup{pageanchor=true}
    \ifthenelse{\equal{\@mainlanguage}{brazil}}{}{
        \pdfbookmark[0]{\@nameabstract}{abstract}
        \vspace*{0pt}
        \begin{center}
            \headtitle{\@nameabstract}
        \end{center}
        \vskip 2\baselineskip
        \@textabstractFGN
        \clearpage
    }
    \pdfbookmark[0]{\@nameabstractBR}{resumo}
    % This is ugly, but I couldn't find a better way to remove the added whitespace
    \ifthenelse{\equal{\@mainlanguage}{brazil}}{\vspace*{0pt}}{\vspace*{-13pt}}
    \begin{center}
        \headtitle{\@nameabstractBR}
    \end{center}
    \vskip 2\baselineskip
    \@textabstractBR
}

% ----------------------------- List of Figures -----------------------------
\def\makefigureslist{
    \cleardoublepage
    \pdfbookmark[0]{\@namefigures}{lof}
    \pagestyle{empty}
    \setlength{\cftbeforeloftitleskip}{17pt}
    \renewcommand{\listfigurename}{\hfill\headtitle{\@namefigures}\hfill}   
    \addtocontents{lof}{\protect\thispagestyle{frontmatter}}
    \listoffigures
}

% ------------------------------ List of Tables -----------------------------
\def\maketableslist{
    \pdfbookmark[0]{\@nametables}{lot}
    \cleardoublepage
    \pagestyle{empty}
    \setlength{\cftbeforelottitleskip}{17pt}
    \renewcommand{\listtablename}{\hfill\headtitle{\@nametables}\hfill}   
    \addtocontents{lot}{\protect\thispagestyle{frontmatter}}
    \listoftables
}

% ---------------------------- List of Algorithms ---------------------------
% Not yet implemented
% \def\makealgorithmslist{
% \pdfbookmark[0]{\@namealgorithms}{loa}
%
% }

% ------------------------------- Nomenclature ------------------------------
\def\makenomencl{
    \cleardoublepage
    \pdfbookmark[0]{\@namenomenclature}{nomenclature}
    \pagestyle{frontmatter}
    %\nomenclature{}{\protect\thispagestyle{frontmatter}}
    \renewcommand\nomname{\@namenomenclature}
    \printnomenclature

}

% ---------------------------- Table of Contents ----------------------------
\def\maketoc{
    \cleardoublepage
    \hypersetup{pageanchor=true}
    \pdfbookmark[0]{\@nametoc}{toc}
    \pagestyle{empty}
    \addtocontents{toc}{\protect\thispagestyle{frontmatter}}
    \setlength{\cftbeforetoctitleskip}{17pt}
    \renewcommand{\contentsname}{\hfill\headtitle{\@nametoc}\hfill}   
    \renewcommand{\cftaftertoctitle}{\hfill}
    \spacing{1.5}
    \tableofcontents
}

% ------------------------------- Bibliography ------------------------------
\def\makebibliography#1{
    \cleardoublepage
    \renewcommand\bibname{\headtitle{\@namebib}}
    \bibliographystyle{\@citationformat}
    \bibliography{#1}
    \pagestyle{refmatter}
    \addcontentsline{toc}{chapter}{\@namebib}
}

% --------------------------------- Appendix --------------------------------
% Work in progress
\def\makeappendix{
   \pdfbookmark[0]{\@nameappendix}{appendix}
   \appendix
   \renewcommand{\chaptername}{\@nameappendix}
}

% ---------------------------------- Annex ----------------------------------
% Not yet implemented
% \def\makeannex{
%    \pdfbookmark[0]{\@nameannex}{annex}
% }