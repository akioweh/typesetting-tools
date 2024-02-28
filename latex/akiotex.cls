%! Class = akiotex
%! Author = Akioweh
%! Date = 10/2/2023

\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{akiotex}[2024-02-28 An amended version of article.cls that enforces a set of %
predefined formatting and layout features for modern akiotex works (based on personal preference). %
Includes useful packages and any patches/fixes for them as well as certain QOL macros.]


% =============== Options ===============

% use kvoptions as parser
\RequirePackage{kvoptions}

\DeclareStringOption[single]{linespacing}   % [single|onehalf|double]: the document's line spacing
\DeclareBoolOption[true]{author}            % bool: whether author should be shown on titlepage
\DeclareBoolOption[true]{date}              % bool: whether date should be shown on titlepage
\DeclareBoolOption[true]{contents}          % bool: whether a table of contents should be generated
\DeclareBoolOption[true]{separatetoc}       % bool: place ToC after titlepage or on same page?
\DeclareBoolOption[true]{bib}               % bool: whether to support a bibliography (uses biblatex with biber)
\DeclareBoolOption[false]{debug}            % bool: magic!
\DeclareBoolOption[false]{compacteqs}       % bool: whether to use reduced spacing between equations and text
\DeclareBoolOption[false]{timestamp}        % bool: whether to include a time of compilation in footer of title page
\DeclareBoolOption[false]{plotting}         % bool: whether to load pgfplots and tikz
\DeclareBoolOption[false]{compacttoc}       % bool: structures ToC in two columns to take up less vertical space
\DeclareBoolOption[false]{compacttitle}     % bool: various changes to make the title stuff take less space.
                                            % If this is on titlenotes are not allowed.
                                            % This is best used alongside compacttoc
\DeclareStringOption[alphabetic]{bibstyle}  % [apa|ieee|...] style of bibliography to use, passed to biblatex

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

\RequirePackage[
    a4paper,
    textwidth=374.4bp,  % 5.2in
    textheight=619.2bp, % 8.6in
    top=100bp
]{geometry}
\RequirePackage{luaotfload}
\RequirePackage{fontspec}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage[warnings-off={mathtools-colon,mathtools-overbracket}]{unicode-math}
\RequirePackage{microtype}
\RequirePackage{setspaceenhanced}
\RequirePackage{polyglossia}
\setdefaultlanguage[variant=us]{english}
\RequirePackage[hypcap=true]{caption}
\RequirePackage{csquotes}
\RequirePackage{scrextend}
\RequirePackage{enumitem}
\RequirePackage{wrapfig2}
\RequirePackage{xfrac}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{multirow}
\RequirePackage{siunitx}
\RequirePackage{physics}
\RequirePackage{physics2}
\RequirePackage{array}
\RequirePackage{regexpatch}
\ifakiotex@bib
    \RequirePackage[
        sorting=nty,
        backend=biber,
        style=\akiotex@bibstyle,
        backref=true
    ]{biblatex}
\fi
\RequirePackage{xurl}
\RequirePackage{float}
\RequirePackage[section]{placeins}
\RequirePackage[pagestyles]{titlesec}
\RequirePackage{titletoc}
\RequirePackage[thinc]{esdiff}
\RequirePackage[unicode,hidelinks,breaklinks=true]{hyperref}
\RequirePackage{bookmark}
\RequirePackage{calc}
\RequirePackage{fmtcount}
\RequirePackage[unit=bp,use-siunitx=true]{lengthconvert}
\RequirePackage[english,showdow]{datetime2}
\RequirePackage{multicol}
\ifakiotex@plotting
    \RequirePackage{tikz}
    \RequirePackage{pgfplots}
\fi
\ifakiotex@debug
    \RequirePackage{lua-visual-debug}
    %\geometry{showframe}
\fi

\usephysicsmodule[tightbraces=true]{ab}

% set fonts and also set emoji fallback font to have automatic and working emojis
\defaultfontfeatures{Ligatures=TeX}
\let\dl\directlua % we're aliasing here because TexifyIDEA intellij plugin is stupid
\dl{luaotfload.add_fallback("emojifallback",{"NotoEmoji:mode=harf;"})}
\setmainfont{Latin Modern Roman}[RawFeature={fallback=emojifallback}]
\setmathfont{Latin Modern Math}
\AtBeginDocument{% unicode-math blackboard bold fonts are weird...
  \let\mathbb\relax
  \DeclareMathAlphabet{\mathbb}{U}{msb}{m}{n}%
}

% silence siunitx warning about physics being loaded
\ExplSyntaxOn
\msg_redirect_name:nnn { siunitx } { physics-pkg } { none }
\ExplSyntaxOff


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

% space between text body and footnotes
\geometry{footnotesep=3\@parskip}


% =============== Styling (Other) ===============

\setcounter{tocdepth}{3}  % set ToC levels to show

% define caption style
\captionsetup{font=footnotesize}
\captionsetup{belowskip=0pt,aboveskip=\@linegap}

% default float placement options
\floatplacement{figure}{!htbp}
\floatplacement{table}{H}
\g@addto@macro\@floatboxreset{\centering}  % all floats contents are centered by default

% modify footnote number style
\deffootnote[1.5em]{1.5em}{1em}{%
    \makebox[1.5em][l]{\thefootnotemark}%
}

% bibliography style (use a smaller font, don't justify, and obey parskip)
\ifakiotex@bib
    \renewcommand*{\bibfont}{\normalfont\small\raggedright}  % left-aligned bibliography with reduced font size
    \setlength{\bibitemsep}{\@parskip}  % add space between bibliography entries
    % allow (almost) arbitrary linebreaking of URLs
    \setcounter{biburllcpenalty}{1}
    \setcounter{biburlucpenalty}{1}
    \setcounter{biburlnumpenalty}{1}
\fi

% custom small header with \paragraph
\titleformat{\paragraph}[hang]{\normalfont\normalsize\bfseries}{\theparagraph}{0pt}{}
\titlespacing{\paragraph}{0pt}{2\@parskipS}{\@parskip}

% custome datetime formats
\DTMnewdatestyle{akDT}{%
    \renewcommand{\DTMdisplaydate}[4]{%
        \DTMweekdayname{##4}\space
        \ordinalnum{##3}\space of\space
        \DTMmonthname{##2},\space
        ##1%
    }%
    \renewcommand{\DTMDisplaydate}{\DTMdisplaydate}%
}
\DTMnewtimestyle{akTM}{%
    \renewcommand{\DTMdisplaytime}[3]{%
        \def\THEHOUR{##1}\def\THEAMPM{AM}% Assume AM
        \ifnum##1>12
        \edef\THEHOUR{\number\numexpr##1-12}% Correct for...
        \edef\THEAMPM{PM}% ...PM
        \fi
        \THEHOUR:% <hh>
        \DTMtwodigits{##2}% <mm>
        \space\THEAMPM% AM/PM
    }%
}
\AfterEndPreamble{
    \DTMsetdatestyle{akDT}\DTMsettimestyle{akTM}  % for some reason doesnn't work if in preamble
    \allowdisplaybreaks  % let's also put this here; allowing multiline math environments to be broken across pages
}

% page style for custom title page header that includes compile time
\newpagestyle{title}{%
    \setfoot{}{}{\tiny Compiled \DTMnow}
}


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

\newcommand{\fdom}{\mathop{\mathrm{dom}}}
\newcommand{\fim}{\mathop{\mathrm{im}}}

\newcommand{\vbreak}{\leavevmode\vspace{-2\baselineskip}}  % weird hack for now to break out of vmode without extra spacing
% useful between wrapfig and lists to avoid catastrophic duckery

\ifakiotex@bib  % insert bibliography with a consistent section header
    \newcommand{\makebibliography}{\printbibliography[heading=bibnumbered]}
\fi

% \vb \va and \vu commands from the physics package
%\newcommand\vb{\@ifstar\boldsymbol\mathbf}
%\newcommand\va[1]{\@ifstar{\vec{#1}}{\vec{\mathrm{#1}}}}
%\newcommand\vu[1]{%
%    \@ifstar{\hat{\boldsymbol{#1}}}{\hat{\mathbf{#1}}}}

% defining extra trignometric functions
\DeclareMathOperator{\arccosh}{arccosh}
\DeclareMathOperator{\arcsinh}{arcsinh}
\DeclareMathOperator{\arctanh}{arctanh}
\DeclareMathOperator{\arcsech}{arcsech}
\DeclareMathOperator{\arccsch}{arccsch}
\DeclareMathOperator{\arccoth}{arccoth}

% text box thingie with a specified width and automatic height
\newcommand{\frametext}[2]{%
    % #1: width
    % #2: content of box
    \setlength{\fboxrule}{0.4pt}
    \fbox{%
        \begin{minipage}{\dimexpr #1 - 2\fboxsep - 2\fboxrule}%
            #2%
        \end{minipage}%
    }%
}

% hollow box of specified width and height
\DeclareDocumentCommand{\hollowbox}{ m m }{%
    \setlength{\fboxsep}{0pt}%
    \setlength{\fboxrule}{1pt}%
    \fbox{%
        \rule{\dimexpr #1 - 2pt}{0pt}%
        \rule[-1pt]{0pt}{\dimexpr #2 - 2pt}%
    }%
}
% invisible box of specified width and height
\DeclareDocumentCommand{\invisbox}{ m m }{%
    \phantom{\rule{#1}{#2}}%
}

% phnatom heights for weird cases
\newcommand{\mathfracstrut}{\vphantom{\frac{\mathstrut}{\mathstrut}}}


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

% simple environment to put nicely spaced hrules around certain content,
% with an optional ``header'' typset in bold, unindented.
\NewDocumentEnvironment{ruled}{o}{%
    \vskip -\lastskip% remove parskip if there was a preceding paragraph
    \vskip \dimexpr \@parskip + 3pt \relax
    \hrule height 0.5pt%
    \nopagebreak
    \vskip \dimexpr -\@parskip + 3.5pt \relax
    \IfValueTF{#1}{%
        \vskip 1pt%
        \nopagebreak
        \noindent\textbf{#1} \hskip\parfillskip
        \nopagebreak\break \indent
    }{}%
}{%
    \vskip -\lastskip
    \vskip 3pt%
    \nopagebreak
    \hrule height 0.5pt%
    \vskip 3pt%
    \par
}


% =============== Title & Contents ===============

% Extra fields on title page
% set them using \subtitle{<text>} and \titlenotes{<text>}
% they will only be displayed when set
\let\@subtitle\empty
\newcommand{\subtitle}[1]{\renewcommand{\@subtitle}{#1}}
\let\@titlenotes\empty
\newcommand{\titlenotes}[1]{\renewcommand{\@titlenotes}{#1}}

% compact ToC stuff
\ifakiotex@compacttoc
    \contentsmargin{1.5em}
    \addtocontents{toc}{\vspace{-0.6em}}

    \titlecontents{section}
        [1.3em]
        {\vspace{4pt plus 1pt minus 1pt}\filright\bfseries}
        {\contentslabel[\thecontentslabel]{1.3em}}
        {\hspace*{-1.3em}}
        {\hspace{\stretch{1}}\contentspage}
    \dottedcontents{subsection}[3em]{}{2em}{0.5pc}
    \dottedcontents{subsubsection}[5.6em]{}{3em}{0.5pc}
\fi

% helper maketitle command
\newcommand{\akiotex@maketitle}{%
    \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent\hb@xt@1.8em{\hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
%
    %\newpage
    \global\@topnum\z@   % Prevents figures from going at top of page.
    \let \footnote \thanks
    {\centering \LARGE \@title \par}%
    \ifakiotex@compacttitle
        \vskip 0.3em%
    \else
        \vskip 2em%
    \fi
    \ifakiotex@author{
        \centering \large %\lineskip .5em
        \begin{tabular}[t]{c}%
            \@author
        \end{tabular}\par
        }
        \ifakiotex@compacttitle\else
            \vskip 1em%
        \fi
    \fi

    \ifakiotex@date{
        \centering \large \@date \par
    }\fi
    \ifakiotex@timestamp%
        \thispagestyle{title}%
    \else%
        \thispagestyle{empty}%
    \fi%
    \@thanks
    \endgroup
    \pagenumbering{Alph}%
}

% modified maketitle command
% it makes a clean title page along with a table of contents if the options specify to
\renewcommand{\maketitle}{%
%    \let\saved@thepage\thepage
%    \let\thepage\relax
%
    \ifakiotex@compacttitle\else
        \vspace*{2em}%
    \fi
    \akiotex@maketitle
%
    \ifx\@subtitle\empty\else
        \ifx\@titlenotes\empty
            \ifakiotex@compacttitle\else
                \vspace{2\baselineskip}%
            \fi
        \else
            \vspace{\stretch{4}}%
        \fi
        {\centering\large \@subtitle \par}%
    \fi
%
    \ifx\@titlenotes\empty\else
        \ifakiotex@compacttitle
            \ClassWarningNoLine{akiotex}{Title notes are set along with option `compacttitle`; the notes will be ignored and not displayed.}
        \else
            \vspace{\stretch{4}}%
            \begin{bottompar}%
                \noindent {\large \@titlenotes}%
            \end{bottompar}%
        \fi
    \fi
%
    \ifakiotex@contents
        \ifakiotex@separatetoc
            \ifakiotex@compacttitle
                \ClassWarningNoLine{akiotex}{Compact title option set; ignoring `separatetoc` option.}
            \else
                \clearpage
            \fi
        \else
            \ifakiotex@compacttitle\else
                \vspace*{1em}%
            \fi
        \fi
%
        \ifakiotex@compacttoc
            \newlength{\@colsep}%
            \setlength{\@colsep}{\columnsep}%
            \setlength{\columnsep}{2em}%
            \begin{multicols}{2}
        \fi
        {\singlespacing \tableofcontents}
        \ifakiotex@compacttoc
            \end{multicols}
            \setlength{\columnsep}{\@colsep}
        \fi
%
        \thispagestyle{empty}%
    \fi
%
    \ifakiotex@compacttitle
        \thispagestyle{plain}%
    \else
        \clearpage
    \fi
    \pagenumbering{arabic}%
%    \let\thepage\saved@thepage
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
    \begingroup
    \hfuzz=\maxdimen
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
    textfloatsep: \the\textfloatsep \qquad intextsep: \the\intextsep \qquad floatsep: \the\floatsep \quad fpsep: \the\@fpsep

    \noindent above: \the\abovedisplayskip \qquad below: \the\belowdisplayskip \\
    aboveshort: \the\abovedisplayshortskip \qquad belowshort: \the\belowdisplayshortskip
    \endgroup
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

\xpatchcmd{\start@gather}{%
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
    \newif\if@firstempty
    \newif\if@secondempty
    \edef\@tempb{\fieldlengths@\row@}%
    \@for\@tempa:=\@tempb\do{%
        \advance\column@\@ne
        \shortskip@lcalc@width
        \ifnum\column@=\@ne
            \ifdim\@tempa=\z@
                \@firstemptytrue
            \fi
        \fi
        \ifnum\column@=\tw@
            \ifdim\@tempa=\z@
                \@secondemptytrue
            \fi
        \fi
    }%
    \if@firstempty
        \if@secondempty
                \global\advance\@tempdimb \alignsep@
        \fi
    \fi
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


% wrapfig better kinda thingie

\RequirePackage{environ}
\RequirePackage{xparse}
\RequirePackage{varwidth}
\RequirePackage{afterpage}

\ExplSyntaxOn
\DeclareExpandableDocumentCommand{\dimratioceil}{ m m }{%
    \fp_eval:n { ceil ( \dim_to_fp:n { #1 } / \dim_to_fp:n { #2 } , 0 ) }%
}
\DeclareExpandableDocumentCommand{\dimratiofloor}{ m m }{%
    \fp_eval:n { floor ( \dim_to_fp:n { #1 } / \dim_to_fp:n { #2 } , 0 ) }%
}
\ExplSyntaxOff

\newsavebox{\wp@image}

\NewDocumentEnvironment{wrappage}{O{0} m O{0} m O{0}}{\par
    % #1 (optional) is the number of lines until the end of the page
    % #2 is r (right) or l (left)
    % #3 (optional) is the number of lines for the image.
    % #4 width (or 0pt to compute).
    % #5 (optional) cropped lines # correction
    \xdef\wp@linesleftinpage{#1}%
    \newlength{\wp@heightleftinpage}%
    \setlength{\wp@heightleftinpage}{\wp@linesleftinpage\baselineskip}% height left in page as a dimension
    \ifnum\wp@linesleftinpage=0\relax% not supplied; calculate height of remaining page space
        \setlength{\wp@heightleftinpage}{\dimexpr \pagegoal-\pagetotal-0.5\baselineskip}% height left
        \xdef\wp@linesleftinpage{\the\numexpr \wp@heightleftinpage/\baselineskip}% divide height by baselineskip to get # of lines
    \fi
    \xdef\wp@side{#2}%
    \xdef\wp@figureheightlines{#3}%
    \newlength{\wp@figureheight}%
    \setlength{\wp@figureheight}{\wp@figureheightlines\baselineskip}%
    \xdef\wp@figurewidth{#4}%
    \xdef\wp@lcorr{#5}%

    \def\@captype{figure}% set type and help with hyperref hypcap
    \wp@environ
}{%
    \endwp@environ
    \ifnum\wp@figureheightlines=0\relax% not supplied; calculate height of figure in lines
        \setlength{\wp@figureheight}{\dimexpr \ht\wp@image+\dp\wp@image+\intextsep}% height of figure
        \xdef\wp@figureheightlines{\dimratioceil{\wp@figureheight}{\baselineskip}}% divide height by lineskip to get # of lines (ceil-ing-ed)
        \xdef\wp@figureheightlines{\the\numexpr \wp@figureheightlines + \wp@lcorr}% adjust by correction
    \fi
    \ifdim \wp@heightleftinpage>\wp@figureheight% enough space left; put figure on this page
        \AddToHookNext{para/before}{% execute normal wrapfig right before next paragraph
            \begin{wrapfigure}[\wp@figureheightlines]{\wp@side}{\wp@figurewidth}
                \box\wp@image
            \end{wrapfigure}%
        }%
    \else% figure won't fit on this page
        \if r\wp@side\relax
            \wp@right% put image on right side
        \else
            \if l\wp@side\relax
                \wp@left% put image on left side
            \else
                \errmessage{Bad wrappage argument: \textbf{\wp@side} must be \texbf{r} or \textbf{l}.}%
            \fi
        \fi
    \fi
}

\def\wp@rightx{% NOT WORKING
    \afterpage{% placement of figure
        \noindent\hspace{\dimexpr \textwidth-\wp@figurewidth}%
        \raisebox{\dimexpr \ht\strutbox-\height}[\ht\strutbox][0pt]{\box\wp@image}%
        \vskip-\baselineskip
    }%
    % adjustment of paragraph shape
    % generate list of right indents, per line
    \xdef\wp@parshapeR{\space}
%    \xdef\wp@parshapeL{\space}
    \edef\wp@totindent{\the\dimexpr \wp@figurewidth + \columnsep}
    \count2=0%
    \loop \ifnum\count2 < \wp@figureheightlines% loop for as many lines as the height of the figure
        \advance\count2 by 1%
%        \xdef\wp@parshapeL{\wp@parshapeL0pt,}%
        \xdef\wp@parshapeR{\wp@parshapeR\wp@totindent,}%
    \repeat
    % finally, reset, just in case
%    \xdef\wp@parshapeL{\wp@parshapeL0pt}%
    \xdef\wp@parshapeR{\wp@parshapeR0pt}%

    \typeout{\wp@parshapeR}

    \gcutright{\wp@linesleftinpage}{\wp@parshapeR}
}

\def\wp@right{% handle right side wrapfig
    \afterpage{%
        \xdef\wp@extraheight{\the\dimexpr \ht\AP@partial+\dp\AP@partial - \wp@figureheight}% this should be the height of the figure that sticks out from the bottom of the first paragraph
        \noindent\hspace{\dimexpr \textwidth-\wp@figurewidth}% horizontally move to position where figure should go
        \raisebox{\dimexpr \ht\strutbox-\height}[\ht\strutbox][0pt]{\box\wp@image}% place figure
        \vskip-\baselineskip
        \unvbox\AP@partial
        \ifdim\wp@extraheight>0pt\relax% first paragraph not tall enough to wrap the fig
            \AddToHookNext{para/begin}{%
                \begin{wrapfigure}[\wp@lcorr]{r}{\wp@figurewidth}*% so we continue carving into the next, this time using wrapfig
                    \vskip-\intextsep
                    \rule{0pt}{\wp@extraheight}%
                    \vskip-\intextsep
                \end{wrapfigure}%
                \vskip-\baselineskip\indent
            }%
        \fi
    }
    \xdef\wp@parshape{\the\numexpr \wp@linesleftinpage+\wp@figureheightlines+1}%
    \edef\wp@test{\the\textwidth}%
    \count1=\wp@linesleftinpage\relax
    % shape the text around the figure by setting right indent to the affected lines
    \loop\ifnum\count1>0% for the remaining lines on this page we set full width
        \advance\count1 by -1
        \xdef\wp@parshape{\wp@parshape\space 0pt \wp@test}%
    \repeat
    \edef\wp@test{\the\dimexpr \textwidth-\wp@figurewidth-\columnsep}%
    \count1=\wp@figureheightlines\relax
    \loop\ifnum\count1>0% for the actual affected lines on the next page we set right indent
        \advance\count1 by -1
        \xdef\wp@parshape{\wp@parshape\space 0pt \wp@test}%
    \repeat
    \xdef\wp@parshape{\wp@parshape\space 0pt \the\textwidth}%
    \AddToHookNext{para/before}{\parshape=\wp@parshape}%
}

\def\wp@left{% handle left side wrapfig
    \afterpage{%
        \xdef\wp@extraheight{\the\dimexpr \ht\AP@partial+\dp\AP@partial - \wp@figureheight}%
        \noindent\raisebox{\dimexpr \ht\strutbox-\height}[0pt][0pt]{\box\wp@image}%
        \vskip-\baselineskip
        \unvbox\AP@partial
        \ifdim\wp@extraheight>0pt\relax
            \AddToHookNext{para/begin}{%
                \begin{wrapfigure}[\wp@lcorr]{l}{\wp@figurewidth}*%
                    \vskip-\intextsep
                    \rule{0pt}{\wp@extraheight}%
                    \vskip-\intextsep
                \end{wrapfigure}%
                \vskip-\baselineskip\indent
            }%
        \fi
    }%
    \xdef\wp@parshape{\the\numexpr \wp@linesleftinpage+\wp@figureheightlines+1}%
    \edef\wp@test{\the\textwidth}%
    \count1=\wp@linesleftinpage\relax
    \loop\ifnum\count1>0
        \advance\count1 by -1
        \xdef\wp@parshape{\wp@parshape\space 0pt \wp@test}%
    \repeat
    \edef\wp@temp{\the\dimexpr \wp@figurewidth+\columnsep}%
    \edef\wp@test{\the\dimexpr \textwidth-\wp@temp}%
    \count1=\wp@figureheightlines\relax
    \loop\ifnum\count1>0
        \advance\count1 by -1
        \xdef\wp@parshape{\wp@parshape\space \wp@temp \wp@test}%
    \repeat
    \xdef\wp@parshape{\wp@parshape\space 0pt \the\textwidth}%
    \AddToHookNext{para/before}{\parshape=\wp@parshape}\par
}

\NewEnviron{wp@environ}{% put \BODY into \wp@image
    \ifdim\wp@figurewidth=0pt
        \savebox\wp@image{%
            \varwidth{\textwidth}%
            %\renewcommand{\caption}[2][\empty]{\par}% dummy caption
            \BODY
            \endvarwidth
        }% calculate figure width
        \xdef\wp@figurewidth{\the\wd\wp@image}%
    \fi
    \global\setbox\wp@image=\hbox{\minipage{\wp@figurewidth}\BODY\endminipage}
}


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


% =============== Plotting Setup ===============

\ifakiotex@plotting

\pgfplotsset{compat=1.18}
\usetikzlibrary{decorations.markings}

% attempting to place axis labels closer
\pgfplotsset{
    /pgfplots/xlabel near ticks/.style={
        /pgfplots/every axis x label/.style={
            at={(ticklabel cs:0.5)},anchor=center,
        },
    },
    /pgfplots/ylabel near ticks/.style={
        /pgfplots/every axis y label/.style={
            at={(ticklabel cs:0.5)},rotate=90,anchor=center,
        },
    },
}

% default \small font for graph elements
\pgfplotsset{
    /pgfplots/every axis/.append style={
        xlabel={$x$},          % default put x on x-axis
        ylabel={$y$},          % default put y on y-axis
        yticklabel style = {xshift=0.5ex},
        xticklabel style = {yshift=0.5ex},
        legend style = {font=\small},
        legend cell align = {left},
        xlabel near ticks,
        ylabel near ticks,
        xlabel shift = 1ex,
    },
    /pgfplots/every node/.append style={font=\small},
    /pgfplots/every tick label/.append style={font=\small},
    /pgfplots/every axis legend/.append style={font=\small, draw=none},
    /pgfplots/every axis title/.append style={yshift=-2ex},
}
\tikzset{>=latex}

\fi

\endinput
