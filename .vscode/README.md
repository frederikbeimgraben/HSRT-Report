# VSCode Configuration for LaTeX Project

This directory contains Visual Studio Code workspace settings optimized for LaTeX development with this project.

## Features

### LaTeX Workshop Integration
- Configured to use `make` command for building
- Multiple build recipes available:
  - `make` - Standard build using Docker
  - `make clean` - Clean auxiliary files
  - `make full` - Clean and full rebuild

### Key Settings
- **Auto-build disabled** - Build manually with `Ctrl+Shift+B` (Windows/Linux) or `Cmd+Shift+B` (Mac)
- **PDF viewer** - Opens in a new tab within VSCode
- **Output directory** - Configured to use `Output/` folder
- **Auto-clean** - Cleans auxiliary files after successful build

## Usage

### Building the Document
1. **Quick Build**: Press `Ctrl+Shift+B` / `Cmd+Shift+B`
2. **Build Menu**: Press `Ctrl+Alt+B` / `Cmd+Alt+B` to see all build options
3. **Command Palette**: Press `F1` and type "LaTeX Workshop: Build"

### Viewing the PDF
- After building, the PDF will automatically open in a new tab
- Use `Ctrl+Alt+V` / `Cmd+Alt+V` to manually open the PDF

### Tasks
Additional tasks are available through the Command Palette (`F1`):
- `Tasks: Run Task` shows all available make commands:
  - Build LaTeX Document
  - Clean Build Files
  - Full Build
  - View PDF
  - Docker Build/Clean
  - List Chapters
  - Word Count
  - Check Prerequisites

## Recommended Extensions

The following extensions are recommended for the best experience:
- **LaTeX Workshop** - Main LaTeX support (required)
- **Code Spell Checker** + German dictionary - Spell checking
- **PDF Viewer** - Enhanced PDF viewing
- **GitLens** - Git integration
- **Docker** - Docker support for containerized builds

Install all recommended extensions:
1. Open Extensions sidebar (`Ctrl+Shift+X` / `Cmd+Shift+X`)
2. Filter by `@recommended`
3. Click "Install Workspace Recommended Extensions"

## Customization

To override any settings for your personal preferences, create a `.vscode/settings.local.json` file (git-ignored) or modify your user settings.

### Enable Auto-Build on Save
If you want to enable automatic building when saving `.tex` files, add this to your user settings:
```json
{
    "latex-workshop.latex.autoBuild.run": "onSave"
}
```

### Change PDF Viewer
To use an external PDF viewer instead of the built-in one:
```json
{
    "latex-workshop.view.pdf.viewer": "external",
    "latex-workshop.view.pdf.external.viewer.command": "your-pdf-viewer",
    "latex-workshop.view.pdf.external.viewer.args": ["%PDF%"]
}
```

## Troubleshooting

### Build Fails
1. Ensure Docker is running: `make docker-info`
2. Check prerequisites: `make check`
3. Try a clean build: `make full`

### PDF Doesn't Open
- Check if the PDF was created in `Output/Main.pdf`
- Try manually opening: `make view`

### Extensions Not Working
1. Ensure LaTeX Workshop extension is installed and enabled
2. Reload VSCode window: `F1` → "Developer: Reload Window"
3. Check extension output: View → Output → Select "LaTeX Workshop"

## File Exclusions

The configuration hides common LaTeX auxiliary files from the file explorer:
- `*.aux`, `*.log`, `*.synctex.gz`
- `*.fdb_latexmk`, `*.fls`
- `*.out`, `*.toc`, `*.bbl`, `*.blg`
- Build directory contents (can be shown if needed)

To show hidden files temporarily, use the file explorer's filter settings.