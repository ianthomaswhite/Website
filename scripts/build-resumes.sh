#!/usr/bin/env bash
# ==============================================================================
# Script: build-resumes.sh
# Purpose: Compiles the 1-page LaTeX resume and generates the full resume PDF
#          directly from pages/background.md (or pages/resume.md) using Pandoc.
#
# Workflow:
#   1. Compiles resume/resume-onepage.tex via pdflatex into pdfs/resume-onepage.pdf.
#   2. Converts the background/resume Markdown source into pdfs/resume-full.pdf
#      using Pandoc with standalone LaTeX styling and geometry rules.
#   3. Cleans up auxiliary LaTeX files (.aux, .log, .out) from the pdfs directory.
#
# Dependencies:
#   - pdflatex (TeX Live / MacTeX)
#   - pandoc (for Markdown-to-PDF conversion)
# ==============================================================================

# Halt script on any command failure, unset variable expansion, or pipeline error
set -euo pipefail

# Resolve paths relative to script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

PDF_DIR="${ROOT_DIR}/pdfs"
RESUME_DIR="${ROOT_DIR}/resume"
PAGES_DIR="${ROOT_DIR}/pages"

# Ensure the destination pdfs directory exists
mkdir -p "${PDF_DIR}"

echo "======================================================"
echo "  Compiling Resumes for Ian Thomas White Website"
echo "======================================================"

# ------------------------------------------------------------------------------
# 1. Compile 1-Page LaTeX Resume
# ------------------------------------------------------------------------------
# pdflatex runs in nonstopmode so it doesn't hang on interactive prompts;
# output is redirected directly to the pdfs/ folder.
if [ -f "${RESUME_DIR}/resume-onepage.tex" ]; then
    echo "[1/2] Compiling 1-Page LaTeX Resume (resume/resume-onepage.tex)..."
    pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" "${RESUME_DIR}/resume-onepage.tex" > /dev/null
    echo "  -> Successfully generated ${PDF_DIR}/resume-onepage.pdf"
fi

# ------------------------------------------------------------------------------
# 2. Compile Full Resume PDF directly from Markdown (background.md / resume.md)
# ------------------------------------------------------------------------------
# Check for pages/background.md first (the current page name), falling back to pages/resume.md.
SOURCE_MD=""
if [ -f "${PAGES_DIR}/background.md" ]; then
    SOURCE_MD="${PAGES_DIR}/background.md"
elif [ -f "${PAGES_DIR}/resume.md" ]; then
    SOURCE_MD="${PAGES_DIR}/resume.md"
fi

if [ -n "${SOURCE_MD}" ]; then
    if command -v pandoc >/dev/null 2>&1; then
        echo "[2/2] Generating Full Resume PDF directly from Markdown (${SOURCE_MD})..."
        # -s: standalone document with full headers/preamble
        # --pdf-engine=pdflatex: renders via pdflatex
        # -V options: sets clean typography, margins, and black link colors
        pandoc -s "${SOURCE_MD}" \
               -o "${PDF_DIR}/resume-full.pdf" \
               --pdf-engine=pdflatex \
               -V geometry:margin=0.75in \
               -V colorlinks=true \
               -V linkcolor=black \
               -V urlcolor=black
        echo "  -> Successfully generated ${PDF_DIR}/resume-full.pdf"
    else
        echo "[2/2] Note: Pandoc is not installed locally. GitHub Actions will generate"
        echo "      pdfs/resume-full.pdf directly from ${SOURCE_MD} automatically upon push."
    fi
fi

# ------------------------------------------------------------------------------
# 3. Housekeeping: Remove LaTeX Auxiliary Build Artifacts
# ------------------------------------------------------------------------------
# Removes temporary .aux, .log, and .out files to keep the pdfs/ folder clean.
rm -f "${PDF_DIR}"/*.aux "${PDF_DIR}"/*.log "${PDF_DIR}"/*.out

echo "======================================================"
echo "  Done. Resumes placed in ${PDF_DIR}/"
echo "======================================================"
