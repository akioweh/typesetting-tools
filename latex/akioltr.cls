%! Class = akioltr
%! Author = Akioweh
%! Date = 7/6/2024

\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{akioltr}[2024-07-06 An amended and pre-setup version of the KOMA-Script class scrlttr2.]

% basic profiling
\directlua{tmr_start = os.clock()}
\AtBeginDocument{\directlua{tmr_text = os.clock()}}
\AtEndDocument{\typeout{^^J
    =====### COMPILE TIME: \directlua{
        tex.print( string.format("\@percentchar.3f + \@percentchar.3f = \@percentchar.3f",
                                 tmr_text-tmr_start, os.clock()-tmr_text, os.clock()-tmr_start) )
    } ###===== ^^J
}}

% =============== Options ===============

% use kvoptions as parser
\RequirePackage{kvoptions}

\DeclareBoolOption[false]{plotting}         % bool: whether to load pgfplots and tikz
\DeclareBoolOption[false]{debug}            % bool: magic!
\DeclareBoolOption[false]{timestamp}        % bool: whether to include a time of compilation in footer of title page
\DeclareBoolOption[true]{fast}              % bool: magic to speed up compile (externalize tikz pictures)
\DeclareBoolOption[false]{faster}           % bool: magicer (does nothing for now)
\DeclareBoolOption[false]{obfus}            % bool: magicest


\ProcessKeyvalOptions*\relax


\LoadClass[
    fontsize=11pt,
    paper=a4,
    parskip=full,
%    enlargefirstpage=on,
    fromalign=right,
    fromphone=on,
    fromemail=on,
    fromrule=afteraddress,
%    addrfield=off,
%    backaddress=on,
    subject=beforeopening,
    foldmarks=on,
]{scrlttr2}
\RequirePackage{fontspec}
\RequirePackage{luaotfload}
\ifakiotex@obfus
    \RequirePackage{luatexbase}
    \RequirePackage{luacode}

    \begin{luacode*}
        local obfuscate = function (tfmdata, _specification)
            if not tfmdata or type (tfmdata) ~= "table" then
                return
            end

            local characters = tfmdata.characters
            if characters then
                for codepoint, char in next, characters do
                    char.tounicode = string.format([[%0.4X]], math.random(0x01, 0xFFFF))
                end
            end
        end

        luatexbase.add_to_callback("luaotfload.patch_font", obfuscate, "user.obfuscate_font", 1)
    \end{luacode*}
\fi
\RequirePackage{microtype}
\RequirePackage{setspaceenhanced}
\RequirePackage{polyglossia}
\setdefaultlanguage[variant=us]{english}
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{lmodern}
\RequirePackage{lua-widow-control}
\ifakiotex@plotting
    \RequirePackage{tikz}
    \RequirePackage{pgfplots}
    \usetikzlibrary{calc}
    \ifakiotex@fast
        \usepgfplotslibrary{external}
        \tikzexternalize
    \fi
\fi


\newlist{enumns}{enumerate}{1}  % enumitem custom list
\setlist[enumns]{%
    label=\arabic*.,
    align=left,
    leftmargin=18pt,
    labelwidth=*,
    labelsep=*,
    labelindent=0pt,
    itemsep=0pt, parsep=0pt,
    topsep=-\parskip,
    partopsep=\parskip%
}


\setkomafont{pagenumber}{\sffamily}
\setkomafont{subject}{\bfseries}
\setkomafont{backaddress}{\mdseries}

\LoadLetterOption{DIN}

\renewcommand*{\raggedsignature}{\raggedright}
\setplength{sigbeforevskip}{.5\parskip}
%\setplength{sigindent}{0pt plus 100fil}


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
