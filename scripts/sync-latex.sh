#!/usr/bin/env bash
# ==============================================================================
# Script: sync-latex.sh
# Purpose: Auto-sync selected LaTeX files from your external local repository
#          into this website repository.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ==============================================================================
# CONFIGURATION: Set the path to your local LaTeX repository here
# ==============================================================================
SOURCE_REPO="${SOURCE_REPO:-}"

if [ -z "${SOURCE_REPO}" ]; then
    echo "======================================================================"
    echo "  LaTeX Sync Helper"
    echo "======================================================================"
    echo "Please specify the path to your local LaTeX repository."
    echo ""
    echo "Usage: SOURCE_REPO=/path/to/your/repo ./scripts/sync-latex.sh"
    echo "Or edit 'scripts/sync-latex.sh' and set SOURCE_REPO permanently."
    echo "======================================================================"
    exit 1
fi

if [ ! -d "${SOURCE_REPO}" ]; then
    echo "Error: Directory '${SOURCE_REPO}' not found."
    exit 1
fi

echo "Syncing LaTeX files from: ${SOURCE_REPO}..."

# Example 1: Sync 1-Page Resume if it exists in the source repo
# (Adjust source filename if different in your other repo)
if [ -f "${SOURCE_REPO}/resume.tex" ]; then
    cp -u "${SOURCE_REPO}/resume.tex" "${ROOT_DIR}/resume/resume-onepage.tex"
    echo "  &check; Synced resume.tex -> resume/resume-onepage.tex"
elif [ -f "${SOURCE_REPO}/resume-onepage.tex" ]; then
    cp -u "${SOURCE_REPO}/resume-onepage.tex" "${ROOT_DIR}/resume/resume-onepage.tex"
    echo "  &check; Synced resume-onepage.tex -> resume/resume-onepage.tex"
fi

# Example 2: Sync papers (you can map specific files or folders)
# Example: cp -u "${SOURCE_REPO}/my-paper.tex" "${ROOT_DIR}/papers/my-paper.tex"

echo "Rebuilding PDFs..."
"${SCRIPT_DIR}/build-resumes.sh"

echo "Sync complete."
