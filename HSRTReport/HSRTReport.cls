% =======================================================================================
% Original Author: Martin Oswald (Zürich University of Applied Sciences)
% Modified by: Frederik Beimgraben (University of Applied Sciences Reutlingen)
% Description: This class is a modified version of the ZHAWReport class by Martin Oswald.
% It is used for reports at the University of Applied Sciences Reutlingen.
% =======================================================================================
% License: Creative Commons CC BY 4.0
% Creative Commons Attribution-ShareAlike 4.0 International License.
%
% You should have received a copy of the license along with this
% work. If not, see <http://creativecommons.org/licenses/by-sa/4.0/>.
% =======================================================================================

% String comparison Command
\ExplSyntaxOn
\cs_new_eq:NN \strcompare \str_if_eq:eeTF
\ExplSyntaxOff

% Suppress all warnings; Only show errors
\usepackage{silence}
\WarningsOff*

% If not using XeTeX, print an error message and stop compiling
\ifx\XeTeXversion\undefined
    \PackageError{HSRTReport}{This class can only be used with XeLaTeX.}{}
    \stop
\fi

%----------------------------------------
%   PATHS
%----------------------------------------
\def\classPath{HSRTReport}
\def\fontsPath{\classPath/Assets/Fonts}
\def\imagesPath{\classPath/Assets/Images}

%----------------------------------------
%   CLASS DEFINITION AND PARAMETERS
%----------------------------------------
% Original: ZHAWReport.cls by Martin Oswald
\NeedsTeXFormat{LaTeX2e}
\newcommand{\classname}{HSRTReport/HSRTReport}
\ProvidesClass{\classname}[2024/07/08 HSRT Report Class]
\providecommand{\baseclass}{scrreprt}

% Default options
\PassOptionsToClass{pointlessnumbers}{\baseclass}

% Forward options to the base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\baseclass}}
\ProcessOptions\relax

% Load the base class with options
\LoadClass{\baseclass}

% ----------------------------------------
% Imports
% ----------------------------------------
\input{\classPath/Imports}

%----------------------------------------
%   REFS
%----------------------------------------
\RequirePackage{hyperref}
\hypersetup{
    pdfpagemode={UseOutlines},
    bookmarksopen=true,
    bookmarksopenlevel=0,
    hypertexnames=false,
    colorlinks=true,
    citecolor=[rgb]{0.286, 0.427, 0.537},
    linkcolor=[rgb]{0.161, 0.31, 0.427},
    urlcolor=[rgb]{0.071, 0.212, 0.322},
    pdfstartview={FitV},
    unicode,
    breaklinks=true
}

%----------------------------------------
%   FONT SETUP
%----------------------------------------
\renewcommand*\rmdefault{lmr}
\renewcommand*\sfdefault{lmss}
\definecolor{midnightblue}{rgb}{0.094, 0.051, 0.228}

\newfontfamily\blenderfont[
    Path=\fontsPath/Blender/,
    Extension=.ttf,
    UprightFont=*-Medium,
    BoldFont=*-Bold,
    ItalicFont=*-MediumItalic,
    BoldItalicFont=*-BoldItalic
]{Blender}
\newfontfamily\dinfont[
    Path=\fontsPath/DIN/,
    Extension=.ttf,
    UprightFont=*-Regular,
    BoldFont=*-Bold,
    ItalicFont=*-Italic,
    BoldItalicFont=*-BoldItalic
]{DIN}

\setsansfont{Blender}[
    Path=\fontsPath/Blender/,
    Extension=.ttf,
    UprightFont=*-Medium,
    BoldFont=*-Bold,
    ItalicFont=*-MediumItalic,
    BoldItalicFont=*-BoldItalic
]
\setmainfont{DIN}[
    Path=\fontsPath/DIN/,
    Extension=.ttf,
    UprightFont=*-Regular,
    BoldFont=*-Bold,
    ItalicFont=*-Italic,
    BoldItalicFont=*-BoldItalic
]


%----------------------------------------
%   PAGE SETUP
%----------------------------------------

\pagestyle{fancy}

\renewcommand{\headrulewidth}{0pt}

%----------------------------------------
%   LOGOS
%----------------------------------------

% ==== Add more logos to be placed besides the main logo on the title page ====
\newcommand{\logosScale}{1}
\newcommand{\mainLogoScale}{1}

\newlength{\imageHeight}


\DeclareRobustCommand{\SetLogosScale}[1]{
    \renewcommand{\logosScale}{#1}
}

\let\newglobalarray\newarray
\patchcmd{\newglobalarray}{\edef}{\xdef}{}{}

% Set the array to expand the elements
\expandarrayelementtrue

% AddLogo Command with automatic counter
% Array to store the logos and to be used in pgffor later
\newglobalarray\LogosPaths
\newglobalarray\LogosScales
\newglobalarray\LogosOpacities
\newglobalarray\LogosExtensions
\newcounter{logoCounter}
\setcounter{logoCounter}{0}
% Command to add a logo to the array
% Usage: \AddLogoToArray{<Name>}{<Scale>}{<Opacity>}
\DeclareRobustCommand{\AddLogo}[4]{
    \stepcounter{logoCounter}
    \LogosPaths(\thelogoCounter)={#1}
    \LogosScales(\thelogoCounter)={#2}
    \LogosOpacities(\thelogoCounter)={#3}
    \LogosExtensions(\thelogoCounter)={#4}
}

% Command to get opacity of a logo
\DeclareRobustCommand{\GetLogoOpacity}[1]{
    \expand{\LogosOpacities(#1)}
}

% Command to add a data line for the title page (key, value)
% Use a token register to store the data
\newtoks\titlePageData
\def\tand{&}
\titlePageData={\tand}
\DeclareRobustCommand{\AddTitlePageDataSpace}[1]{
    % Add vertical space of size #1
    \titlePageData=\expandafter{\the\titlePageData \vspace{#1}}
}
\DeclareRobustCommand{\AddTitlePageDataLine}[2]{
    \titlePageData=\expandafter{\the\titlePageData\\ \textbf{#1}\tand #2}
}

% Command to get all the data for the title page (to be inserted in tabular)
% ({tabular}{@{} p{40mm} l}) Key is always bold
\DeclareRobustCommand{\GetTitlePageDataTable}{
    \begin{tabular}{@{} p{40mm} l}
        \the\titlePageData
    \end{tabular}
}

% =============================================================================
\def\skylinePath{\classPath/Assets/Images/Skyline.svg}

\newcommand{\footerYShift}{1.5em}
\newcommand{\footerXShift}{0.7em}

% Define the logo and its position
\AtBeginPage{
    \setlength{\imageHeight}{2cm*\real{\mainLogoScale}*\real{\logosScale}*\real{0.45}}
    \begin{tikzpicture}[overlay, remember picture]
        % === Main Logo(s) ===
        \node[anchor=south east, inner sep=0pt, xshift=-\footerXShift, yshift=\footerYShift, opacity=0.0] (logo0) at (current page.south east) {
            \strcompare{\thepage}{1}{}{
                \includegraphics[height=\imageHeight]{\imagesPath/DUMMY_FOOT.png}
            }
        };
        \ifnum\thepage=1
        \else
        % For loop to place all logos
        \foreach \i in {1,...,\value{logoCounter}} {
            % Calculate name for i-1
            \pgfmathtruncatemacro{\prev}{\i-1}
            \node[anchor=east, inner sep=0pt, xshift=-0.1cm, opacity=0.3] (logo\i) at (logo\prev.west) {
                \makeatletter
                \testarray{LogosScales}(\i)
                \setlength{\imageHeight}{1.5cm*\real{\temp@macro}*\real{\logosScale}*\real{0.55}}
                \testarray{LogosExtensions}(\i)
                \let\extension\temp@macro
                \testarray{LogosOpacities}(\i)
                \let\opacity\temp@macro
                \testarray{LogosPaths}(\i)
                \ifthenelse{\equal{\extension}{svg}}{
                    \begin{tikzpicture}
                        \node[opacity=\opacity] {
                            \includesvg[height=\imageHeight]{\classPath/Assets/Images/\temp@macro.\extension}
                        };
                    \end{tikzpicture}
                }{
                    \begin{tikzpicture}
                        \node[opacity=\opacity] {
                            \includegraphics[height=\imageHeight]{\classPath/Assets/Images/\temp@macro.\extension}
                        };
                    \end{tikzpicture}
                }
                \makeatother
            };
        }
        \fi
        % Skyline
        \node[anchor=south west, inner sep=0pt, yshift=0em] at (current page.south west) {
            \includesvg[width=1.5\paperwidth]{\skylinePath}
        };
    \end{tikzpicture}
}

%----------------------------------------
%   TITLE PAGE
%----------------------------------------
\setkomafont{pagenumber}{\color{gray}\blenderfont\selectfont}

\fancyhf{}
\fancyhead[L]{\color{gray}\blenderfont \@title}
\fancyhead[R]{\pagemark}
\fancyfoot[C]{}

\fancypagestyle{fancy}{
    \fancyhf{}
    \fancyhead[L]{\color{gray}\blenderfont \@title}
    \fancyhead[R]{\pagemark}
    \fancyfoot[C]{}
}

% Set font for all headings
\setkomafont{disposition}{\blenderfont\bfseries}
\setkomafont{chapter}{\Large\blenderfont\bfseries}
\setkomafont{section}{\Large\blenderfont\bfseries}
\setkomafont{subsection}{\large\blenderfont\bfseries}
\setkomafont{subsubsection}{\large\blenderfont\bfseries}

\RedeclareSectionCommand[
    beforeskip=1ex,
    afterskip=0.5ex,
    style=section
]{chapter}

\RedeclareSectionCommands[
    beforeskip=0.6ex,
    afterskip=0.3ex,
]{section,subsection,subsubsection}

\newcommand{\decoRule}{\rule{.8\textwidth}{.4pt}}

%----------------------------------------
%   TABLE OF CONTENTS / FIG / TAB
%----------------------------------------
% Page Numbering in the Table of Contents
\renewcommand\cftchappagefont{\blenderfont\color{gray}}
\renewcommand\cftsecpagefont{\blenderfont\color{gray}}
\renewcommand\cftsubsecpagefont{\blenderfont\color{gray}}
\renewcommand\cftsubsubsecpagefont{\blenderfont\color{gray}}

% Chap/Sec/... Title in the Table of Contents
\renewcommand\cftchapfont{\blenderfont\color{gray}}
\renewcommand\cftsecfont{\blenderfont\color{gray}}
\renewcommand\cftsubsecfont{\blenderfont\color{gray}}
\renewcommand\cftsubsubsecfont{\blenderfont\color{gray}}

\RedeclareSectionCommands[
  tocentryformat=\blenderfont\normalsize,
  tocpagenumberformat=\blenderfont\normalsize
]{section,subsection}

% Figure and Table in the Table of Contents
\renewcommand\cftfigfont{\blenderfont\color{gray}}
\renewcommand\cftfigpagefont{\blenderfont\color{gray}}
\renewcommand\cfttabfont{\blenderfont\color{gray}}
\renewcommand\cfttabpagefont{\blenderfont\color{gray}}
\renewcommand{\cftdotsep}{1.5}

% ----------------------------------------
% Local Imports
% ----------------------------------------
\input{\classPath/Pages/Titlepage.tex}

% ==== Tools ====
\input{\classPath/Modules/Listings}
\input{\classPath/Modules/Floats}
\input{\classPath/Modules/MeetingPresence}
\input{\classPath/Modules/InfoBlocks}
\input{\classPath/Modules/Watermark}
\input{\classPath/Modules/ToC}
\input{\classPath/Modules/Typography}
