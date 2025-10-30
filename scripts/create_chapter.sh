#!/bin/bash

# ==============================================================================
# Create Chapter Script
# ==============================================================================
# Description: Creates a new chapter file and automatically adds it to the
#              content loader (01_content.tex)
# Usage:       ./scripts/create_chapter.sh <chapter_number> <chapter_name>
# Example:     ./scripts/create_chapter.sh 02 methodology
# Author:      HSRTReport Template
# ==============================================================================

set -e  # Exit on error

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CHAPTERS_DIR="$PROJECT_ROOT/Content/Chapters"
CONTENT_FILE="$PROJECT_ROOT/Content/01_content.tex"
TEMPLATE_FILE="$CHAPTERS_DIR/example_chapter.tex"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

print_usage() {
    echo "Usage: $0 <chapter_number> <chapter_name>"
    echo ""
    echo "Creates a new chapter file and adds it to the content loader."
    echo ""
    echo "Arguments:"
    echo "  chapter_number  Two-digit number (e.g., 02, 03, 10)"
    echo "  chapter_name    Name without spaces (e.g., methodology, results)"
    echo ""
    echo "Example:"
    echo "  $0 02 methodology"
    echo "  This creates: Content/Chapters/02_methodology.tex"
}

print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

capitalize_first() {
    echo "$1" | sed 's/\b\(.\)/\U\1/g'
}

# ------------------------------------------------------------------------------
# Input Validation
# ------------------------------------------------------------------------------

# Check if correct number of arguments
if [ $# -ne 2 ]; then
    print_error "Invalid number of arguments"
    print_usage
    exit 1
fi

CHAPTER_NUM="$1"
CHAPTER_NAME="$2"

# Validate chapter number (should be 2 digits)
if ! [[ "$CHAPTER_NUM" =~ ^[0-9]{2}$ ]]; then
    print_error "Chapter number must be exactly 2 digits (e.g., 02, 10)"
    exit 1
fi

# Validate chapter name (alphanumeric and underscores only)
if ! [[ "$CHAPTER_NAME" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    print_error "Chapter name must start with a letter and contain only letters, numbers, and underscores"
    exit 1
fi

# ------------------------------------------------------------------------------
# File Creation
# ------------------------------------------------------------------------------

CHAPTER_FILE="$CHAPTERS_DIR/${CHAPTER_NUM}_${CHAPTER_NAME}.tex"
CHAPTER_INPUT_LINE="\\\\input{Content/Chapters/${CHAPTER_NUM}_${CHAPTER_NAME}}"

# Check if file already exists
if [ -f "$CHAPTER_FILE" ]; then
    print_error "Chapter file already exists: $CHAPTER_FILE"
    echo "Do you want to overwrite it? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Create chapter file with template content
print_info "Creating chapter file: ${CHAPTER_NUM}_${CHAPTER_NAME}.tex"

CHAPTER_TITLE=$(capitalize_first "$CHAPTER_NAME" | tr '_' ' ')

cat > "$CHAPTER_FILE" << 'EOF'
% !TEX root = ../../Main.tex
% ==============================================================================
% Chapter: CHAPTER_TITLE_PLACEHOLDER
% ==============================================================================
% Description: [Add chapter description here]
% Author: [Your Name]
% Date: CURRENT_DATE
% ==============================================================================

% ------------------------------------------------------------------------------
% Chapter Declaration
% ------------------------------------------------------------------------------
\chapter{CHAPTER_TITLE_PLACEHOLDER}
\label{chap:CHAPTER_LABEL_PLACEHOLDER}

% ------------------------------------------------------------------------------
% Introduction
% ------------------------------------------------------------------------------
% Begin with an introduction to the chapter's content
% ------------------------------------------------------------------------------

[Introduction text for this chapter goes here. Provide an overview of what
will be covered in this chapter.]

% ------------------------------------------------------------------------------
% Section: First Section
% ------------------------------------------------------------------------------
\section{First Section}
\label{sec:CHAPTER_LABEL_PLACEHOLDER_first_section}

[Content for the first section goes here.]

% ------------------------------------------------------------------------------
% Subsection: Example Subsection
% ------------------------------------------------------------------------------
\subsection*{Example Subsection}
\label{subsec:CHAPTER_LABEL_PLACEHOLDER_example}

[Subsection content goes here.]

% ------------------------------------------------------------------------------
% Section: Second Section
% ------------------------------------------------------------------------------
\section{Second Section}
\label{sec:CHAPTER_LABEL_PLACEHOLDER_second_section}

[Content for the second section goes here.]

% Example of a figure reference
% \begin{figure}[htbp]
%     \centering
%     \includegraphics[width=0.8\textwidth]{Content/Images/your_image.png}
%     \caption{Caption for your figure}
%     \label{fig:CHAPTER_LABEL_PLACEHOLDER_example}
% \end{figure}

% Example of a table
% \begin{table}[htbp]
%     \centering
%     \caption{Caption for your table}
%     \label{tab:CHAPTER_LABEL_PLACEHOLDER_example}
%     \begin{tabular}{lcc}
%         \toprule
%         \textbf{Column 1} & \textbf{Column 2} & \textbf{Column 3} \\
%         \midrule
%         Data 1 & Value 1 & Result 1 \\
%         Data 2 & Value 2 & Result 2 \\
%         \bottomrule
%     \end{tabular}
% \end{table}

% ------------------------------------------------------------------------------
% Section: Summary
% ------------------------------------------------------------------------------
\section{Summary}
\label{sec:CHAPTER_LABEL_PLACEHOLDER_summary}

[Chapter summary goes here. Summarize the key points covered in this chapter.]

% ==============================================================================
% End of Chapter
% ==============================================================================
EOF

# Replace placeholders
sed -i "s/CHAPTER_TITLE_PLACEHOLDER/$CHAPTER_TITLE/g" "$CHAPTER_FILE"
sed -i "s/CHAPTER_LABEL_PLACEHOLDER/$CHAPTER_NAME/g" "$CHAPTER_FILE"
sed -i "s/CURRENT_DATE/$(date +%Y-%m-%d)/g" "$CHAPTER_FILE"

print_success "Chapter file created: $CHAPTER_FILE"

# ------------------------------------------------------------------------------
# Update Content Loader
# ------------------------------------------------------------------------------

print_info "Updating content loader: 01_content.tex"

# Check if the chapter is already included
if grep -q "$CHAPTER_INPUT_LINE" "$CONTENT_FILE" 2>/dev/null; then
    print_info "Chapter already included in content loader"
else
    # Add the chapter input line before the END marker
    # Using a more robust method to handle the insertion

    # Create a temporary file
    TEMP_FILE=$(mktemp)

    # Process the content file
    awk -v input_line="$CHAPTER_INPUT_LINE" '
    /^% --- CHAPTER LIST END ---/ {
        print input_line
    }
    { print }
    ' "$CONTENT_FILE" > "$TEMP_FILE"

    # Move the temporary file back
    mv "$TEMP_FILE" "$CONTENT_FILE"

    print_success "Added chapter to content loader"
fi

# ------------------------------------------------------------------------------
# Final Output
# ------------------------------------------------------------------------------

echo ""
print_success "Chapter successfully created!"
echo ""
echo "Chapter file: $CHAPTER_FILE"
echo "Chapter will be included in the document automatically."
echo ""
echo "Next steps:"
echo "1. Edit the chapter file to add your content"
echo "2. Build the document with 'make' or 'xelatex Main.tex'"
echo ""
echo "To reference this chapter in other parts of your document, use:"
echo "  \\ref{chap:${CHAPTER_NAME}}"
