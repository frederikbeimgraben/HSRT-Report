# ==============================================================================
# Makefile for HSRT-Report with Tectonic
# ==============================================================================
# Description: Build automation for the HSRT-Report LaTeX template using Tectonic
# Author: Frederik Beimgraben
# Version: 2.0.0
# ==============================================================================

# Configuration
# ------------------------------------------------------------------------------
TECTONIC = tectonic
TECTONIC_FLAGS = -X compile --keep-logs --keep-intermediates

# Main document
SOURCE = Main.tex
BUILD_DIR = Build
OUT_DIR = Output
PDF_SOURCE = $(BUILD_DIR)/Main.pdf
PDF_TARGET = $(OUT_DIR)/Main.pdf
PDF = $(SOURCE:.tex=.pdf)

# Colors for output
BLUE = \033[0;34m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# ==============================================================================
# HELP
# ==============================================================================
.PHONY: help
help:
	@echo -e "$(BLUE)=== HSRT-Report Makefile ===$(NC)"
	@echo ""
	@echo -e "$(GREEN)Available targets:$(NC)"
	@echo ""
	@echo -e "  $(YELLOW)make$(NC)           - Build the PDF using Tectonic (auto-installs fonts)"
	@echo -e "  $(YELLOW)make compile$(NC)   - Compile the LaTeX document"
	@echo -e "  $(YELLOW)make clean$(NC)     - Remove all generated files"
	@echo -e "  $(YELLOW)make distclean$(NC) - Remove all generated files and directories"
	@echo -e "  $(YELLOW)make watch$(NC)     - Watch for changes and rebuild automatically"
	@echo -e "  $(YELLOW)make check$(NC)     - Check if all prerequisites are installed"
	@echo -e "  $(YELLOW)make install-fonts$(NC) - Install custom fonts to system (Linux/Mac)"
	@echo -e "  $(YELLOW)make wordcount$(NC) - Count words in the document"
	@echo -e "  $(YELLOW)make open$(NC)      - Build and open the PDF"
	@echo ""
	@echo -e "$(GREEN)Quick commands:$(NC)"
	@echo ""
	@echo -e "  $(YELLOW)make pdf$(NC)       - Alias for 'make compile'"
	@echo -e "  $(YELLOW)make all$(NC)       - Full build with all features"
	@echo -e "  $(YELLOW)make fast$(NC)      - Fast compilation (single pass)"
	@echo ""
	@echo -e "$(GREEN)Notes:$(NC)"
	@echo -e "  - Custom fonts are automatically installed on first build"
	@echo -e "  - Build outputs go to Build/ directory"
	@echo -e "  - Final PDF is copied to Output/ directory"
	@echo ""

# ==============================================================================
# DEFAULT TARGET
# ==============================================================================
.DEFAULT_GOAL := compile

# ==============================================================================
# BUILD TARGETS
# ==============================================================================

# Main build target
.PHONY: all
all: clean compile
	@echo -e "$(GREEN)✓ Full build complete$(NC)"

# Check if fonts are installed
.PHONY: check-fonts
check-fonts:
	@if ! fc-list | grep -q "Blender\|DIN" 2>/dev/null; then \
		echo -e "$(YELLOW)→ Custom fonts not found. Installing...$(NC)"; \
		$(MAKE) install-fonts; \
	fi

# Compile the document
.PHONY: compile
compile: check-fonts
	@echo -e "$(BLUE)=== Building LaTeX Document with Tectonic ===$(NC)"
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	@echo -e "$(YELLOW)→ Running Tectonic...$(NC)"
	$(TECTONIC) $(TECTONIC_FLAGS) --outdir=$(BUILD_DIR) $(SOURCE)
	@if [ -f $(PDF_SOURCE) ]; then \
		cp $(PDF_SOURCE) $(PDF_TARGET); \
		echo -e "$(GREEN)✓ PDF created: $(PDF_TARGET)$(NC)"; \
	else \
		echo -e "$(RED)✗ PDF creation failed$(NC)"; \
		exit 1; \
	fi

# Fast compilation (single pass)
.PHONY: fast
fast:
	@echo -e "$(BLUE)=== Fast Compilation ===$(NC)"
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	$(TECTONIC) -X compile --pass=tex --outdir=$(BUILD_DIR) $(SOURCE)
	@echo -e "$(GREEN)✓ Fast compilation complete$(NC)"

# Alias for compile
.PHONY: pdf
pdf: compile

# ==============================================================================
# WATCH TARGET
# ==============================================================================
.PHONY: watch
watch:
	@echo -e "$(BLUE)=== Watching for changes ===$(NC)"
	@echo -e "$(YELLOW)Press Ctrl+C to stop watching$(NC)"
	@if command -v inotifywait >/dev/null 2>&1; then \
		while true; do \
			inotifywait -qre modify --format '%w%f' \
				--exclude '(Build/|Output/|\.git/|.*\.swp|.*~)' \
				*.tex Content/*.tex Content/Chapters/*.tex HSRTReport/**/*.tex Settings/*.tex; \
			clear; \
			$(MAKE) compile; \
		done; \
	elif command -v fswatch >/dev/null 2>&1; then \
		fswatch -o --exclude='Build' --exclude='Output' \
			*.tex Content/**/*.tex HSRTReport/**/*.tex Settings/*.tex | \
			while read num; do \
				clear; \
				$(MAKE) compile; \
			done; \
	else \
		echo -e "$(RED)✗ No file watcher found. Install inotifywait (Linux) or fswatch (Mac)$(NC)"; \
		exit 1; \
	fi

# ==============================================================================
# CLEAN TARGETS
# ==============================================================================

# Clean build artifacts
.PHONY: clean
clean:
	@echo -e "$(BLUE)=== Cleaning build artifacts ===$(NC)"
	@rm -f *.aux *.log *.out *.toc *.bbl *.blg *.fls *.fdb_latexmk *.synctex.gz
	@rm -f *.lot *.lof *.lol *.idx *.ind *.ilg *.gls *.glo *.glg
	@rm -f *.acn *.acr *.alg *.ist *.xdy
	@rm -f *.bcf *.run.xml *-blx.bib
	@rm -f *.nav *.snm *.vrb
	@rm -rf _minted-*
	@echo -e "$(GREEN)✓ Build artifacts cleaned$(NC)"

# Deep clean - remove all generated files and directories
.PHONY: distclean
distclean: clean
	@echo -e "$(BLUE)=== Deep cleaning ===$(NC)"
	@rm -rf $(BUILD_DIR)
	@rm -rf $(OUT_DIR)
	@rm -f $(PDF)
	@echo -e "$(GREEN)✓ All generated files removed$(NC)"

# ==============================================================================
# UTILITY TARGETS
# ==============================================================================

# Check prerequisites
.PHONY: check
check:
	@echo -e "$(BLUE)=== Checking Prerequisites ===$(NC)"
	@command -v $(TECTONIC) >/dev/null 2>&1 && \
		echo -e "$(GREEN)✓ Tectonic found$(NC)" || \
		echo -e "$(RED)✗ Tectonic not found - install from: https://tectonic-typesetting.github.io/$(NC)"
	@command -v git >/dev/null 2>&1 && \
		echo -e "$(GREEN)✓ Git found$(NC)" || \
		echo -e "$(RED)✗ Git not found$(NC)"
	@echo ""
	@echo -e "$(BLUE)Tectonic version:$(NC)"
	@$(TECTONIC) --version 2>/dev/null || echo "Tectonic not installed"

# Install fonts to system (Linux/Mac)
.PHONY: install-fonts
install-fonts:
	@if fc-list | grep -q "Blender\|DIN" 2>/dev/null; then \
		echo -e "$(GREEN)✓ Custom fonts already installed$(NC)"; \
	elif [ -d "HSRTReport/Assets/Fonts" ]; then \
		echo -e "$(BLUE)=== Installing Custom Fonts ===$(NC)"; \
		if [ "$$(uname)" = "Darwin" ]; then \
			echo -e "$(YELLOW)→ Installing fonts on macOS...$(NC)"; \
			cp -r HSRTReport/Assets/Fonts/*/*.ttf ~/Library/Fonts/ 2>/dev/null || true; \
			cp -r HSRTReport/Assets/Fonts/*/*.otf ~/Library/Fonts/ 2>/dev/null || true; \
			echo -e "$(GREEN)✓ Fonts installed to ~/Library/Fonts/$(NC)"; \
		elif [ "$$(uname)" = "Linux" ]; then \
			echo -e "$(YELLOW)→ Installing fonts on Linux...$(NC)"; \
			mkdir -p ~/.local/share/fonts; \
			cp -r HSRTReport/Assets/Fonts/*/*.ttf ~/.local/share/fonts/ 2>/dev/null || true; \
			cp -r HSRTReport/Assets/Fonts/*/*.otf ~/.local/share/fonts/ 2>/dev/null || true; \
			fc-cache -fv >/dev/null 2>&1; \
			echo -e "$(GREEN)✓ Fonts installed to ~/.local/share/fonts/$(NC)"; \
		else \
			echo -e "$(RED)✗ Unsupported operating system$(NC)"; \
		fi; \
	else \
		echo -e "$(RED)✗ Font directory not found$(NC)"; \
	fi

# Count words in the document
.PHONY: wordcount
wordcount:
	@echo -e "$(BLUE)=== Word Count ===$(NC)"
	@if command -v texcount >/dev/null 2>&1; then \
		texcount -inc -total -brief Main.tex; \
	else \
		echo -e "$(YELLOW)Installing texcount...$(NC)"; \
		echo -e "$(RED)✗ texcount not found. Please install it manually.$(NC)"; \
	fi

# Open the PDF
.PHONY: open
open: compile
	@echo -e "$(BLUE)=== Opening PDF ===$(NC)"
	@if [ -f $(PDF_TARGET) ]; then \
		if command -v xdg-open >/dev/null 2>&1; then \
			xdg-open $(PDF_TARGET); \
		elif command -v open >/dev/null 2>&1; then \
			open $(PDF_TARGET); \
		else \
			echo -e "$(RED)✗ No PDF viewer found$(NC)"; \
		fi; \
	else \
		echo -e "$(RED)✗ PDF not found. Run 'make' first.$(NC)"; \
	fi

# ==============================================================================
# DEVELOPMENT TARGETS
# ==============================================================================

# Format all TeX files
.PHONY: format
format:
	@echo -e "$(BLUE)=== Formatting TeX Files ===$(NC)"
	@if command -v latexindent >/dev/null 2>&1; then \
		find . -name "*.tex" -not -path "./Build/*" -not -path "./Output/*" \
			-exec latexindent -w {} \; 2>/dev/null; \
		echo -e "$(GREEN)✓ Files formatted$(NC)"; \
	else \
		echo -e "$(RED)✗ latexindent not found$(NC)"; \
	fi

# Validate LaTeX syntax
.PHONY: validate
validate:
	@echo -e "$(BLUE)=== Validating LaTeX Syntax ===$(NC)"
	@if command -v lacheck >/dev/null 2>&1; then \
		lacheck $(SOURCE) || true; \
	else \
		echo -e "$(YELLOW)⚠ lacheck not found (optional)$(NC)"; \
	fi
	@if command -v chktex >/dev/null 2>&1; then \
		chktex -q $(SOURCE) || true; \
	else \
		echo -e "$(YELLOW)⚠ chktex not found (optional)$(NC)"; \
	fi

# ==============================================================================
# SPECIAL TARGETS
# ==============================================================================

# Prevent make from treating these as file targets
.PHONY: all compile fast pdf watch
.PHONY: clean distclean check check-fonts install-fonts wordcount open
.PHONY: format validate help

# ==============================================================================
# END OF MAKEFILE
# ==============================================================================
