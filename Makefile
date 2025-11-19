# ==============================================================================
# Makefile for HSRTReport LaTeX Template
# ==============================================================================
# Description: Build automation for LaTeX documents with chapter management
# Usage:       make [target]
# Author:      HSRTReport Template
# ==============================================================================

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
LATEX = latexmk
TEX_ENGINE = lualatex
LATEX_FLAGS = -$(TEX_ENGINE) -shell-escape -synctex=1 -interaction=nonstopmode
BIBER = biber
MAKEGLOSSARIES = makeglossaries

# Main document
SOURCE = Main.tex
PDF = $(SOURCE:.tex=.pdf)

# Directories
BUILD_DIR = Build
OUT_DIR = Output
CHAPTERS_DIR = Content/Chapters
SCRIPTS_DIR = scripts

# Output files
PDF_SOURCE = $(BUILD_DIR)/$(PDF)
PDF_TARGET = $(OUT_DIR)/$(PDF)

# Platform detection for opening PDF
UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
	OPEN_CMD = xdg-open
else ifeq ($(UNAME), Darwin)
	OPEN_CMD = open
else
	OPEN_CMD = start
endif

# Colors for output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
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

# ------------------------------------------------------------------------------
# Main Targets
# ------------------------------------------------------------------------------
# Default target: Use Docker for compilation if available
.PHONY: all
all: docker-build
	@echo -e "$(GREEN)✓ Document built successfully using Docker$(NC)"

# Alternative: Local build without Docker
.PHONY: local
local: compile view
	@echo -e "$(GREEN)✓ Document built and opened successfully (local)$(NC)"

.PHONY: compile
compile:
	@echo -e "$(BLUE)=== Building LaTeX Document ===$(NC)"
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	@echo -e "$(YELLOW)→ Running $(TEX_ENGINE)...$(NC)"
	$(LATEX) $(LATEX_FLAGS) -output-directory=$(BUILD_DIR) $(SOURCE)
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	@cp $(PDF_SOURCE) $(PDF_TARGET)
	@echo -e "$(GREEN)✓ PDF created: $(PDF_TARGET)$(NC)"

.PHONY: full
full: clean-aux compile
	@echo -e "$(GREEN)✓ Full build completed$(NC)"

.PHONY: view
view:
	@echo -e "$(BLUE)→ Opening PDF...$(NC)"
	@if [ -f $(PDF_TARGET) ]; then \
		$(OPEN_CMD) $(PDF_TARGET); \
	else \
		echo -e "$(RED)✗ PDF not found. Run 'make compile' first$(NC)"; \
		exit 1; \
	fi

# ------------------------------------------------------------------------------
# Docker Targets
# ------------------------------------------------------------------------------
.PHONY: docker-info
docker-info:
	@echo -e "$(BLUE)=== Docker Configuration ===$(NC)"
	@if command -v docker >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓ Docker:$(NC) $$(docker --version | cut -d' ' -f3 | tr -d ',')"; \
	else \
		echo -e "$(RED)✗ Docker:$(NC) Not found"; \
	fi
	@echo -e "$(GREEN)✓ Docker Compose:$(NC) $(DOCKER_COMPOSE_CMD) ($(DOCKER_COMPOSE_TYPE))"
	@if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓ Docker Daemon:$(NC) Running"; \
		echo -e "$(GREEN)✓ Containers:$(NC) $$(docker ps -q | wc -l) running, $$(docker ps -aq | wc -l) total"; \
		echo -e "$(GREEN)✓ Images:$(NC) $$(docker images -q | wc -l) available"; \
	else \
		echo -e "$(YELLOW)⚠ Docker Daemon:$(NC) Not running or not accessible"; \
	fi
	@echo ""

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
	@echo -e "$(YELLOW)→ Starting Docker container with UID=$$(id -u) GID=$$(id -g)...$(NC)"
	@HOST_UID=$$(id -u) HOST_GID=$$(id -g) $(DOCKER_COMPOSE_CMD) up --build || { \
		echo -e "$(RED)✗ Docker build failed$(NC)"; \
		echo -e "$(YELLOW)  Try 'make docker-clean' and rebuild$(NC)"; \
		exit 1; \
	}
	@echo -e "$(GREEN)✓ Docker build completed$(NC)"
	@echo -e "$(GREEN)✓ PDF created: $(PDF_TARGET)$(NC)"

.PHONY: docker-build-cached
docker-build-cached: check-docker
	@echo -e "$(BLUE)=== Building LaTeX Document with Docker (cached) ===$(NC)"
	@echo -e "$(YELLOW)→ Starting Docker container (using cache)...$(NC)"
	@$(DOCKER_COMPOSE_CMD) up || { \
		echo -e "$(RED)✗ Docker build failed$(NC)"; \
		echo -e "$(YELLOW)  Try 'make docker-build' to rebuild the image$(NC)"; \
		exit 1; \
	}
	@echo -e "$(GREEN)✓ Docker build completed$(NC)"

.PHONY: docker-clean
docker-clean: check-docker
	@echo -e "$(YELLOW)→ Removing Docker containers...$(NC)"
	@$(DOCKER_COMPOSE_CMD) down --remove-orphans || true
	@echo -e "$(GREEN)✓ Docker containers removed$(NC)"

.PHONY: docker-shell
docker-shell: check-docker
	@echo -e "$(BLUE)→ Opening shell in Docker container...$(NC)"
	@$(DOCKER_COMPOSE_CMD) run --rm --entrypoint /bin/bash latex || { \
		echo -e "$(RED)✗ Failed to start Docker shell$(NC)"; \
		exit 1; \
	}

# ------------------------------------------------------------------------------
# Clean Targets
# ------------------------------------------------------------------------------
.PHONY: clean
clean: clean-aux clean-output
	@echo -e "$(GREEN)✓ All files cleaned$(NC)"

.PHONY: clean-aux
clean-aux:
	@echo -e "$(YELLOW)→ Cleaning auxiliary files...$(NC)"
	@rm -rf $(BUILD_DIR)
	@rm -f *.aux *.log *.out *.toc *.lof *.lot *.lol *.bbl *.blg *.synctex.gz
	@rm -f *.fdb_latexmk *.fls *.idx *.ind *.ilg *.glo *.gls *.glg
	@rm -f Content/*.aux Content/Chapters/*.aux
	@echo -e "$(GREEN)✓ Auxiliary files cleaned$(NC)"

.PHONY: clean-output
clean-output:
	@echo -e "$(YELLOW)→ Cleaning output files...$(NC)"
	@rm -rf $(OUT_DIR)
	@echo -e "$(GREEN)✓ Output files cleaned$(NC)"

.PHONY: distclean
distclean: clean
	@echo -e "$(YELLOW)→ Removing all generated files...$(NC)"
	@git clean -dfX 2>/dev/null || rm -rf $(BUILD_DIR) $(OUT_DIR)
	@echo -e "$(GREEN)✓ Distribution clean completed$(NC)"

# ------------------------------------------------------------------------------
# Chapter Management Targets
# ------------------------------------------------------------------------------
.PHONY: chapter
chapter:
	@if [ -z "$(NUM)" ] || [ -z "$(NAME)" ]; then \
		echo -e "$(RED)✗ Usage: make chapter NUM=02 NAME=methodology$(NC)"; \
		exit 1; \
	fi
	@echo -e "$(BLUE)=== Creating New Chapter ===$(NC)"
	@$(SCRIPTS_DIR)/create_chapter.sh $(NUM) $(NAME)

.PHONY: chapters
chapters: list-chapters

.PHONY: list-chapters
list-chapters:
	@echo -e "$(BLUE)=== Chapter Overview ===$(NC)"
	@$(SCRIPTS_DIR)/list_chapters.sh

.PHONY: show-chapter
show-chapter:
	@if [ -z "$(NAME)" ]; then \
		echo -e "$(RED)✗ Usage: make show-chapter NAME=02_methodology$(NC)"; \
		exit 1; \
	fi
	@$(SCRIPTS_DIR)/show_chapter.sh $(NAME)

.PHONY: delete-chapter
delete-chapter:
	@if [ -z "$(NAME)" ]; then \
		echo -e "$(RED)✗ Usage: make delete-chapter NAME=02_methodology$(NC)"; \
		exit 1; \
	fi
	@echo -e "$(YELLOW)⚠ Warning: This will delete the chapter file$(NC)"
	@$(SCRIPTS_DIR)/delete_chapter.sh $(NAME)

# ------------------------------------------------------------------------------
# Development Targets
# ------------------------------------------------------------------------------
.PHONY: watch
watch:
	@echo -e "$(BLUE)=== Starting continuous build ===$(NC)"
	@echo -e "$(YELLOW)→ Watching for changes... (Ctrl+C to stop)$(NC)"
	$(LATEX) $(LATEX_FLAGS) -pvc -output-directory=$(BUILD_DIR) $(SOURCE)

.PHONY: draft
draft:
	@echo -e "$(BLUE)=== Building draft version ===$(NC)"
	$(LATEX) -$(TEX_ENGINE) -interaction=nonstopmode -output-directory=$(BUILD_DIR) $(SOURCE)
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	@cp $(PDF_SOURCE) $(OUT_DIR)/$(SOURCE:.tex=_draft.pdf)
	@echo -e "$(GREEN)✓ Draft created: $(OUT_DIR)/$(SOURCE:.tex=_draft.pdf)$(NC)"

# ------------------------------------------------------------------------------
# Utility Targets
# ------------------------------------------------------------------------------
.PHONY: count
count:
	@echo -e "$(BLUE)=== Document Statistics ===$(NC)"
	@echo -n "Chapters: "
	@ls -1 $(CHAPTERS_DIR)/*.tex 2>/dev/null | wc -l
	@echo -n "Total lines: "
	@wc -l $(CHAPTERS_DIR)/*.tex 2>/dev/null | tail -1 | awk '{print $$1}'
	@echo -n "Approx. words: "
	@cat $(CHAPTERS_DIR)/*.tex 2>/dev/null | \
		sed 's/\\[a-zA-Z]*\({[^}]*}\)\?//g' | wc -w

.PHONY: check
check:
	@echo -e "$(BLUE)=== Checking Prerequisites ===$(NC)"
	@command -v $(TEX_ENGINE) >/dev/null 2>&1 && \
		echo -e "$(GREEN)✓ $(TEX_ENGINE) found$(NC)" || \
		echo -e "$(RED)✗ $(TEX_ENGINE) not found$(NC)"
	@command -v biber >/dev/null 2>&1 && \
		echo -e "$(GREEN)✓ Biber found$(NC)" || \
		echo -e "$(RED)✗ Biber not found$(NC)"
	@command -v makeglossaries >/dev/null 2>&1 && \
		echo -e "$(GREEN)✓ makeglossaries found$(NC)" || \
		echo -e "$(RED)✗ makeglossaries not found$(NC)"
	@command -v latexmk >/dev/null 2>&1 && \
		echo -e "$(GREEN)✓ latexmk found$(NC)" || \
		echo -e "$(RED)✗ latexmk not found$(NC)"

.PHONY: structure
structure:
	@echo -e "$(BLUE)=== Project Structure ===$(NC)"
	@tree -d -L 2 --charset ascii 2>/dev/null || \
		find . -type d -maxdepth 2 | sed 's|./||' | sort

# ------------------------------------------------------------------------------
# Help Target
# ------------------------------------------------------------------------------
.PHONY: help
help:
	@echo -e "$(BLUE)==============================================================================="
	@echo "HSRTReport LaTeX Template - Makefile Targets"
	@echo -e "===============================================================================$(NC)"
	@echo ""
	@echo -e "$(GREEN)Main Targets:$(NC)"
	@echo "  make              - Build document using Docker (default)"
	@echo "  make local        - Build document locally and open PDF"
	@echo "  make compile      - Build the LaTeX document (local)"
	@echo "  make full         - Clean and rebuild everything"
	@echo "  make view         - Open the PDF file"
	@echo ""
	@echo -e "$(GREEN)Docker Targets:$(NC)"
	@echo "  make docker-info         - Show Docker configuration and status"
	@echo "  make check-docker        - Check if Docker is available"
	@echo "  make docker-build        - Build with Docker (rebuild image)"
	@echo "  make docker-build-cached - Build with Docker (use cached image)"
	@echo "  make docker-shell        - Open shell in Docker container"
	@echo "  make docker-clean        - Remove Docker containers"
	@echo ""
	@echo -e "$(GREEN)Chapter Management:$(NC)"
	@echo "  make chapter NUM=02 NAME=methodology  - Create a new chapter"
	@echo "  make chapters                         - List all chapters"
	@echo "  make show-chapter NAME=02_methodology - Display chapter content"
	@echo "  make delete-chapter NAME=02_methodology - Delete a chapter (with backup)"
	@echo ""
	@echo -e "$(GREEN)Cleaning:$(NC)"
	@echo "  make clean        - Remove all generated files"
	@echo "  make clean-aux    - Remove auxiliary files only"
	@echo "  make clean-output - Remove output files only"
	@echo "  make distclean    - Remove everything (git clean)"
	@echo ""
	@echo -e "$(GREEN)Development:$(NC)"
	@echo "  make watch        - Continuous compilation on file changes"
	@echo "  make draft        - Quick draft compilation"
	@echo ""
	@echo -e "$(GREEN)Utilities:$(NC)"
	@echo "  make count        - Show document statistics"
	@echo "  make check        - Check for required tools"
	@echo "  make structure    - Show project structure"
	@echo "  make help         - Show this help message"
	@echo ""
	@echo -e "$(YELLOW)Examples:$(NC)"
	@echo "  make chapter NUM=01 NAME=introduction"
	@echo "  make chapter NUM=02 NAME=literature_review"
	@echo "  make show-chapter NAME=01_introduction"
	@echo ""

# Default target - use Docker build
.DEFAULT_GOAL := all
