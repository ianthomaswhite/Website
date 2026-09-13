#!/usr/bin/env bash
# ==============================================================================
# Script: build-resumes.sh
# Purpose: Compiles the 1-page LaTeX resume and full resume to PDFs in pdfs/
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
else
    echo "  -> Warning: ${RESUME_DIR}/resume-onepage.tex not found."
fi

# 2. Compile Full Extended Resume
# First check if Pandoc is available to compile pages/resume.md directly; otherwise compile resume/resume-full.tex
if command -v pandoc >/dev/null 2>&1 && command -v pdflatex >/dev/null 2>&1; then
    echo "[2/2] Compiling Full Extended Resume via Pandoc + pdflatex (pages/resume.md)..."
    pandoc -s "${PAGES_DIR}/resume.md" \
           -o "${PDF_DIR}/resume-full.pdf" \
           --pdf-engine=pdflatex \
           -V geometry:margin=0.75in \
           -V colorlinks=true \
           -V linkcolor=black \
           -V urlcolor=black || {
        echo "  -> Pandoc compilation failed, falling back to resume/resume-full.tex..."
        pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" "${RESUME_DIR}/resume-full.tex" > /dev/null
    }
    echo "  -> Successfully generated ${PDF_DIR}/resume-full.pdf"
elif [ -f "${RESUME_DIR}/resume-full.tex" ]; then
    echo "[2/2] Compiling Full Extended Resume via pdflatex (resume/resume-full.tex)..."
    pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" "${RESUME_DIR}/resume-full.tex" > /dev/null
    echo "  -> Successfully generated ${PDF_DIR}/resume-full.pdf"
fi

# Cleanup LaTeX auxiliary files from pdfs directory
rm -f "${PDF_DIR}"/*.aux "${PDF_DIR}"/*.log "${PDF_DIR}"/*.out

echo "======================================================"
echo "  All resumes compiled cleanly into ${PDF_DIR}/"
echo "======================================================"
