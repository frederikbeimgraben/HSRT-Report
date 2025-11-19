# HSRTReport LaTeX Template

[![Build LaTeX Document](https://github.com/frederikbeimgraben/HSRT-Report/actions/workflows/release.yml/badge.svg)](https://github.com/frederikbeimgraben/HSRT-Report/actions/workflows/release.yml)
[![GitHub release](https://img.shields.io/github/release/frederikbeimgraben/HSRT-Report.svg)](https://github.com/frederikbeimgraben/HSRT-Report/releases/latest)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

A professional LaTeX report template for academic papers and theses at the University of Applied Sciences Reutlingen (Hochschule Reutlingen).

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Project Structure](#-project-structure)
- [Usage](#-usage)
- [Document Class Options](#-document-class-options)
- [Customization](#-customization)
- [Building the Document](#-building-the-document)
- [Troubleshooting](#-troubleshooting)
- [License](#-license)

## 📖 Overview

The HSRTReport class is a customized LaTeX document class based on KOMA-Script's `scrreprt` class, specifically designed for creating professional academic reports, seminar papers, and bachelor/master theses at the University of Applied Sciences Reutlingen. It provides a consistent, professional layout with minimal configuration required.

## ✨ Features

- **Professional Typography**: Configured for optimal readability with proper font settings
- **Automatic Title Page Generation**: Customizable title page with university branding
- **Bibliography Management**: Integrated BibLaTeX support with BibTeX backend
- **Glossary Support**: Built-in glossary and acronym management
- **Code Highlighting**: Syntax highlighting for multiple programming languages
- **Word Count**: Automatic word counting functionality
- **Cross-referencing**: Smart referencing with hyperref
- **Advanced Page Break Control**: Intelligent section and listing page break management
- **Tectonic Engine**: Modern, self-contained TeX system with automatic package management
- **Auto Font Installation**: Custom fonts automatically installed on first build
- **Enhanced Spacing**: Optimized vertical spacing for sections and subsections
- **Smart TOC Grouping**: Automatic chapter grouping in table of contents

## 🔧 Prerequisites

### Required Software

- **Tectonic**: Modern, self-contained TeX/LaTeX engine
  - [Install Tectonic](https://tectonic-typesetting.github.io/en-US/install.html)
  - Or install via: `curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net | sh`
- **GNU make**: Automates compilation and cleaning tasks (optional but recommended)
- **Git**: For version control

### Automatic Features

- **Custom Fonts**: Automatically installed on first build
- **Bibliography**: Managed with BibLaTeX (using BibTeX backend)
- **Packages**: All LaTeX packages are automatically downloaded by Tectonic
- **No manual installation needed**: Tectonic handles all dependencies

## 📁 Project Structure

```sh
HSRT-Report/
│
├── HSRTReport/             # Document class files
│   ├── HSRTReport.cls      # Main class definition
│   ├── Assets/             # Fonts and images
│   │   ├── Fonts/          # Custom fonts
│   │   └── Images/         # Logo and graphics
│   ├── Config/             # Configuration modules
│   │   ├── Fonts.tex       # Font settings
│   │   ├── PageSetup.tex   # Page layout
│   │   └── ...             # Other configurations
│   ├── Imports.tex         # Package imports
│   ├── Modules/            # Feature modules
│   │   ├── Content/        # Content-related features
│   │   ├── Layout/         # Layout features
│   │   └── Tools/          # Utility tools
│   └── Pages/              # Page templates
│       └── Titlepage.tex   # Title page definition
│
├── Content/                # Document content
│   ├── 00_toc.tex          # Table of contents and lists
│   ├── 01_content.tex      # Chapter loader
│   ├── 99_bibliography.tex # Bibliography
│   ├── Chapters/           # Individual chapter files
│   │   ├── 01_einleitung.tex
│   │   ├── 02_gliederung.tex
│   │   └── ...
│   └── Images/             # Document images
│
├── Settings/               # Document settings
│   ├── General.tex         # General settings
│   ├── CleverefNames.tex   # \cref names configuration
│   └── Logos.tex           # Logo configuration
│
├── Build/                  # Build output directory (auto-created)
├── Output/                 # Final PDF output (auto-created)
│
├── Main.tex                # Main document file
├── Preamble.tex            # Document preamble
├── Glossary.tex            # Glossary definitions
├── Main.bib                # Bibliography database
└── Makefile                # Build automation
```

## 📝 Usage

### Basic Document Setup

1. **Configure document metadata** in `Settings/General.tex`:
   ```latex
   % Document title
   \title{Your Document Title}

   % Title page information
   \AddTitlePageDataLine{Thema}{Your Topic}
   \AddTitlePageDataLine{Vorgelegt von}{Your Name}
   \AddTitlePageDataLine{Studiengang}{Your Study Program}
   % ... additional fields
   ```

2. **Add your content** using one of these methods:
   - **Automatic (Recommended)**: Use scripts to manage chapters
     ```bash
     ./scripts/create_chapter.sh 02 methodology
     ./scripts/create_chapter.sh 03 results
     ./scripts/list_chapters.sh
     ```
   - **Manual**: Create files in `Content/Chapters/` and add them to `Content/01_content.tex`

3. **Manage bibliography** in `Main.bib` using BibTeX format (I recommend using a tool like [Zotero](https://www.zotero.org/))

4. **Define glossary entries** in `Glossary.tex`:
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

### Quick Start

```bash
# Build the PDF (automatically installs fonts if needed)
make

# Build and open the PDF
make open

# Watch for changes and rebuild automatically
make watch

# Fast single-pass compilation
make fast

# Clean auxiliary files
make clean

# Full clean including output
make distclean
```

### Using Tectonic directly

```bash
tectonic -X compile Main.tex

# Or with specific output directory
tectonic -X compile --outdir=Build Main.tex
```

## 🚀 CI/CD Pipeline

### Continuous Integration

The project includes GitHub Actions workflows for automated building and testing:

#### Release Workflow (`release.yml`)
- **Triggers on:** Version tags (e.g., `v1.0.0`, `release-2024-10`)
- **Actions:**
  - Creates a GitHub release
  - Attaches the PDF with version number
  - Generates release notes automatically
  - Archives artifacts for 90 days

### Creating a Release

To create a new release with the PDF:

```bash
# Tag the current commit
git tag -a v1.X.X -m "Release version 1.X.X"

# Push the tag to trigger the release workflow
git push origin v1.X.X
```

The workflow will automatically:
1. Build the document
2. Create a GitHub release
3. Attach the PDF to the release
4. Generate release notes from commit history

### Accessing Build Artifacts

1. Go to the **Actions** tab in your GitHub repository
2. Select a workflow run
3. Scroll down to **Artifacts**
4. Download `Main.pdf`

## 🐛 Troubleshooting

1. **Custom fonts not displaying correctly**
   - Solution: Run `make install-fonts` or let the Makefile auto-install them
   - Fonts are installed to `~/.local/share/fonts/` (Linux) or `~/Library/Fonts/` (macOS)
   - The build process handles this automatically on first run

2. **Bibliography not appearing**
   - Tectonic automatically handles bibliography compilation
   - Check for errors in `Main.bib`
   - Ensure citations are properly formatted

3. **Glossary entries not showing**
   - Run `makeglossaries Main` after adding new entries
   - Check that entries are referenced in the document
   - Verify syntax in `Glossary.tex`

4. **SVG images not supported**
   - Tectonic doesn't support shell-escape for SVG conversion
   - Pre-convert SVGs to PDFs using Inkscape or similar tools
   - Use PDF or PNG images instead of SVG
   - For local builds: Install Inkscape separately

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

## 🆕 Recent Updates

### Version 1.0 (October 2025)
- Added Docker support for containerized compilation

### Key Configuration Changes
- **Paragraph Spacing**: 6pt
- **Section Minimum Content**: 12 baseline skips (~2 paragraphs)
- **Citation Style**: APA format via BibLaTeX

---

*Documentation Last updated: 30th of October 2025*
