#!/bin/bash

# ==============================================================================
# Delete Chapter Script
# ==============================================================================
# Description: Deletes a chapter file and removes it from the content loader
#              (01_content.tex)
# Usage:       ./scripts/delete_chapter.sh <chapter_filename>
# Example:     ./scripts/delete_chapter.sh 02_methodology
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
BACKUP_DIR="$PROJECT_ROOT/.chapter_backups"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

print_usage() {
    echo "Usage: $0 <chapter_filename>"
    echo ""
    echo "Deletes a chapter file and removes it from the content loader."
    echo ""
    echo "Arguments:"
    echo "  chapter_filename  Name of the chapter file (with or without .tex extension)"
    echo ""
    echo "Examples:"
    echo "  $0 02_methodology"
    echo "  $0 02_methodology.tex"
    echo ""
    echo "Note: Deleted files are backed up to .chapter_backups/"
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

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

get_chapter_title() {
    local file="$1"
    # Extract chapter title from \chapter{...} command
    if [ -f "$file" ]; then
        grep -m 1 "\\\\chapter{" "$file" 2>/dev/null | sed 's/.*\\chapter{\([^}]*\)}.*/\1/' || echo "Untitled"
    else
        echo "Unknown"
    fi
}

# ------------------------------------------------------------------------------
# Input Validation
# ------------------------------------------------------------------------------

# Check if argument provided
if [ $# -ne 1 ]; then
    print_error "Invalid number of arguments"
    print_usage
    exit 1
fi

CHAPTER_NAME="$1"

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
            basename "$file"
        fi
    done
    exit 1
fi

# Get chapter information before deletion
CHAPTER_TITLE=$(get_chapter_title "$CHAPTER_FILE")

# ------------------------------------------------------------------------------
# Confirmation
# ------------------------------------------------------------------------------

echo -e "${BLUE}==============================================================================
Chapter Deletion
==============================================================================${NC}"
echo ""
echo "You are about to delete:"
echo "  File: $(basename "$CHAPTER_FILE")"
echo "  Title: $CHAPTER_TITLE"
echo "  Full path: $CHAPTER_FILE"
echo ""
print_warning "This action will:"
echo "  1. Back up the file to .chapter_backups/"
echo "  2. Delete the chapter file"
echo "  3. Remove it from 01_content.tex (if included)"
echo ""
echo -n "Are you sure you want to continue? (y/N): "
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Deletion cancelled."
    exit 0
fi

# ------------------------------------------------------------------------------
# Create Backup
# ------------------------------------------------------------------------------

print_info "Creating backup..."

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate backup filename with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${CHAPTER_NAME}_${TIMESTAMP}.tex"

# Copy file to backup
cp "$CHAPTER_FILE" "$BACKUP_FILE"
print_success "Backup created: $BACKUP_FILE"

# ------------------------------------------------------------------------------
# Remove from Content Loader
# ------------------------------------------------------------------------------

print_info "Removing from content loader..."

# Create the input line pattern to search for
CHAPTER_INPUT_LINE="\\\\input{Content/Chapters/${CHAPTER_NAME}}"

# Check if the chapter is included in content file
if grep -q "$CHAPTER_INPUT_LINE" "$CONTENT_FILE" 2>/dev/null; then
    # Create a temporary file
    TEMP_FILE=$(mktemp)

    # Remove the line containing the chapter input
    grep -v "$CHAPTER_INPUT_LINE" "$CONTENT_FILE" > "$TEMP_FILE"

    # Move the temporary file back
    mv "$TEMP_FILE" "$CONTENT_FILE"

    print_success "Removed from content loader"
else
    print_info "Chapter was not included in content loader"
fi

# ------------------------------------------------------------------------------
# Delete Chapter File
# ------------------------------------------------------------------------------

print_info "Deleting chapter file..."

rm "$CHAPTER_FILE"
print_success "Chapter file deleted"

# ------------------------------------------------------------------------------
# Final Summary
# ------------------------------------------------------------------------------

echo ""
echo -e "${GREEN}==============================================================================
Chapter Successfully Deleted
==============================================================================${NC}"
echo ""
echo "Summary:"
echo "  ✓ Chapter file deleted: $(basename "$CHAPTER_FILE")"
echo "  ✓ Backup saved to: $(basename "$BACKUP_FILE")"
if grep -q "$CHAPTER_INPUT_LINE" "$CONTENT_FILE" 2>/dev/null; then
    echo "  ✓ Removed from document"
fi
echo ""
echo "Recovery options:"
echo "  To restore this chapter, copy the backup file back:"
echo "    cp \"$BACKUP_FILE\" \"$CHAPTER_FILE\""
echo ""
echo "  To re-include in document after restoration:"
echo "    Add the following line to Content/01_content.tex:"
echo "    $CHAPTER_INPUT_LINE"
echo ""
echo "All backups are stored in: .chapter_backups/"
