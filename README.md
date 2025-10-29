# HSRTReport LaTeX Template

A professional LaTeX report template for academic papers and theses at the University of Applied Sciences Reutlingen (Hochschule Reutlingen).

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Document Class Options](#document-class-options)
- [Customization](#customization)
- [Building the Document](#building-the-document)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 📖 Overview

The HSRTReport class is a customized LaTeX document class based on KOMA-Script's `scrreprt` class, specifically designed for creating professional academic reports, seminar papers, and bachelor/master theses at the University of Applied Sciences Reutlingen. It provides a consistent, professional layout with minimal configuration required.

## ✨ Features

- **Professional Typography**: Configured for optimal readability with proper font settings
- **Automatic Title Page Generation**: Customizable title page with university branding
- **Bibliography Management**: Integrated BibLaTeX support for citations
- **Glossary Support**: Built-in glossary and acronym management
- **Code Highlighting**: Syntax highlighting for source code listings
- **Word Count**: Automatic word counting functionality
- **Cross-referencing**: Smart referencing with hyperref

## 🔧 Prerequisites

### Required Software

- **XeLaTeX**: This template requires XeLaTeX for compilation (included in most TeX distributions)
- **TeX Distribution**: One of the following:
  - [TeX Live](https://www.tug.org/texlive/) (Linux/Windows/macOS)
  - [MiKTeX](https://miktex.org/) (Windows)
  - [MacTeX](https://www.tug.org/mactex/) (macOS)
- **GNU make**: Automates compilation and cleaning tasks

### Required LaTeX Packages

The template automatically loads all necessary packages. Key dependencies include:
- KOMA-Script bundle
- BibLaTeX with Biber backend
- glossaries-extra
- fontspec (for font management)
- TikZ (for graphics)
- listings (for code)

## 📁 Project Structure

```
SAT-WiSe-25-26/
│
├── HSRTReport/               # Document class files
│   ├── HSRTReport.cls       # Main class definition
│   ├── Assets/              # Fonts and images
│   │   ├── Fonts/          # Custom fonts
│   │   └── Images/         # Logo and graphics
│   ├── Config/             # Configuration modules
│   │   ├── Fonts.tex       # Font settings
│   │   ├── PageSetup.tex   # Page layout
│   │   └── ...            # Other configurations
│   ├── Imports/            # Package imports
│   │   ├── Core.tex        # Core packages
│   │   ├── Document.tex    # Document structure
│   │   └── ...            # Other imports
│   ├── Modules/            # Feature modules
│   │   ├── Content/        # Content-related features
│   │   ├── Layout/         # Layout features
│   │   └── Tools/          # Utility tools
│   └── Pages/              # Page templates
│       └── Titlepage.tex   # Title page definition
│
├── Content/                 # Document content
│   ├── 00_toc.tex          # Table of contents and lists
│   ├── 01_content.tex      # Chapter loader (auto-managed)
│   ├── 99_bibliography.tex # Bibliography
│   ├── Chapters/           # Individual chapter files
│   │   ├── 01_introduction.tex
│   │   ├── example_chapter.tex
│   │   └── ...
│   └── Images/             # Document images
│
├── Settings/                # Document settings
│   ├── General.tex         # General settings
│   └── Logos.tex           # Logo configuration
│
├── scripts/                 # Chapter management scripts
│   ├── create_chapter.sh   # Create new chapters
│   ├── list_chapters.sh    # List all chapters
│   ├── delete_chapter.sh   # Delete chapters
│   └── show_chapter.sh     # View chapter content
│
├── Main.tex                 # Main document file
├── Preamble.tex            # Document preamble
├── Glossary.tex            # Glossary definitions
├── Main.bib                # Bibliography database
├── Makefile                # Build automation
├── .latexmkrc              # Latexmk configuration
└── QUICKSTART.md           # Quick start guide
```

## 📝 Usage

### Basic Document Setup

1. **Edit `Main.tex`** to configure document class options:
   ```latex
   \documentclass[
       11pt,           % Font size (10pt, 11pt, 12pt)
       paper=a4,       % Paper size
       oneside,        % Single-sided (use twoside for double)
       DIV=14,         % Page layout calculation
       onecolumn       % Single column layout
   ]{HSRTReport/HSRTReport}
   ```

2. **Configure document metadata** in `Settings/General.tex`:
   ```latex
   % Document title
   \title{Your Document Title}

   % Title page information
   \AddTitlePageDataLine{Thema}{Your Topic}
   \AddTitlePageDataLine{Vorgelegt von}{Your Name}
   \AddTitlePageDataLine{Studiengang}{Your Study Program}
   % ... additional fields
   ```

3. **Add your content** using one of these methods:
   - **Automatic (Recommended)**: Use scripts to manage chapters
     ```bash
     ./scripts/create_chapter.sh 02 methodology
     ./scripts/create_chapter.sh 03 results
     ./scripts/list_chapters.sh
     ```
   - **Manual**: Create files in `Content/Chapters/` and add them to `Content/01_content.tex`

4. **Manage bibliography** in `Main.bib` using BibTeX format

5. **Define glossary entries** in `Glossary.tex`:
   ```latex
   \newglossaryentry{term}{
       name=Term,
       description={Description of the term}
   }

   \newacronym{abbr}{ABBR}{Full Form of Abbreviation}
   ```

## ⚙️ Document Class Options

The HSRTReport class accepts all standard KOMA-Script `scrreprt` options plus:

| Option | Description | Values |
|--------|-------------|---------|
| `paper` | Paper size | `a4`, `letter`, etc. |
| `fontsize` | Base font size | `10pt`, `11pt`, `12pt` |
| `oneside`/`twoside` | Page layout | Single or double-sided |
| `DIV` | Type area calculation | Integer (12-16 recommended) |
| `onecolumn`/`twocolumn` | Column layout | Single or double column |

## 🎨 Customization

### Modifying the Title Page

Edit `Settings/General.tex` to customize title page fields:
```latex
\AddTitlePageDataLine{Field Name}{Field Content}
\AddTitlePageDataSpace{5pt}  % Add vertical space
```

### Adding Custom Packages

Add custom packages to `Preamble.tex`:
```latex
\usepackage{yourpackage}
\yourpackagesetup{options}
```

### Changing Fonts

The template uses custom fonts defined in `HSRTReport/Config/Fonts.tex`. Modify this file to change fonts template-wide.

### Creating Custom Commands

Add custom commands to `Preamble.tex`:
```latex
\newcommand{\mycommand}[1]{#1}
```

## 📚 Chapter Management

### Automatic Chapter Management (Recommended)

The template includes scripts for efficient chapter management:

#### Create a New Chapter
```bash
./scripts/create_chapter.sh 02 methodology
```
This creates `Content/Chapters/02_methodology.tex` with a template structure and automatically adds it to the document.

#### List All Chapters
```bash
./scripts/list_chapters.sh
```
Shows all chapters and their inclusion status in the document.

#### View Chapter Content
```bash
./scripts/show_chapter.sh 02_methodology --info
./scripts/show_chapter.sh 02_methodology --structure
```

#### Delete a Chapter
```bash
./scripts/delete_chapter.sh 02_methodology
```
Removes the chapter and creates a backup in `.chapter_backups/`.

### Manual Chapter Management

1. Create a file in `Content/Chapters/`
2. Add `\input{Content/Chapters/your_chapter}` to the marked section in `Content/01_content.tex`

## 🔨 Building the Document

### Using Make (Recommended)

```bash
# Full build with bibliography and glossary – open after
make

# Just build
make compile

# Clean auxiliary files
make clean
```

### Using latexmk

```bash
latexmk -xelatex -bibtex Main.tex
```

## 🐛 Troubleshooting

### Common Issues

1. **"This class can only be used with XeLaTeX" error**
   - Solution: Ensure you're using XeLaTeX, not pdfLaTeX
   - Check your editor's compiler settings

2. **Bibliography not appearing**
   - Run `biber Main` after the first XeLaTeX compilation
   - Check for errors in `Main.bib`

3. **Glossary entries not showing**
   - Run `makeglossaries Main` after adding new entries
   - Ensure entries are referenced in the document using `\gls{term}`

## 📄 License

This template is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0).

- **Original Author**: Martin Oswald (Zürich University of Applied Sciences)
- **Modified by**: Frederik Beimgraben (University of Applied Sciences Reutlingen)

See [LICENSE](LICENSE) for details.

## 📧 Support

For questions, issues, or suggestions:
- Open an issue on GitHub
- Contact the maintainer at [frederik@beimgraben.net](mailto:frederik@beimgraben.net)

## 🙏 Acknowledgments

- Martin Oswald for the original ZHAWReport class
- KOMA-Script team for the excellent document classes
- University of Applied Sciences Reutlingen – [Reutlingen University](https://reutlingen-university.de)

---

*Last updated: October 2025*
