#!/bin/bash

# ==============================================================================
# Show Chapter Script
# ==============================================================================
# Description: Displays information and content of a specific chapter file
# Usage:       ./scripts/show_chapter.sh <chapter_filename>
# Example:     ./scripts/show_chapter.sh 02_methodology
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
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

print_usage() {
    echo "Usage: $0 <chapter_filename> [options]"
    echo ""
    echo "Displays information and content of a specific chapter file."
    echo ""
    echo "Arguments:"
    echo "  chapter_filename  Name of the chapter file (with or without .tex extension)"
    echo ""
    echo "Options:"
    echo "  -h, --head N     Show only first N lines of content (default: all)"
    echo "  -i, --info       Show only file information, no content"
    echo "  -s, --structure  Show only document structure (chapters, sections)"
    echo ""
    echo "Examples:"
    echo "  $0 02_methodology"
    echo "  $0 02_methodology.tex --head 50"
    echo "  $0 01_introduction --info"
    echo "  $0 03_results --structure"
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

print_header() {
    echo -e "${BLUE}$1${NC}"
}

get_chapter_title() {
    local file="$1"
    if [ -f "$file" ]; then
        grep -m 1 "\\\\chapter{" "$file" 2>/dev/null | sed 's/.*\\chapter{\([^}]*\)}.*/\1/' || echo "Untitled"
    else
        echo "Unknown"
    fi
}

get_chapter_label() {
    local file="$1"
    if [ -f "$file" ]; then
        grep -m 1 "\\\\label{chap:" "$file" 2>/dev/null | sed 's/.*\\label{chap:\([^}]*\)}.*/\1/' || echo "no-label"
    else
        echo "unknown"
    fi
}

is_included() {
    local chapter_name="$1"
    if grep -q "\\\\input{Content/Chapters/$chapter_name}" "$CONTENT_FILE" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

count_lines() {
    local file="$1"
    wc -l < "$file"
}

count_words() {
    local file="$1"
    # Count words excluding LaTeX commands (approximate)
    sed 's/\\[a-zA-Z]*\({[^}]*}\)\?//g' "$file" | wc -w
}

get_file_size() {
    local file="$1"
    local size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)

    if [ "$size" -lt 1024 ]; then
        echo "${size} bytes"
    elif [ "$size" -lt 1048576 ]; then
        echo "$((size / 1024)) KB"
    else
        echo "$((size / 1048576)) MB"
    fi
}

get_modification_date() {
    local file="$1"
    stat -c%y "$file" 2>/dev/null | cut -d' ' -f1 || stat -f "%Sm" -t "%Y-%m-%d" "$file" 2>/dev/null || echo "Unknown"
}

show_structure() {
    local file="$1"
    echo -e "${CYAN}Document Structure:${NC}"
    echo ""

    # Extract chapters, sections, subsections
    grep -n "\\\\chapter\|\\\\section\|\\\\subsection" "$file" | while IFS=: read -r line_num content; do
        if [[ "$content" =~ \\chapter ]]; then
            title=$(echo "$content" | sed 's/.*\\chapter{\([^}]*\)}.*/\1/')
            echo -e "${MAGENTA}[$line_num] CHAPTER: $title${NC}"
        elif [[ "$content" =~ \\section ]]; then
            title=$(echo "$content" | sed 's/.*\\section{\([^}]*\)}.*/\1/')
            echo -e "${BLUE}  [$line_num] Section: $title${NC}"
        elif [[ "$content" =~ \\subsection ]]; then
            title=$(echo "$content" | sed 's/.*\\subsection{\([^}]*\)}.*/\1/')
            echo -e "${CYAN}    [$line_num] Subsection: $title${NC}"
        fi
    done
}

# ------------------------------------------------------------------------------
# Parse Arguments
# ------------------------------------------------------------------------------

if [ $# -eq 0 ]; then
    print_error "No arguments provided"
    print_usage
    exit 1
fi

CHAPTER_NAME="$1"
shift

# Default options
SHOW_HEAD=0
INFO_ONLY=false
STRUCTURE_ONLY=false

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--head)
            SHOW_HEAD="$2"
            shift 2
            ;;
        -i|--info)
            INFO_ONLY=true
            shift
            ;;
        -s|--structure)
            STRUCTURE_ONLY=true
            shift
            ;;
        --help)
            print_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# ------------------------------------------------------------------------------
# Validate Input
# ------------------------------------------------------------------------------

# Remove .tex extension if provided
CHAPTER_NAME="${CHAPTER_NAME%.tex}"

# Full path to chapter file
CHAPTER_FILE="$CHAPTERS_DIR/${CHAPTER_NAME}.tex"

# Check if file exists
if [ ! -f "$CHAPTER_FILE" ]; then
    print_error "Chapter file not found: $CHAPTER_FILE"
    echo ""
    echo "Available chapters:"
    for file in "$CHAPTERS_DIR"/*.tex; do
        if [ -f "$file" ]; then
            echo "  - $(basename "$file" .tex)"
        fi
    done
    exit 1
fi

# ------------------------------------------------------------------------------
# Display Chapter Information
# ------------------------------------------------------------------------------

echo -e "${BLUE}==============================================================================
Chapter Information
==============================================================================${NC}"
echo ""

# Basic information
echo -e "${CYAN}File Information:${NC}"
echo "  File name:     $(basename "$CHAPTER_FILE")"
echo "  Full path:     $CHAPTER_FILE"
echo "  File size:     $(get_file_size "$CHAPTER_FILE")"
echo "  Modified:      $(get_modification_date "$CHAPTER_FILE")"
echo "  Line count:    $(count_lines "$CHAPTER_FILE")"
echo "  Word count:    ~$(count_words "$CHAPTER_FILE") words (approximate)"
echo ""

# Chapter metadata
echo -e "${CYAN}Chapter Metadata:${NC}"
echo "  Title:         $(get_chapter_title "$CHAPTER_FILE")"
echo "  Label:         chap:$(get_chapter_label "$CHAPTER_FILE")"

if is_included "$CHAPTER_NAME"; then
    echo -e "  Status:        ${GREEN}Included in document${NC}"
else
    echo -e "  Status:        ${YELLOW}Not included in document${NC}"
fi

echo ""

# ------------------------------------------------------------------------------
# Show Structure if Requested
# ------------------------------------------------------------------------------

if [ "$STRUCTURE_ONLY" = true ]; then
    show_structure "$CHAPTER_FILE"
    exit 0
fi

# ------------------------------------------------------------------------------
# Exit if Info Only
# ------------------------------------------------------------------------------

if [ "$INFO_ONLY" = true ]; then
    exit 0
fi

# ------------------------------------------------------------------------------
# Display Chapter Content
# ------------------------------------------------------------------------------

echo -e "${BLUE}------------------------------------------------------------------------------${NC}"
echo -e "${CYAN}Chapter Content:${NC}"
echo -e "${BLUE}------------------------------------------------------------------------------${NC}"
echo ""

if [ "$SHOW_HEAD" -gt 0 ]; then
    head -n "$SHOW_HEAD" "$CHAPTER_FILE"
    echo ""
    echo -e "${YELLOW}... (showing first $SHOW_HEAD lines, $(count_lines "$CHAPTER_FILE") total lines)${NC}"
else
    cat "$CHAPTER_FILE"
fi

echo ""
echo -e "${BLUE}------------------------------------------------------------------------------${NC}"
echo -e "${CYAN}End of Chapter${NC}"
echo -e "${BLUE}------------------------------------------------------------------------------${NC}"

# ------------------------------------------------------------------------------
# Show Related Commands
# ------------------------------------------------------------------------------

echo ""
echo "Related commands:"
echo "  Edit this chapter:     \$EDITOR \"$CHAPTER_FILE\""
echo "  Show structure only:   $0 $CHAPTER_NAME --structure"
echo "  Show info only:        $0 $CHAPTER_NAME --info"
if ! is_included "$CHAPTER_NAME"; then
    echo ""
    echo "To include this chapter in the document, add the following line to"
    echo "Content/01_content.tex in the marked chapter section:"
    echo "  \\input{Content/Chapters/$CHAPTER_NAME}"
fi
