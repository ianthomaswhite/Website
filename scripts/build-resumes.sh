#!/usr/bin/env bash
# ==============================================================================
# Script: build-resumes.sh
# Purpose: Compiles resumes and all academic/creative papers into the pdfs/ tree.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

PDF_DIR="${ROOT_DIR}/pdfs"
RESUME_DIR="${ROOT_DIR}/resume"
PAPERS_DIR="${ROOT_DIR}/papers"

mkdir -p "${PDF_DIR}"

echo "======================================================"
echo "  Compiling Resumes & Papers for Website"
echo "======================================================"

# ------------------------------------------------------------------------------
# 1. Compile Resumes
# ------------------------------------------------------------------------------
if [ -f "${RESUME_DIR}/resume-onepage.tex" ]; then
    echo "[*] Compiling 1-Page Resume..."
    pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" "${RESUME_DIR}/resume-onepage.tex" > /dev/null 2>&1 || true
    echo "  -> ${PDF_DIR}/resume-onepage.pdf"
fi

if [ -f "${RESUME_DIR}/cv-full.tex" ]; then
    echo "[*] Compiling Full CV..."
    pdflatex -interaction=nonstopmode -output-directory="${PDF_DIR}" "${RESUME_DIR}/cv-full.tex" > /dev/null 2>&1 || true
    echo "  -> ${PDF_DIR}/cv-full.pdf"
fi

# ------------------------------------------------------------------------------
# 2. Compile Papers from papers/
# ------------------------------------------------------------------------------
if [ -d "${PAPERS_DIR}" ]; then
    # Compile LaTeX files
    find "${PAPERS_DIR}" -name "*.tex" | sort | while read -r tex_file; do
        rel_path="${tex_file#${PAPERS_DIR}/}"
        sub_dir="$(dirname "${rel_path}")"
        dest_dir="${PDF_DIR}/${sub_dir}"
        mkdir -p "${dest_dir}"
        tex_filename="$(basename "${tex_file}")"
        echo "[*] Compiling paper: ${rel_path}..."
        (cd "$(dirname "${tex_file}")" && pdflatex -interaction=nonstopmode -output-directory="${dest_dir}" "${tex_filename}" > /dev/null 2>&1) || true
        base_name="${tex_filename%.tex}"
        if [ -f "${dest_dir}/${base_name}.pdf" ]; then
            echo "  -> ${dest_dir}/${base_name}.pdf"
        fi
    done

    # Copy pre-existing PDFs
    find "${PAPERS_DIR}" -name "*.pdf" | sort | while read -r pdf_file; do
        rel_path="${pdf_file#${PAPERS_DIR}/}"
        sub_dir="$(dirname "${rel_path}")"
        dest_dir="${PDF_DIR}/${sub_dir}"
        mkdir -p "${dest_dir}"
        echo "[*] Copying PDF: ${rel_path}..."
        cp -u "${pdf_file}" "${dest_dir}/"
        echo "  -> ${dest_dir}/$(basename "${pdf_file}")"
    done
fi

# ------------------------------------------------------------------------------
# 3. Clean LaTeX Auxiliary Build Artifacts Across All pdfs Subdirectories
# ------------------------------------------------------------------------------
find "${PDF_DIR}" -type f ! -name "*.pdf" -delete

echo "======================================================"
echo "  Done. All PDFs placed in ${PDF_DIR}/"
echo "======================================================"
