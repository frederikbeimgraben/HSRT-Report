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
\input{\classPath/Imports/Core}
% Document structure packages
\input{\classPath/Imports/Document}
% Content and typography packages
\input{\classPath/Imports/Content}
% Graphics and TikZ packages
\input{\classPath/Imports/Graphics}

% ==============================================================================
% Module Includes
% ==============================================================================
\input{\classPath/Pages/Titlepage.tex}

% ------------------------------------------------------------------------------
% Configuration Modules
% ------------------------------------------------------------------------------
\input{\classPath/Config/Hyperref}
\input{\classPath/Config/Fonts}
\input{\classPath/Config/PageSetup}
\input{\classPath/Config/Sections}
\input{\classPath/Config/GlossarySettings}
\input{\classPath/Config/ToC}
\input{\classPath/Config/Equations}
\input{\classPath/Config/Floats}
\input{\classPath/Config/Typography}
\input{\classPath/Config/PageBreakControl}

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
