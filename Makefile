# Makefile for LaTeX documents

LATEX=latexmk
BIBTEX=biber
LATEX_FLAGS=-xelatex -shell-escape -synctex=1 -interaction=nonstopmode

SOURCE=Main.tex
PDF=$(SOURCE:.tex=.pdf)

OUT_DIR=Output

BUILD_DIR=Build

PDF_SOURCE=$(BUILD_DIR)/$(PDF)
PDF_TARGET=$(OUT_DIR)/$(PDF)

all: compile
	xdg-open $(PDF_TARGET)

clean:
	git clean -dfX

compile:
# If not Exists, create 'Build' directory
	[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	$(LATEX) $(LATEX_FLAGS) -output-directory=$(BUILD_DIR) $(SOURCE)
# If not Exists, create 'Output/' directory
	[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
# Copy the PDF to the 'Output/' directory
	cp $(PDF_SOURCE) $(PDF_TARGET)

.PHONY: all clean