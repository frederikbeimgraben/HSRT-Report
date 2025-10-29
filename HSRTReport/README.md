# HSRTReport LaTeX Class

A custom LaTeX document class for reports at the University of Applied Sciences Reutlingen (Hochschule Reutlingen).

## Directory Structure

```
HSRTReport/
├── HSRTReport.cls          # Main class file
├── Assets/                  # Fonts and images
│   ├── Fonts/              # Custom fonts (Blender, DIN)
│   └── Images/             # Logos and graphics
├── Config/                  # Package imports and configuration
│   ├── Imports-Core.tex    # Essential LaTeX packages
│   ├── Imports-Document.tex # Document structure packages
│   ├── Imports-Content.tex # Content formatting packages
│   └── Imports-Graphics.tex # Graphics and TikZ packages
├── Modules/                 # Functional modules
│   ├── Content/            # Content-related modules
│   │   ├── Floats.tex     # Float configuration
│   │   ├── GlossarySettings.tex # Glossary configuration
│   │   └── Listings.tex   # Code listing settings
│   ├── Formatting/         # Text and document formatting
│   │   ├── Typography.tex # Typography settings
│   │   └── ToC.tex        # Table of contents formatting
│   ├── Layout/             # Page layout modules
│   │   ├── InfoBlocks.tex # Info/warning/error boxes
│   │   └── Watermark.tex  # Watermark configuration
│   └── Tools/              # Utility modules
│       ├── MeetingPresence.tex # Meeting attendance tables
│       └── WordCount.tex  # Word counting commands
└── Pages/                   # Page templates
    └── Titlepage.tex       # Title page layout
```

## Usage

To use this document class in your LaTeX document:

```latex
\documentclass[
    11pt,
    paper=a4,
    oneside,
    DIV=14,
    onecolumn
]{HSRTReport/HSRTReport}
```

## Module Descriptions

### Config Modules
- **Imports-Core**: Basic LaTeX packages (calc, fp, xcolor, etc.)
- **Imports-Document**: Document structure packages (babel, geometry, biblatex, etc.)
- **Imports-Content**: Content formatting (tables, listings, math, symbols)
- **Imports-Graphics**: Graphics and drawing packages (TikZ, PGF, SVG support)

### Content Modules
- **Floats**: Configuration for figures and tables
- **GlossarySettings**: Glossary and acronym list styling
- **Listings**: Code syntax highlighting configuration

### Formatting Modules
- **Typography**: Font settings and text formatting
- **ToC**: Table of contents, list of figures/tables formatting

### Layout Modules
- **InfoBlocks**: Styled boxes for notes, warnings, and errors
- **Watermark**: Draft watermark configuration

### Tools Modules
- **MeetingPresence**: Meeting attendance tracking tables
- **WordCount**: Commands for automated word counting

## Features

- Custom fonts (Blender and DIN)
- Automatic word counting
- Glossary and acronym support
- Code listing with syntax highlighting
- Custom info/warning/error boxes
- Meeting presence tables
- IEEE bibliography style
- German language support
- SVG image support

## Requirements

- XeLaTeX (required for custom fonts)
- biber (for bibliography)
- Various LaTeX packages (automatically loaded through Config modules)

## Customization

Document-specific settings should remain in your document's `TeX/` directory:
- Document title, author, abstract
- Logo selection
- Bibliography resources

Class-wide settings and functionality are contained within this HSRTReport directory structure.