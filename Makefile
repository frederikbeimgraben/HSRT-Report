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
BUILD_DIR = build/PDF
PDF_BUILD = $(BUILD_DIR)/Main.pdf

# Docker / latexmk
LATEXMK = latexmk
LATEXMK_FLAGS = -xelatex -shell-escape -synctex=1 -interaction=nonstopmode
BIBER = biber
MAKEGLOSSARIES = makeglossaries

# Colors for output
BLUE = \033[0;34m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Docker Compose command detection
# Support both docker-compose (standalone) and docker compose (plugin)
DOCKER_COMPOSE := $(shell command -v docker-compose 2> /dev/null)
ifdef DOCKER_COMPOSE
    DOCKER_COMPOSE_CMD = docker-compose
    DOCKER_COMPOSE_TYPE = standalone
else
    DOCKER_COMPOSE_CMD = docker compose
    DOCKER_COMPOSE_TYPE = plugin
endif

# Docker availability check
DOCKER_AVAILABLE := $(shell command -v docker 2> /dev/null)

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
	$(TECTONIC) -X compile $(TECTONIC_FLAGS) --pass=tex --outdir=$(BUILD_DIR) $(SOURCE)
	makeindex -t $(BUILD_DIR)/Main.glg -s $(BUILD_DIR)/Main.ist -o $(BUILD_DIR)/Main.gls $(BUILD_DIR)/Main.glo
	@echo -e "$(YELLOW)→ Running Tectonic...$(NC)"
	$(TECTONIC) -X build $(TECTONIC_FLAGS)
	@echo -e "$(GREEN)✓ Build done$(NC)"

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

# INTERNAL DOCKER DIRECTIVES
.PHONY: docker-build-entrypoint
docker-build-entrypoint:
	@echo -e "$(BLUE)=== Building LaTeX Document using latexmk ===$(NC)"
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	@echo -e "$(YELLOW)→ Running XeLaTeX...$(NC)"
	cd $(shell dirname $(SOURCE)) && $(LATEXMK) $(LATEXMK_FLAGS) -output-directory=$(BUILD_DIR) $(shell basename $(SOURCE))
	@echo -e "$(GREEN)✓ Build Done"

.PHONY: check-docker
check-docker:
	@command -v docker >/dev/null 2>&1 || { \
		echo -e "$(RED)✗ Docker is not installed or not in PATH$(NC)"; \
		echo -e "$(YELLOW)  Please install Docker from https://docs.docker.com/get-docker/$(NC)"; \
		exit 1; \
	}
	@docker info >/dev/null 2>&1 || { \
		echo -e "$(RED)✗ Docker daemon is not running$(NC)"; \
		echo -e "$(YELLOW)  Please start Docker Desktop or the Docker daemon$(NC)"; \
		exit 1; \
	}
	@echo -e "$(GREEN)✓ Docker is available$(NC)"
	@echo -e "$(YELLOW)→ Using Docker Compose command: $(DOCKER_COMPOSE_CMD)$(NC)"

.PHONY: docker-build
docker-build: check-docker
	@echo -e "$(BLUE)=== Building LaTeX Document with Docker ===$(NC)"
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	@echo -e "$(YELLOW)→ Starting Docker container with UID=$$(id -u) GID=$$(id -g)...$(NC)"
	@HOST_UID=$$(id -u) HOST_GID=$$(id -g) $(DOCKER_COMPOSE_CMD) up --build || { \
		echo -e "$(RED)✗ Docker build failed$(NC)"; \
		echo -e "$(YELLOW)  Try to delete build/ and rebuild$(NC)"; \
		exit 1; \
	}
	@echo -e "$(GREEN)✓ Docker build completed$(NC)"
