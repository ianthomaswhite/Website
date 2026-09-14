#!/usr/bin/env bash
# ==============================================================================
# Script: build-resumes.sh
# Purpose: Compiles the 1-page LaTeX resume and generates the full resume PDF
#          directly from pages/resume.md using Pandoc.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

PDF_DIR="${ROOT_DIR}/pdfs"
RESUME_DIR="${ROOT_DIR}/resume"
PAGES_DIR="${ROOT_DIR}/pages"

mkdir -p "${PDF_DIR}"

echo "======================================================"
echo "  Compiling Resumes for Ian Thomas White Website"
echo "======================================================"

# 1. Compile 1-Page LaTeX Resume
if [ -f "${RESUME_DIR}/resume-onepage.tex" ]; then
    echo "[1/2] Compiling 1-Page LaTeX Resume (resume/resume-onepage.tex)..."
    pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" "${RESUME_DIR}/resume-onepage.tex" > /dev/null
    echo "  -> Successfully generated ${PDF_DIR}/resume-onepage.pdf"
fi

# 2. Compile Full Resume PDF DIRECTLY from Markdown (pages/resume.md)
if [ -f "${PAGES_DIR}/resume.md" ]; then
    if command -v pandoc >/dev/null 2>&1; then
        echo "[2/2] Generating Full Resume PDF directly from Markdown (pages/resume.md)..."
        pandoc -s "${PAGES_DIR}/resume.md" \
               -o "${PDF_DIR}/resume-full.pdf" \
               --pdf-engine=pdflatex \
               -V geometry:margin=0.75in \
               -V colorlinks=true \
               -V linkcolor=black \
               -V urlcolor=black
        echo "  -> Successfully generated ${PDF_DIR}/resume-full.pdf"
    else
        echo "[2/2] Note: Pandoc is not installed locally. GitHub Actions will generate"
        echo "      pdfs/resume-full.pdf directly from pages/resume.md automatically upon push."
    fi
fi

# Clean up any LaTeX auxiliary artifacts
rm -f "${PDF_DIR}"/*.aux "${PDF_DIR}"/*.log "${PDF_DIR}"/*.out

echo "======================================================"
echo "  Done. Resumes placed in ${PDF_DIR}/"
echo "======================================================"
