#!/usr/bin/env bash
# ==============================================================================
# Script: sync.sh
# Purpose: Pulls allowed files from private local repositories into the Website
#          repository according to sync-manifest.conf.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
MANIFEST_FILE="${ROOT_DIR}/sync-manifest.conf"

if [ ! -f "${MANIFEST_FILE}" ]; then
    echo "Error: Manifest file '${MANIFEST_FILE}' not found."
    exit 1
fi

echo "======================================================"
echo "  Syncing Private Repositories &rarr; Website"
echo "======================================================"

ACTIVE_COUNT=0
UPDATED_COUNT=0

# Process manifest line by line.
# Format per line: <source_path> -> <destination_relative_to_repo>
while IFS= read -r line || [ -n "$line" ]; do
    # Strip leading and trailing whitespace characters
    trimmed="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

    # Ignore blank lines and comment lines starting with '#'
    if [[ -z "$trimmed" || "$trimmed" =~ ^# ]]; then
        continue
    fi

    # Parse lines matching pattern: 'SOURCE -> DESTINATION'
    if [[ "$trimmed" =~ (.*)[[:space:]]*-\>[[:space:]]*(.*) ]]; then
        SRC_RAW="${BASH_REMATCH[1]}"
        DEST_RAW="${BASH_REMATCH[2]}"

        # Trim extra whitespace surrounding the extracted source and destination tokens
        SRC_RAW="$(echo "$SRC_RAW" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        DEST_RAW="$(echo "$DEST_RAW" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

        # Safely expand leading tilde (~) to the user's home directory ($HOME)
        SRC="${SRC_RAW/#\~/$HOME}"
        # Destination is always anchored relative to the website repository root
        DEST="${ROOT_DIR}/${DEST_RAW}"

        ((ACTIVE_COUNT += 1))

        if [ ! -f "$SRC" ]; then
            echo "[!] Source file missing: ${SRC_RAW}"
            continue
        fi

        # Ensure target directory exists
        mkdir -p "$(dirname "$DEST")"

        # Compare files: only copy if different
        if [ ! -f "$DEST" ] || ! cmp -s "$SRC" "$DEST"; then
            cp "$SRC" "$DEST"
            echo "  [+] Updated: ${DEST_RAW} <- ${SRC_RAW}"
            ((UPDATED_COUNT += 1))
        else
            echo "  [=] Up to date: ${DEST_RAW}"
        fi
    fi
done < "${MANIFEST_FILE}"

echo "------------------------------------------------------"
if [ "$ACTIVE_COUNT" -eq 0 ]; then
    echo "Manifest is currently empty."
    echo "To map files, add lines to 'sync-manifest.conf':"
    echo "  ~/path/to/private-file.tex -> destination/path.tex"
else
    echo "Sync finished. Checked ${ACTIVE_COUNT} file(s), updated ${UPDATED_COUNT} file(s)."
    if [ "$UPDATED_COUNT" -gt 0 ]; then
        echo "Rebuilding PDFs..."
        "${SCRIPT_DIR}/build-resumes.sh"
    fi
fi
echo "======================================================"
