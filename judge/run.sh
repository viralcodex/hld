#!/usr/bin/env bash
# HLD Dojo — open a question and its canvas.
# Usage: ./judge/run.sh <number>      e.g.  ./judge/run.sh 1
#
# This dojo is graded by a human/AI reading your diagram, not by a script.
# So this helper just: prints the prompt, and opens the Excalidraw canvas for you.
# When you're done drawing, save over canvas.excalidraw and ask Copilot:
#     "Judge my design for Q<number>"

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
QDIR="$ROOT/questions"

arg="${1:-}"
if [[ -z "$arg" ]]; then
  echo "Usage: ./judge/run.sh <number>   (e.g. ./judge/run.sh 1)"
  echo
  echo "Available questions:"
  for d in "$QDIR"/*/; do
    name="$(basename "$d")"
    printf '  %s\n' "$name"
  done
  exit 1
fi

# Resolve the folder: match a leading zero-padded number (01-, 02- ... 16-).
num="$arg"
pad="$(printf '%02d' "$((10#${num}))" 2>/dev/null || echo "$num")"
folder=""
for d in "$QDIR"/"${pad}"-*/; do
  [[ -d "$d" ]] && folder="$d" && break
done

if [[ -z "$folder" ]]; then
  echo "No question matches '$arg'. Try one of:"
  for d in "$QDIR"/*/; do printf '  %s\n' "$(basename "$d")"; done
  exit 1
fi

name="$(basename "$folder")"
prompt="$folder/PROMPT.md"
canvas="$folder/canvas.excalidraw"

echo "=============================================================="
echo " HLD DOJO  $name"
echo "=============================================================="
if [[ -f "$folder/meta.txt" ]]; then
  sed 's/^/  /' "$folder/meta.txt"
  echo "--------------------------------------------------------------"
fi
echo "  Prompt : $prompt"
echo "  Canvas : $canvas"
echo "--------------------------------------------------------------"
echo "  1. Read the prompt (opening it now)."
echo "  2. Draw your architecture in the canvas (opening it now)."
echo "     - Browser: drag canvas.excalidraw onto https://excalidraw.com"
echo "     - VS Code: install 'pomdtr.excalidraw-editor' to edit it inline"
echo "  3. Save over canvas.excalidraw, then tell Copilot:"
echo "       \"Judge my design for Q${pad}\""
echo "=============================================================="

# Best-effort open on macOS/Linux; harmless if it fails (e.g. headless).
opener=""
if command -v code >/dev/null 2>&1; then opener="code";
elif command -v open >/dev/null 2>&1; then opener="open";
elif command -v xdg-open >/dev/null 2>&1; then opener="xdg-open"; fi

if [[ -n "$opener" ]]; then
  if [[ "$opener" == "code" ]]; then
    "$opener" "$prompt" "$canvas" >/dev/null 2>&1 || true
  else
    "$opener" "$prompt" >/dev/null 2>&1 || true
    "$opener" "$canvas" >/dev/null 2>&1 || true
  fi
else
  echo "(No opener found — open the two files above manually.)"
fi
