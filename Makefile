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
TECTONIC_FLAGS = --keep-logs --keep-intermediates --print

# Main document
SOURCE = src/Main.tex
BUILD_DIR = build/Main
PDF_BUILD = $(BUILD_DIR)/Main.pdf

# Colors for output
BLUE = \033[0;34m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

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
	@echo -e "$(YELLOW)→ Running Tectonic first pass...$(NC)"
	# $(TECTONIC) -X compile $(TECTONIC_FLAGS) --pass=tex --outdir=$(BUILD_DIR) $(SOURCE)
	makeindex -t $(BUILD_DIR)/Main.glg -s $(BUILD_DIR)/Main.ist -o $(BUILD_DIR)/Main.gls $(BUILD_DIR)/Main.glo
	@echo -e "$(YELLOW)→ Running Tectonic second pass...$(NC)"
	$(TECTONIC) -X build $(TECTONIC_FLAGS)
	@if [ -f $(PDF_SOURCE) ]; then \
		echo -e "$(GREEN)✓ PDF created: $(PDF_BUILD)$(NC)"; \
	else \
		echo -e "$(RED)✗ PDF creation failed$(NC)"; \
		exit 1; \
	fi

# Draft mode - faster compilation with draft images and minimal processing
.PHONY: draft
draft:
	@echo -e "$(BLUE)=== Draft Mode Compilation ===$(NC)"
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	@echo -e "$(YELLOW)→ Running in draft mode (2 passes max)...$(NC)"
	$(TECTONIC) -X build
	@if [ -f $(PDF_SOURCE) ]; then \
		echo -e "$(GREEN)✓ Draft PDF created: $(PDF_BUILD)$(NC)"; \
	else \
		echo -e "$(RED)✗ PDF creation failed$(NC)"; \
		exit 1; \
	fi

# Alias for compile
.PHONY: pdf
pdf: compile

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

# Open the PDF
.PHONY: open
open: compile
	@echo -e "$(BLUE)=== Opening PDF ===$(NC)"
	@if [ -f $(PDF_TARGET) ]; then \
		if command -v xdg-open >/dev/null 2>&1; then \
			xdg-open $(PDF_BUILD); \
		elif command -v open >/dev/null 2>&1; then \
			open $(PDF_BUILD); \
		else \
			echo -e "$(RED)✗ No PDF viewer found$(NC)"; \
		fi; \
	else \
		echo -e "$(RED)✗ PDF not found. Run 'make' first.$(NC)"; \
	fi
