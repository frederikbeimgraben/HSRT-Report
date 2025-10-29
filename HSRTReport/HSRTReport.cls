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

% ==============================================================================
% Package Imports
% ==============================================================================
% Load core packages first
\input{\classPath/Config/Imports/Core}
% Document structure packages
\input{\classPath/Config/Imports/Document}
% Content and typography packages
\input{\classPath/Config/Imports/Content}
% Graphics and TikZ packages
\input{\classPath/Config/Imports/Graphics}

% ==============================================================================
% Hyperref Configuration
% ==============================================================================
% Hyperref already loaded in Imports-Document
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

% Font and page setup are loaded from configuration modules

% ==============================================================================
% Title Page Configuration
% ==============================================================================
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

% ==============================================================================
% Table of Contents Configuration
% ==============================================================================
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

% List of equations
\newcommand{\listequationsname}{List of Equations}
\newlistof{myequations}{equ}{\listequationsname}

\newcommand{\equationname}{Equation}

% Command to add equations to the list
\newcommand{\myequations}[1]{%
	\addcontentsline{equ}{myequations}{\protect\equationname~\numberline{\theequation:} #1}\par}

\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{equation}{chapter}

% ==============================================================================
% Module Includes
% ==============================================================================
\input{\classPath/Pages/Titlepage.tex}

% ------------------------------------------------------------------------------
% Configuration Modules
% ------------------------------------------------------------------------------
\input{\classPath/Config/Fonts}
\input{\classPath/Config/PageSetup}
\input{\classPath/Config/GlossarySettings}
\input{\classPath/Config/ToC}
\input{\classPath/Config/Floats}
\input{\classPath/Config/Typography}

% ------------------------------------------------------------------------------
% Content Modules
% ------------------------------------------------------------------------------
\input{\classPath/Modules/Content/Listings}

% ------------------------------------------------------------------------------
% Layout Modules
% ------------------------------------------------------------------------------
\input{\classPath/Modules/Layout/Logos}
\input{\classPath/Modules/Layout/InfoBlocks}
\input{\classPath/Modules/Layout/Watermark}

% ------------------------------------------------------------------------------
% Tool Modules
% ------------------------------------------------------------------------------
\input{\classPath/Modules/Tools/WordCount}
