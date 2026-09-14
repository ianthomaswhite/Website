#!/usr/bin/env bash
# ==============================================================================
# Script: preview.sh
# Purpose: Convenience launcher for the local preview server and site compiler.
#
# Description:
#   Runs the standalone Python preview generator (scripts/preview.py).
#   Compiles all Markdown pages, editorial templates, CSS, and static assets
#   into the `_site/` directory, then starts a local zero-cache HTTP server.
#
# Usage:
#   ./scripts/preview.sh              # Build and serve at http://localhost:8000
#   ./scripts/preview.sh --build-only # Only compile assets to _site/ without serving
#   ./scripts/preview.sh 8080         # Build and serve on custom port 8080
# ==============================================================================

# Exit immediately if a command exits with a non-zero status or undefined variables are accessed
set -euo pipefail

# Determine script directory dynamically regardless of current working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Launch the Python generator and pass through any command-line arguments ($@)
python3 "${SCRIPT_DIR}/preview.py" "$@"

