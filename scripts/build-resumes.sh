#!/usr/bin/env bash
# ==============================================================================
# Script: build-resumes.sh
# Purpose: Compiles local LaTeX documents (Full CV) into the pdfs/ tree.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

PDF_DIR="${ROOT_DIR}/pdfs"
RESUME_DIR="${ROOT_DIR}/resume"

mkdir -p "${PDF_DIR}"

echo "======================================================"
echo "  Compiling CV for Website"
echo "======================================================"

# ------------------------------------------------------------------------------
# 1. Compile Full CV from resume/cv-full.tex
# ------------------------------------------------------------------------------
if [ -f "${RESUME_DIR}/cv-full.tex" ]; then
    echo "[*] Compiling Full CV..."
    pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" "${RESUME_DIR}/cv-full.tex" > /dev/null 2>&1 || true
    pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" "${RESUME_DIR}/cv-full.tex" > /dev/null 2>&1 || true
    echo "  -> ${PDF_DIR}/cv-full.pdf"
fi

# ------------------------------------------------------------------------------
# 2. Clean LaTeX Auxiliary Build Artifacts Across All pdfs Subdirectories
# ------------------------------------------------------------------------------
find "${PDF_DIR}" -type f ! -name "*.pdf" -delete

echo "======================================================"
echo "  Done. Full CV compiled; all PDFs in ${PDF_DIR}/"
echo "======================================================"
