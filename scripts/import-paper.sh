#!/usr/bin/env bash
# ==============================================================================
# Script: import-paper.sh
# Purpose: Safely copies an external LaTeX paper into the website repository
#          under papers/<genre>/ without modifying the original source.
# Usage: ./scripts/import-paper.sh <path-to-tex-file> <genre> [slug]
# ==============================================================================

# Halt on error, unset variables, or failed pipe commands
set -euo pipefail

# Resolve paths dynamically relative to the script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Validate required positional parameters
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <path-to-tex-file> <genre> [slug]"
    echo ""
    echo "Genres: linguistics, literature, film, poetry, philosophy, technical, essays, other"
    echo "Example: $0 ~/Documents/my_paper.tex linguistics laryngeal-coloring"
    exit 1
fi

# Input arguments:
# $1 = Path to the original .tex paper file
# $2 = Genre subfolder under papers/ (e.g., linguistics, literature)
# $3 = Optional slug name (defaults to the file basename without .tex)
SOURCE_FILE="$1"
GENRE="$2"
BASENAME="$(basename "${SOURCE_FILE}" .tex)"
SLUG="${3:-${BASENAME}}"

# Ensure the source file actually exists before proceeding
if [ ! -f "${SOURCE_FILE}" ]; then
    echo "Error: File '${SOURCE_FILE}' does not exist."
    exit 1
fi

# Target paths inside the website repository
TARGET_DIR="${ROOT_DIR}/papers/${GENRE}"
TARGET_FILE="${TARGET_DIR}/${SLUG}.tex"

# Create destination genre directory if it does not already exist
mkdir -p "${TARGET_DIR}"

# Guard against accidental overwriting of an existing staged paper
if [ -f "${TARGET_FILE}" ]; then
    echo "Warning: Target file '${TARGET_FILE}' already exists."
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Copy external paper to website repository (leaves the source file untouched)
cp "${SOURCE_FILE}" "${TARGET_FILE}"

echo "======================================================"
echo "  Successfully staged paper into website repository:"
echo "  Source: ${SOURCE_FILE} (original untouched)"
echo "  Target: ${TARGET_FILE}"
echo "======================================================"
echo ""
echo "Next steps:"
echo "1. Edit and review grammar in: papers/${GENRE}/${SLUG}.tex"
echo "2. Compile to PDF with:"
echo "   pdflatex -output-directory=pdfs papers/${GENRE}/${SLUG}.tex"
echo "3. Add a card for this paper in 'pages/writing.md':"
echo ""
echo "   <div class=\"paper-card\">"
echo "       <div class=\"paper-header\">"
echo "           <h3 class=\"paper-title\">$(echo "${SLUG}" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')</h3>"
echo "           <span class=\"paper-meta\">${GENRE} &middot; $(date +%Y)</span>"
echo "       </div>"
echo "       <p class=\"paper-description\">"
echo "           Add paper abstract or short description here."
echo "       </p>"
echo "       <a href=\"/pdfs/${SLUG}.pdf\" class=\"btn btn-accent\" download>"
echo "           &darr; Download PDF"
echo "       </a>"
echo "   </div>"
echo "======================================================"
