%! Class = akiotex
%! Author = Akioweh
%! Date = 10/2/2023

\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{akiotex}[2023-10-11 An amended version of article.cls that enforces a set of %
predefined formatting and layout features for modern akiotex works (based on personal preference). %
Includes useful packages and any patches/fixes for them as well as certain QOL macros.]


% =============== Options ===============

% use kvoptions as parser
\RequirePackage{kvoptions}

\DeclareBoolOption[true]{author}            % bool: whether author should be shown on titlepage
\DeclareBoolOption[true]{date}              % bool: whether date should be shown on titlepage
\DeclareBoolOption[true]{contents}          % bool: whether a table of contents should be generated
\DeclareBoolOption[true]{separatecontents}  % bool: place ToC after titlepage or on same page?
\DeclareStringOption[single]{linespacing}   % [single|onehalf|double]: the document's line spacing
\DeclareBoolOption[false]{debug}            % bool: currently unused
\DeclareBoolOption[false]{compacteqs}       % bool: whether to use reduced spacing between equations and text
\DeclareBoolOption[true]{bib}               % bool: whether to support a bibliography (uses biblatex with biber)

\ProcessKeyvalOptions*\relax

% validate linespacing option
\newif\ifAK@validlinespacing
\AK@validlinespacingfalse  % default to false

\def\AK@single{single}
\def\AK@onehalf{onehalf}
\def\AK@double{double}

\ifx\akiotex@linespacing\AK@single \AK@validlinespacingtrue \fi
\ifx\akiotex@linespacing\AK@onehalf \AK@validlinespacingtrue \fi
\ifx\akiotex@linespacing\AK@double \AK@validlinespacingtrue \fi

\ifAK@validlinespacing\else
    \PackageError{akiotex}{Invalid value for linespacing option.}
\fi


% =============== Load external class and packages ===============

\LoadClass[11pt,a4paper]{article}

\RequirePackage{geometry}
\geometry{%
    a4paper,
    textwidth=374.4bp,  % 5.2in
    textheight=619.2bp, % 8.6in
    top=100bp
}
\RequirePackage[T1]{fontenc}
\RequirePackage{setspaceenhanced}
\RequirePackage{microtype}
\RequirePackage[american]{babel}
\RequirePackage[hypcap=true]{caption}
\RequirePackage{csquotes}
\RequirePackage{scrextend}
\RequirePackage{enumitem}
\RequirePackage{wrapfig2}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{xfrac}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{multirow}
\RequirePackage{siunitx}
\RequirePackage{array}
\RequirePackage{xurl}
\RequirePackage{regexpatch}
\ifakiotex@bib
    \RequirePackage[
        sorting=nty,
        backend=biber,
        style=apa,  % somehow 99% of akiotex science submissions require APA bib style... why???
        backref=true
    ]{biblatex}
\fi
\RequirePackage{float}
\RequirePackage[section]{placeins}
\RequirePackage{titlesec}
\RequirePackage[thinc]{esdiff}
\RequirePackage[hidelinks,hypertexnames=false]{hyperref}
\RequirePackage{bookmark}
\RequirePackage{calc}
\RequirePackage[unit=bp,use-siunitx=true]{lengthconvert}


% =============== Random Setups ===============

\graphicspath{{./figs/}, {./imgs/}}  % set default subfolders to look for pictures in
\ifakiotex@bib
    \addbibresource{main.bib}  % you better be naming your bibtex file main
\fi


% =============== Styling (Skips) ===============

% set line spacing using setspace package
\ifx\akiotex@linespacing\AK@onehalf
    \onehalfspacing
\fi \ifx\akiotex@linespacing\AK@double
    \doublespacing
\fi
% define basic skips in proportion to line spacing
\newlength{\@parskip}  % paragraph spacing; half of line height
\newlength{\@parskipS}
\setlength{\@parskip}{0.5\baselineskip plus 0.07\baselineskip minus 0.07\baselineskip}
\setlength{\@parskipS}{0.5\baselineskip plus 0.2\baselineskip minus 0.2\baselineskip}  % \@parskip with more stretch
\newlength{\@normalsize}  % save current font size as a length
\setlength{\@normalsize}{\f@size pt}
\newlength{\@linegap}  % gap between consecutive lines
\setlength{\@linegap}{\baselineskip - \@normalsize}
\RequirePackage[
    skip=\@parskip,
    indent,
    %parfill=0pt
]{parskip}

% define skips around display math environments
\ifakiotex@compacteqs
    % with compacteqs option
    \g@addto@macro\normalsize{%
        \setlength{\abovedisplayskip}{0pt plus 0.5pt minus 0.2pt}
        \setlength{\belowdisplayskip}{0pt plus 0.5pt minus 0.2pt}
        \setlength{\abovedisplayshortskip}{0pt plus 0.5pt minus 0.2pt}
        \addtolength{\abovedisplayshortskip}{-\baselineskip}
        \setlength{\belowdisplayshortskip}{0pt plus 0.5pt minus 0.2pt}
    }
\else
    % normal suggested spacing
    \g@addto@macro\normalsize{%
        \setlength{\abovedisplayskip}{\@parskipS}
        \setlength{\belowdisplayskip}{\@parskip}
        \setlength{\abovedisplayshortskip}{\@parskip}
        \addtolength{\abovedisplayshortskip}{-\baselineskip}
        \setlength{\belowdisplayshortskip}{\@parskipS}
    }
\fi

% define skips around floats
\setlength{\textfloatsep}{2.3\@parskip}  % between float and text
\setlength{\intextsep}{1.15\@parskip}    % between float and text when inline (no \par)
\setlength{\floatsep}{1.15\@parskip}     % between floats
\setlength{\@fpsep}{\floatsep}           % between floats on a float-only page


% =============== Styling (Other) ===============

\setcounter{tocdepth}{3}  % set ToC levels to show

% define caption style
\captionsetup{font=footnotesize}
\captionsetup{belowskip=0pt,aboveskip=\@linegap}

% default float placement options
\floatplacement{figure}{!htbp}
\floatplacement{table}{H}

% modify footnote number style
\deffootnote[1.5em]{1.5em}{1em}{%
    \makebox[1.5em][l]{\thefootnotemark}%
}

% bibliography style (use smaller font and obey parskip)
\ifakiotex@bib
    \renewcommand*{\bibfont}{\normalfont\small\raggedright}  % left-aligned bibliography with reduced font size
    \setlength{\bibitemsep}{\@parskip}  % add space between bibliography entries
\fi

% custom small header with \paragraph
\titleformat{\paragraph}[hang]{\normalfont\normalsize\bfseries}{\theparagraph}{0pt}{}
\titlespacing{\paragraph}{0pt}{2\parskip}{\parskip}


% =============== Patching Biblatex ===============

\ifakiotex@bib
    % More fields in citations
    % hacking in a way to include the website title in bibliography entries (for ONLINE types)
    % using the "maintitle" field for that...
    % first gotta make it non-italics because it defaultly is
    \DeclareFieldFormat[online]{maintitle}{\textup{#1}}

    % then insert it in the appropriate place
    \xpatchbibdriver{online}{%
        \usebibmacro{title}%
    }{%
        \usebibmacro{title}%
        \newunit\newblock
        \printfield{maintitle}%
    }{}{}
\fi


% =============== Custom Macros ===============

\newcommand{\lb}{\vspace{\baselineskip}}  % quick insert empty line
\newcommand{\pskip}{\vspace{\parskip}}  % quick insert default paragraph spacing

\newcommand*\tageq{\refstepcounter{equation}\tag{\theequation}}  % tag equation in *-ed ams environments
% usage (before the end of a line in starred ams environments): <equation> \tageq\label{<id>} \\

\renewcommand{\d}[1]{\ensuremath{\mathop{\mathrm{d}{#1}}}}  % proper dx differential operators
% usage: \d{<variable>}

\newcommand{\vbreak}{\leavevmode\vspace{-2\baselineskip}}  % weird hack for now to break out of vmode without extra spacing
% useful between wrapfig and lists to avoid catastrophic duckery

\ifakiotex@bib  % insert bibliography with a consistent section header
    \newcommand{\makebibliography}{\printbibliography[heading=bibnumbered]}
\fi


% =============== Custom Environments ===============

% environment whos contents are placed at the bottom of the page; ``bottom-aligned''
\newenvironment{bottompar}{\par\vspace*{\fill}}{\clearpage}

% bulleted list with normal line spacing and no indentation
\newenvironment{itemizenospace}{%
    \begin{list}{-}{%
        \setlength{\partopsep}{\parskip}
        \setlength{\topsep}{-\parskip}  % assuming parskip package already adds space
        \setlength{\parskip}{0pt}
        \setlength{\parsep}{0pt}
        \setlength{\itemsep}{0pt}
        \setlength{\leftmargin}{\parindent}
        \setlength{\listparindent}{\parindent}
        \setlength{\labelsep}{0.5em}
        \setlength{\labelwidth}{1.5em}
        \setlength{\itemindent}{0pt}
    }
}{%
    \end{list}%
}

% numbered list with normal line spacing and no indentation
\newcounter{enumnscounter}
\newenvironment{enumeratenospace}{%
    \begin{list}{\arabic{enumnscounter}.}{%
        \usecounter{enumnscounter}
        \setlength{\partopsep}{\parskip}
        \setlength{\topsep}{-\parskip}  % assuming parskip package already adds space
        \setlength{\parskip}{0pt}
        \setlength{\parsep}{0pt}
        \setlength{\itemsep}{0pt}
        \setlength{\leftmargin}{\parindent}
        \setlength{\listparindent}{\parindent}
        \setlength{\labelsep}{0.5em}
        \setlength{\labelwidth}{1em}
        \setlength{\itemindent}{0pt}
    }
}{%
    \end{list}%
}

% better version of the above
\newlist{enumns}{enumerate}{1}  % enumitem custom list
\setlist[enumns]{%
    label=\arabic*.,
    align=left,
    leftmargin=\parindent,
    labelwidth=*,
    labelsep=*,
    labelindent=0pt,
    itemsep=0pt, parsep=0pt,
    topsep=-\parskip,
    partopsep=\parskip%
}

% table things
% new array math column types
\newcolumntype{L}{>{$}l<{$}}  % left-aligned math mode
\newcolumntype{C}{>{$}c<{$}}  % center-aligned math mode
\newcolumntype{R}{>{$}r<{$}}  % right-aligned math mode


% =============== Title & Contents ===============

% Extra fields on title page
% set them using \subtitle{<text>} and \titlenotes{<text>}
% they will only be displayed when set
\let\@subtitle\empty
\newcommand{\subtitle}[1]{\renewcommand{\@subtitle}{#1}}
\let\@titlenotes\empty
\newcommand{\titlenotes}[1]{\renewcommand{\@titlenotes}{#1}}

% helper maketitle command
\newcommand{\akiotex@maketitle}{%
    \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
    \hb@xt@1.8em{%
        \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
%
    %\newpage
    \global\@topnum\z@   % Prevents figures from going at top of page.
    \null
    \vskip 2em
    \begin{center}%
        \let \footnote \thanks
        {\LARGE \@title \par}%
        \vskip 1.5em%
        \ifakiotex@author
            {\large \lineskip .5em
            \begin{tabular}[t]{c}%
                \@author
            \end{tabular}\par}%
        \fi
        \vskip 1em%
        \ifakiotex@date
            {\large \@date}%
        \fi
    \end{center}%
    \thispagestyle{empty}\@thanks
    \endgroup
    \pagenumbering{Alph}%
}

% modified maketitle command
% it makes a clean title page along with a table of contents if the options specify to
\renewcommand{\maketitle}{%
    \let\saved@thepage\thepage
    \let\thepage\relax
%
    \akiotex@maketitle
%
    \ifx\@subtitle\empty
    \else
        \ifx\@titlenotes\empty
            \vspace{3\baselineskip}%
        \else
            \vspace{\stretch{4}}%
        \fi
        \begin{center}%
            {\large \@subtitle}
        \end{center}%
    \fi
%
    \ifx\@titlenotes\empty
    \else
        \vspace{\stretch{4}}%
        \begin{bottompar}%
            \noindent {\large \@titlenotes}%
        \end{bottompar}%
    \fi
%
    \ifakiotex@contents
        \ifakiotex@separatecontents
            \clearpage
        \fi
        \tableofcontents
        \thispagestyle{empty}%
    \fi
%
    \clearpage
    \pagenumbering{arabic}%
    \let\thepage\saved@thepage
}


% =============== Info Stuff ===============

% calculate page margins
\newlength{\@Lmargin}
\setlength{\@Lmargin}{1in + \hoffset + \oddsidemargin}
\newlength{\@Rmargin}
\setlength{\@Rmargin}{\paperwidth - \textwidth - \@Lmargin}
\newlength{\@Tmargin}
\setlength{\@Tmargin}{1in + \voffset + \topmargin + \headheight + \headsep}
\newlength{\@Bmargin}
\setlength{\@Bmargin}{\paperheight - \textheight - \@Tmargin}
\newcommand{\pl}[1]{\Convert{#1}}  % printlength

% macro to print the values of all kinds of sizes and skips
\newcommand{\lengthinfo}{%
    \normalfont\normalsize\noindent textarea: \pl{\textwidth}~\texttimes~\pl{\textheight}
    \quad papersize: \pl{\paperwidth}~\texttimes~\pl{\paperheight}\\
    L-margin: \pl{\@Lmargin} \quad R-margin: \pl{\@Rmargin} \quad T-margin: \pl{\@Tmargin} \quad B-margin: \pl{\@Bmargin} \\
    Font size: \csname f@size\endcsname pt;
    normal baseline skip: \csname f@baselineskip\endcsname\\
    Stretch factor: \baselinestretch; resultant baseline skip: \the\baselineskip

    \noindent{\scriptsize scriptsize: \csname f@size\endcsname pt; baselineskip: \the\baselineskip}\\
    {\footnotesize footenotesize: \csname f@size\endcsname pt; baselineskip: \the\baselineskip}\\
    {\small small: \csname f@size\endcsname pt; baselineskip: \the\baselineskip}\\
    {\large large: \csname f@size\endcsname pt; baselineskip: \the\baselineskip}\\
    {\Large Large: \csname f@size\endcsname pt; baselineskip: \the\baselineskip}\\
    {\LARGE LARGE: \csname f@size\endcsname pt; baselineskip: \the\baselineskip}

    \noindent parskip: \the\@parskip \\
    textfloatsetp: \the\textfloatsep \qquad intextsep: \the\intextsep \qquad floatsep: \the\floatsep \quad fpsep: \the\@fpsep

    \noindent above: \the\abovedisplayskip \qquad below: \the\belowdisplayskip \\
    aboveshort: \the\abovedisplayshortskip \qquad belowshort: \the\belowdisplayshortskip
}


% =============== Patching Existing Envs ===============

% hack to make amsmath environments use shortskips when possible
% https://tex.stackexchange.com/a/386052/305653
% a new glue to store the amount we need to modify at the end of the display
\newskip\belowdisplayskip@mod
% a new box to store the left-hand side of the first line inside a split environment
\newbox\split@firstline@LHS
% redefine \start@align to incorporate a call to the check whether the preceding line is short enough
\xpatchcmd{\start@align}{%
    \collect@body\next@
}{%
    \collect@body\next@
    \shortskip@check
}{}{\PackageWarningNoLine{methtools}{Failed to patch \protect\start@align}}
% redefine \endalign to correct the belowskip
%\xpatchcmd{\endalign}{%
%    $$%
%}{%
%    $$%
%    \vspace{\belowdisplayskip@mod}%
%    \global\belowdisplayskip@mod\z@
%    \noindent
%}{}{\PackageWarningNoLine{methtools}{Failed to patch \protect\endalign}}

% Redefine \intertext@ to correct the belowskip. How we can patch this depends on whether mathtools has been loaded, hence we defer this action until \begin{document}.
\AtBeginDocument{%
    \@ifpackageloaded{mathtools}{\MHInternalSyntaxOn}{\makeatletter}%
    \xpatchcmd{\intertext@}{%
        \penalty\postdisplaypenalty\vskip\belowdisplayskip
    }{%
        \penalty\postdisplaypenalty\vskip\belowdisplayskip
        \vspace{\belowdisplayskip@mod}%
        \global\belowdisplayskip@mod\z@
    }{}{\PackageWarningNoLine{methtools}{Failed to patch \protect\intertext@}}
    \@ifpackageloaded{mathtools}{\MHInternalSyntaxOff}{\makeatother}%
}
% There is some weird behavior if split is used and the "tbtags" option is active. The first line of the split environment seems to be a dummy line set without any width on the left-hand side. Since shortskips need to be determined depending on the width of the first line, many split environments would erroneously be detected as qualifying for shortskips. To work around this we modify \insplit@ to explicitly measure the width of the left-hand side of the first line and further modify \rendsplit@ to insert an empty box of said width.
\xpatchcmd{\insplit@}{% Patching a command containing ## seems to require regexpatch's xpatchcmd.
    \ialign\bgroup
    \hfil
    \strut@
    $\m@th\displaystyle{##}$%
}{%
    \setbox\split@firstline@LHS\box\voidb@x
    \ialign\bgroup
    \hfil
    \strut@
    \setbox\@tempboxa\hbox{$\m@th\displaystyle{##}$}\unhcopy\@tempboxa
    \ifvoid\split@firstline@LHS
    \global\setbox\split@firstline@LHS\box\@tempboxa
    \fi
}{}{\PackageWarningNoLine{methtools}{Failed to patch \protect\insplit@}}
\xpatchcmd{\rendsplit@}{%
    \global\@tempcnta\column@
}{%
    \global\@tempcnta\column@
    \hbox to\wd\split@firstline@LHS{}%
}{}{\PackageWarningNoLine{methtools}{Failed to patch \protect\rendsplit@}}
% check whether shortskips should be used; if yes, immediately account for the aboveskip and save belowskip for later
\def\shortskip@check{%
    \ifmeasuring@\else
        \noalign{\shortskip@calc@shift@lc}%
        \ifdim\dimexpr\eqnshift@+\@tempdimb\relax > \predisplaysize
            \noalign{\vskip\glueexpr\abovedisplayshortskip-\abovedisplayskip\relax}%
            \noalign{\global\belowdisplayskip@mod=\glueexpr\belowdisplayshortskip-\belowdisplayskip\relax}%
        \fi
    \fi
}
% first helper function to calculate how much the first equation row is indented. amsmath documentation:
%    \cs{@tempdimb} will be the ``indentation'' of leftmost end of
%    text, ignoring the \cs{tabskip} glue, i.e., it will be the sum of
%    the maximum widths of any fields to the left of the first
%    non-empty field, plus whatever empty space there is at the
%    beginning of the first non-empty field.
\def\shortskip@calc@shift@lc{% based on amsmath \x@calc@shift@lc
    \row@\@ne
    \column@\z@
    \@tempdima\z@
    \@tempdimb\z@
    \edef\@tempb{\fieldlengths@\row@}%
    \@for\@tempa:=\@tempb\do{%
        \advance\column@\@ne
        \shortskip@lcalc@width
    }%
}
% second helper function to calculate how much the first equation row is indented. amsmath documentation:
%    This macro calculates the ``indentation'' of the current row, as
%    defined above under the description of \cs{x@calc@shift@lc}.
%    This macro is called for each field of the current line, with
%    \cs{@tempa} set to the width of the current field.  Ideally, the
%    loop enclosing \cs{x@lcalc@width} would terminate as soon as
%    \cs{@tempa} is non-zero, but that would be a bit tricky to
%    arrange.  Instead, we use \cs{@tempdima} as a flag to signal when
%    we've encountered the first non-empty field.
\def\shortskip@lcalc@width{% based on amsmath \x@lcalc@width
    \ifdim\@tempdima = \z@
        \ifdim\@tempa > \z@
            \@tempdima\p@
            \ifodd\column@
                \advance\@tempdimb \maxcol@width\column@
                \global\advance\@tempdimb-\@tempa
            \fi
            \count@\column@
            \advance\count@\m@ne
            \divide\count@\tw@
            \advance\@tempcnta-\count@
            \advance\@tempcntb-\count@
        \else
            \global\advance\@tempdimb \maxcol@width\column@\relax
        \fi
    \fi
}

\newcommand{\ShortSkip}{\vspace{\glueexpr\abovedisplayshortskip-\abovedisplayskip\relax}}


% patching the wrapfig shortfalls (did not work)

%\tracingpatches

%\xapptocmd{\WF@wr}{%
%    \captionsetup{type=figure}%
%}{\def\success{true}}{\def\success{false}}
%
%\ShowCommand\WF@wr
%\xpretocmd{\wraptable}{%
%    \captionsetup{type=table}
%}{}{}


% vertically compact brackets for lopsided fractions
% https://tex.stackexchange.com/a/418231/305653
\newcommand*{\shortenfences}[3]{%
    % #1: left fence without \left
    % #2: formula inside the fences
    % #3: right fence without \right
    \mathpalette{\@shortenfences{#1}{#3}}{#2}%
}
\newdimen\sf@dimen
\newcommand*{\@shortenfences}[4]{%
    % #1: left fence
    % #2: right fence
    % #3: math style
    % #4: formula
    \sbox0{$#3#4\m@th$}%
    \sbox2{$#3\vcenter{}$}%
    % \dimen0: height above math axis
    \dimen0=\dimexpr\ht0 - \ht2\relax
    \ifdim\dimen0<\z@
    \dimen0=\z@
    \fi
    % \dimen2: depth below math axis
    \dimen2=\dimexpr\ht2 + \dp0\relax
    \ifdim\dimen2<\z@
    \dimen2=\z@
    \fi
    % \sf@dimen: amount for lowering the inner formula
    % to center the inner formula.
    \sf@dimen=\dimexpr(\dimen0 - \dimen2)/2\relax
    % lower the inner formula and raise the outer formula with
    % the fences to keep the math axis.
    \raisebox{\sf@dimen}{%
        $#3\left#1\raisebox{-\sf@dimen}{\box0}\right#2\m@th$%
    }
}

\endinput