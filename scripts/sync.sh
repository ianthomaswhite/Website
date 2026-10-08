#!/usr/bin/env bash
# ==============================================================================
# Script: sync.sh
# Purpose: Pulls pre-compiled PDFs directly from private sample repositories
#          (academic, creative, professional) into the Website pdfs/ tree,
#          and compiles the local Full CV (resume/cv-full.tex).
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

PDF_DIR="${ROOT_DIR}/pdfs"
RESUME_DIR="${ROOT_DIR}/resume"

ACADEMIC_SRC="${HOME}/Records/documents/academic/samples"
CREATIVE_SRC="${HOME}/Records/documents/creative/samples"
PROF_SRC="${HOME}/Records/documents/professional/samples"

mkdir -p "${PDF_DIR}/academic/linguistics"
mkdir -p "${PDF_DIR}/academic/literature"
mkdir -p "${PDF_DIR}/academic/teaching"
mkdir -p "${PDF_DIR}/creative/film"
mkdir -p "${PDF_DIR}/creative/poetry"
mkdir -p "${PDF_DIR}/creative/other"

echo "======================================================"
echo "  Syncing Pre-Compiled PDFs -> Website"
echo "======================================================"

copy_pdf() {
    local src="$1"
    local dest="$2"

    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        if [ ! -f "$dest" ] || ! cmp -s "$src" "$dest"; then
            cp "$src" "$dest"
            echo "  [+] Updated: ${dest#${ROOT_DIR}/} <- $(basename "$src")"
        else
            echo "  [=] Up to date: ${dest#${ROOT_DIR}/}"
        fi
    else
        echo "  [!] Missing: $src"
    fi
}

# ------------------------------------------------------------------------------
# 1. Academic Samples
# ------------------------------------------------------------------------------
if [ -d "$ACADEMIC_SRC" ]; then
    echo "[*] Syncing Academic PDFs..."
    find "$ACADEMIC_SRC" -name "*.pdf" | sort | while read -r src_pdf; do
        rel="${src_pdf#${ACADEMIC_SRC}/}"
        category="$(echo "$rel" | cut -d'/' -f1)"
        fname="$(basename "$src_pdf")"
        dest_pdf="${PDF_DIR}/academic/${category}/${fname}"
        copy_pdf "$src_pdf" "$dest_pdf"
    done
else
    echo "[!] Academic samples folder not found: $ACADEMIC_SRC"
fi

# ------------------------------------------------------------------------------
# 2. Creative Samples
# ------------------------------------------------------------------------------
if [ -d "$CREATIVE_SRC" ]; then
    echo "[*] Syncing Creative PDFs..."
    find "$CREATIVE_SRC" -name "*.pdf" | sort | while read -r src_pdf; do
        rel="${src_pdf#${CREATIVE_SRC}/}"
        category="$(echo "$rel" | cut -d'/' -f1)"
        fname="$(basename "$src_pdf")"
        dest_pdf="${PDF_DIR}/creative/${category}/${fname}"
        copy_pdf "$src_pdf" "$dest_pdf"
    done
else
    echo "[!] Creative samples folder not found: $CREATIVE_SRC"
fi

# ------------------------------------------------------------------------------
# 3. Professional Samples (1-Page Resume)
# ------------------------------------------------------------------------------
if [ -d "$PROF_SRC" ]; then
    echo "[*] Syncing Professional PDFs..."
    find "$PROF_SRC" -name "*.pdf" | sort | while read -r src_pdf; do
        dest_pdf="${PDF_DIR}/resume-onepage.pdf"
        copy_pdf "$src_pdf" "$dest_pdf"
    done
else
    echo "[!] Professional samples folder not found: $PROF_SRC"
fi

# ------------------------------------------------------------------------------
# 4. Compile Full CV from Website Repo (resume/cv-full.tex)
# ------------------------------------------------------------------------------
if [ -f "${RESUME_DIR}/cv-full.tex" ]; then
    echo "[*] Compiling Full CV (website repo)..."
    (cd "${RESUME_DIR}" && pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" cv-full.tex > /dev/null 2>&1) || true
    (cd "${RESUME_DIR}" && pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" cv-full.tex > /dev/null 2>&1) || true
    echo "  -> ${PDF_DIR}/cv-full.pdf"
fi

# Clean any non-PDF auxiliary artifacts in pdfs/
find "${PDF_DIR}" -type f ! -name "*.pdf" -delete

echo "======================================================"
echo "  Done. PDFs updated directly from private repositories."
echo "======================================================"
