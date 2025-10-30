# Zed Configuration for LaTeX Project

This directory contains Zed editor workspace settings optimized for LaTeX development with this project.

## Features

### Build System Integration
- Configured to use `make` command for all builds
- **Auto-compile on save is DISABLED** as requested
- Manual build triggers only

### Key Settings
- **Format on save** - Disabled for LaTeX files
- **Auto-save** - Disabled to prevent unwanted builds
- **Build command** - Uses `make` via Docker
- **PDF viewer** - Uses system default (xdg-open on Linux)
- **Word wrap** - Enabled for better readability

## Usage

### Building the Document
1. **Default Build**: Press `Cmd+B` (Mac) / `Ctrl+B` (Linux)
2. **Full Build**: Press `Cmd+Shift+B` (Mac) / `Ctrl+Shift+B` (Linux)
3. **Command Palette**: Press `Cmd+Shift+P` and select a task

### Available Tasks
- **Build LaTeX Document** - Standard build using Docker
- **Clean Build Files** - Remove auxiliary files
- **Full Build** - Clean and rebuild from scratch
- **View PDF** - Open the generated PDF
- **Docker Build** - Explicit Docker build
- **Docker Clean** - Clean Docker containers
- **Word Count** - Show document statistics
- **List Chapters** - Show all chapters
- **Check Prerequisites** - Verify system requirements

### Keyboard Shortcuts
| Action | Mac | Linux/Windows |
|--------|-----|---------------|
| Build | `Cmd+B` | `Ctrl+B` |
| Full Build | `Cmd+Shift+B` | `Ctrl+Shift+B` |
| Clean | `Cmd+K Cmd+C` | `Ctrl+K Ctrl+C` |
| View PDF | `Cmd+K Cmd+V` | `Ctrl+K Ctrl+V` |

## Configuration Details

### LaTeX Language Settings
```json
{
  "LaTeX": {
    "format_on_save": false,      // No auto-formatting
    "autosave": false,             // No auto-save
    "tab_size": 2,                 // 2-space indentation
    "soft_wrap": "editor_width",   // Wrap at editor width
    "enable_language_server": true // Enable LSP support
  }
}
```

### Build Configuration
The project is configured to use `make` for all build operations:
- Build command: `make`
- Working directory: Project root
- Output directory: `Output/`

### File Exclusions
The following files are hidden from the file tree:
- Build artifacts (`*.aux`, `*.log`, `*.synctex.gz`)
- Bibliography files (`*.bbl`, `*.blg`)
- Table of contents (`*.toc`, `*.lof`, `*.lot`)
- Build directory contents

## LSP Configuration (texlab)

If you have `texlab` language server installed, it's configured with:
- Build on save: **DISABLED**
- Forward search: Disabled
- ChkTeX: Enabled on open and save
- Formatter: latexindent

To install texlab:
```bash
# macOS
brew install texlab

# Linux (via cargo)
cargo install texlab

# Or download from GitHub releases
```

## Customization

### Enable Auto-Save (Not Recommended)
If you want to enable auto-save (will NOT trigger builds):
```json
{
  "autosave": {
    "after_delay": 1000
  }
}
```

### Change PDF Viewer
To use a different PDF viewer:
```json
{
  "preview": {
    "pdf_viewer": {
      "open_command": "your-pdf-viewer"
    }
  }
}
```

### Enable Build on Save (Not Recommended)
If you really want to build on every save:
```json
{
  "lsp": {
    "texlab": {
      "initialization_options": {
        "build": {
          "onSave": true
        }
      }
    }
  }
}
```

## Troubleshooting

### Build Doesn't Start
1. Ensure Docker is running
2. Check that `make` command works in terminal
3. Try running `make docker-info` in terminal

### Tasks Not Available
1. Ensure you're in the project root
2. Reload Zed: `Cmd+Q` and restart
3. Check tasks.json is properly loaded

### PDF Doesn't Open
1. Check if PDF exists in `Output/Main.pdf`
2. Verify system PDF viewer is configured
3. Try manually: `make view` in terminal

### Language Server Issues
1. Install texlab if not already installed
2. Check Zed's language server logs
3. Disable and re-enable language server in settings

## Important Notes

1. **Auto-compile is intentionally disabled** - You must manually trigger builds
2. **Format on save is disabled** - LaTeX formatting can break documents
3. **Use Docker builds** - Ensures consistent environment
4. **Check git status** - Some files are auto-generated and should not be committed

## File Structure
```
.zed/
├── settings.json  # Zed workspace settings
├── tasks.json     # Build task definitions
└── README.md      # This file
```

These configuration files are workspace-specific and should be committed to the repository so all team members have the same settings.