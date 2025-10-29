#!/bin/bash

# ==============================================================================
# List Chapters Script
# ==============================================================================
# Description: Lists all chapter files in the project and shows their inclusion
#              status in the content loader
# Usage:       ./scripts/list_chapters.sh
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

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

print_header() {
    echo -e "${BLUE}==============================================================================
Chapter Management - File List
==============================================================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}○${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

get_chapter_title() {
    local file="$1"
    # Extract chapter title from \chapter{...} command
    if [ -f "$file" ]; then
        grep -m 1 "\\\\chapter{" "$file" 2>/dev/null | sed 's/.*\\chapter{\([^}]*\)}.*/\1/' || echo "Untitled"
    else
        echo "File not found"
    fi
}

is_included() {
    local chapter_name="$1"
    # Check if chapter is included in content file
    if grep -q "\\\\input{Content/Chapters/$chapter_name}" "$CONTENT_FILE" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# ------------------------------------------------------------------------------
# Main Script
# ------------------------------------------------------------------------------

print_header
echo ""

# Check if chapters directory exists
if [ ! -d "$CHAPTERS_DIR" ]; then
    print_error "Chapters directory not found: $CHAPTERS_DIR"
    exit 1
fi

# Get all .tex files in chapters directory
CHAPTER_FILES=()
while IFS= read -r -d '' file; do
    CHAPTER_FILES+=("$file")
done < <(find "$CHAPTERS_DIR" -maxdepth 1 -name "*.tex" -type f -print0 | sort -z)

if [ ${#CHAPTER_FILES[@]} -eq 0 ]; then
    echo "No chapter files found in $CHAPTERS_DIR"
    echo ""
    echo "To create a new chapter, use:"
    echo "  ./scripts/create_chapter.sh <number> <name>"
    echo ""
    echo "Example:"
    echo "  ./scripts/create_chapter.sh 01 introduction"
    exit 0
fi

# ------------------------------------------------------------------------------
# Display Chapter List
# ------------------------------------------------------------------------------

echo -e "${CYAN}Found ${#CHAPTER_FILES[@]} chapter file(s):${NC}"
echo ""

# Table header
printf "%-6s %-30s %-40s %-10s\n" "No." "File Name" "Chapter Title" "Status"
printf "%-6s %-30s %-40s %-10s\n" "---" "$(printf '%30s' | tr ' ' '-')" "$(printf '%40s' | tr ' ' '-')" "----------"

# List each chapter
for i in "${!CHAPTER_FILES[@]}"; do
    FILE="${CHAPTER_FILES[$i]}"
    BASENAME=$(basename "$FILE")
    FILENAME="${BASENAME%.*}"
    TITLE=$(get_chapter_title "$FILE")

    # Truncate long titles
    if [ ${#TITLE} -gt 38 ]; then
        TITLE="${TITLE:0:35}..."
    fi

    # Check if included
    if is_included "$FILENAME"; then
        STATUS="${GREEN}Included${NC}"
    else
        STATUS="${YELLOW}Not included${NC}"
    fi

    printf "%-6s %-30s %-40s " "$((i+1))." "$BASENAME" "$TITLE"
    echo -e "$STATUS"
done

echo ""

# ------------------------------------------------------------------------------
# Statistics
# ------------------------------------------------------------------------------

echo -e "${BLUE}------------------------------------------------------------------------------${NC}"
echo "Statistics:"

# Count included chapters
INCLUDED_COUNT=0
NOT_INCLUDED_COUNT=0

for FILE in "${CHAPTER_FILES[@]}"; do
    BASENAME=$(basename "$FILE")
    FILENAME="${BASENAME%.*}"
    if is_included "$FILENAME"; then
        ((INCLUDED_COUNT++)) || true
    else
        ((NOT_INCLUDED_COUNT++)) || true
    fi
done

echo "  Total chapters: ${#CHAPTER_FILES[@]}"
echo -e "  Included in document: ${GREEN}$INCLUDED_COUNT${NC}"
echo -e "  Not included: ${YELLOW}$NOT_INCLUDED_COUNT${NC}"

# ------------------------------------------------------------------------------
# Chapter Order in Document
# ------------------------------------------------------------------------------

echo ""
echo -e "${BLUE}------------------------------------------------------------------------------${NC}"
echo "Chapter order in document (01_content.tex):"
echo ""

# Extract included chapters from content file
if [ -f "$CONTENT_FILE" ]; then
    INCLUDED_CHAPTERS=()
    while IFS= read -r line; do
        if [[ "$line" =~ \\input\{Content/Chapters/([^}]+)\} ]]; then
            INCLUDED_CHAPTERS+=("${BASH_REMATCH[1]}.tex")
        fi
    done < <(sed -n '/% --- CHAPTER LIST START ---/,/% --- CHAPTER LIST END ---/p' "$CONTENT_FILE")

    if [ ${#INCLUDED_CHAPTERS[@]} -gt 0 ]; then
        for i in "${!INCLUDED_CHAPTERS[@]}"; do
            CHAPTER="${INCLUDED_CHAPTERS[$i]}"
            TITLE=$(get_chapter_title "$CHAPTERS_DIR/$CHAPTER")
            printf "  %2d. %-30s %s\n" "$((i+1))" "$CHAPTER" "($TITLE)"
        done
    else
        echo "  (No chapters currently included)"
    fi
else
    print_error "Content file not found: $CONTENT_FILE"
fi

# ------------------------------------------------------------------------------
# Help Information
# ------------------------------------------------------------------------------

echo ""
echo -e "${BLUE}------------------------------------------------------------------------------${NC}"
echo "Available commands:"
echo ""
echo "  Create chapter:  ./scripts/create_chapter.sh <number> <name>"
echo "  List chapters:   ./scripts/list_chapters.sh"
echo "  Delete chapter:  ./scripts/delete_chapter.sh <filename>"
echo "  Show chapter:    ./scripts/show_chapter.sh <filename>"
echo ""
echo "To manually include/exclude chapters, edit: Content/01_content.tex"
echo ""

# Exit successfully
exit 0
