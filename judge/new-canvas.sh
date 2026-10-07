#!/usr/bin/env bash
# HLD Dojo — (re)generate a blank Excalidraw starter canvas for a question.
# Usage: ./judge/new-canvas.sh <question-folder-name> "<Title>" ["<subtitle hint>"]
# Example:
#   ./judge/new-canvas.sh 01-url-shortener "Q01 · URL Shortener" "Design TinyURL"
#
# Writes questions/<folder>/canvas.excalidraw pre-seeded with a title + 4 labelled
# lanes (Clients · Edge/API · Services · Data) so you have somewhere to start drawing.
# WARNING: this overwrites an existing canvas.excalidraw for that question.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
folder="${1:-}"
title="${2:-}"
subtitle="${3:-Draw your high-level architecture below. Add text notes for trade-offs.}"

if [[ -z "$folder" || -z "$title" ]]; then
  echo "Usage: ./judge/new-canvas.sh <question-folder-name> \"<Title>\" [\"<subtitle>\"]"
  exit 1
fi

dir="$ROOT/questions/$folder"
mkdir -p "$dir"
out="$dir/canvas.excalidraw"

# JSON-escape the dynamic strings (quotes/backslashes).
esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
etitle="$(esc "$title")"
esub="$(esc "$subtitle")"

cat > "$out" <<JSON
{
  "type": "excalidraw",
  "version": 2,
  "source": "hld-dojo",
  "elements": [
    { "type": "text", "version": 1, "versionNonce": 1, "isDeleted": false,
      "id": "title", "fillStyle": "solid", "strokeWidth": 1, "strokeStyle": "solid",
      "roughness": 1, "opacity": 100, "angle": 0, "x": 40, "y": 24, "strokeColor": "#1e1e1e",
      "backgroundColor": "transparent", "width": 900, "height": 36, "seed": 1, "groupIds": [],
      "frameId": null, "roundness": null, "boundElements": [], "updated": 1, "link": null,
      "locked": false, "fontSize": 28, "fontFamily": 1, "text": "$etitle",
      "textAlign": "left", "verticalAlign": "top", "baseline": 28, "containerId": null,
      "originalText": "$etitle", "lineHeight": 1.25 },
    { "type": "text", "version": 1, "versionNonce": 2, "isDeleted": false,
      "id": "subtitle", "fillStyle": "solid", "strokeWidth": 1, "strokeStyle": "solid",
      "roughness": 1, "opacity": 100, "angle": 0, "x": 40, "y": 66, "strokeColor": "#868e96",
      "backgroundColor": "transparent", "width": 1000, "height": 20, "seed": 2, "groupIds": [],
      "frameId": null, "roundness": null, "boundElements": [], "updated": 1, "link": null,
      "locked": false, "fontSize": 16, "fontFamily": 1, "text": "$esub",
      "textAlign": "left", "verticalAlign": "top", "baseline": 16, "containerId": null,
      "originalText": "$esub", "lineHeight": 1.25 },
    { "type": "rectangle", "version": 1, "versionNonce": 3, "isDeleted": false,
      "id": "lane1", "fillStyle": "hachure", "strokeWidth": 1, "strokeStyle": "dashed",
      "roughness": 1, "opacity": 60, "angle": 0, "x": 40, "y": 120, "strokeColor": "#4263eb",
      "backgroundColor": "transparent", "width": 220, "height": 520, "seed": 3, "groupIds": [],
      "frameId": null, "roundness": { "type": 3 }, "boundElements": [], "updated": 1,
      "link": null, "locked": false },
    { "type": "text", "version": 1, "versionNonce": 4, "isDeleted": false, "id": "lane1t",
      "fillStyle": "solid", "strokeWidth": 1, "strokeStyle": "solid", "roughness": 1,
      "opacity": 100, "angle": 0, "x": 56, "y": 128, "strokeColor": "#4263eb",
      "backgroundColor": "transparent", "width": 180, "height": 20, "seed": 4, "groupIds": [],
      "frameId": null, "roundness": null, "boundElements": [], "updated": 1, "link": null,
      "locked": false, "fontSize": 16, "fontFamily": 1, "text": "Clients", "textAlign": "left",
      "verticalAlign": "top", "baseline": 16, "containerId": null, "originalText": "Clients",
      "lineHeight": 1.25 },
    { "type": "rectangle", "version": 1, "versionNonce": 5, "isDeleted": false,
      "id": "lane2", "fillStyle": "hachure", "strokeWidth": 1, "strokeStyle": "dashed",
      "roughness": 1, "opacity": 60, "angle": 0, "x": 280, "y": 120, "strokeColor": "#0ca678",
      "backgroundColor": "transparent", "width": 240, "height": 520, "seed": 5, "groupIds": [],
      "frameId": null, "roundness": { "type": 3 }, "boundElements": [], "updated": 1,
      "link": null, "locked": false },
    { "type": "text", "version": 1, "versionNonce": 6, "isDeleted": false, "id": "lane2t",
      "fillStyle": "solid", "strokeWidth": 1, "strokeStyle": "solid", "roughness": 1,
      "opacity": 100, "angle": 0, "x": 296, "y": 128, "strokeColor": "#0ca678",
      "backgroundColor": "transparent", "width": 200, "height": 20, "seed": 6, "groupIds": [],
      "frameId": null, "roundness": null, "boundElements": [], "updated": 1, "link": null,
      "locked": false, "fontSize": 16, "fontFamily": 1, "text": "Edge / API / LB",
      "textAlign": "left", "verticalAlign": "top", "baseline": 16, "containerId": null,
      "originalText": "Edge / API / LB", "lineHeight": 1.25 },
    { "type": "rectangle", "version": 1, "versionNonce": 7, "isDeleted": false,
      "id": "lane3", "fillStyle": "hachure", "strokeWidth": 1, "strokeStyle": "dashed",
      "roughness": 1, "opacity": 60, "angle": 0, "x": 540, "y": 120, "strokeColor": "#f08c00",
      "backgroundColor": "transparent", "width": 300, "height": 520, "seed": 7, "groupIds": [],
      "frameId": null, "roundness": { "type": 3 }, "boundElements": [], "updated": 1,
      "link": null, "locked": false },
    { "type": "text", "version": 1, "versionNonce": 8, "isDeleted": false, "id": "lane3t",
      "fillStyle": "solid", "strokeWidth": 1, "strokeStyle": "solid", "roughness": 1,
      "opacity": 100, "angle": 0, "x": 556, "y": 128, "strokeColor": "#f08c00",
      "backgroundColor": "transparent", "width": 260, "height": 20, "seed": 8, "groupIds": [],
      "frameId": null, "roundness": null, "boundElements": [], "updated": 1, "link": null,
      "locked": false, "fontSize": 16, "fontFamily": 1, "text": "Services / Workers",
      "textAlign": "left", "verticalAlign": "top", "baseline": 16, "containerId": null,
      "originalText": "Services / Workers", "lineHeight": 1.25 },
    { "type": "rectangle", "version": 1, "versionNonce": 9, "isDeleted": false,
      "id": "lane4", "fillStyle": "hachure", "strokeWidth": 1, "strokeStyle": "dashed",
      "roughness": 1, "opacity": 60, "angle": 0, "x": 860, "y": 120, "strokeColor": "#e03131",
      "backgroundColor": "transparent", "width": 300, "height": 520, "seed": 9, "groupIds": [],
      "frameId": null, "roundness": { "type": 3 }, "boundElements": [], "updated": 1,
      "link": null, "locked": false },
    { "type": "text", "version": 1, "versionNonce": 10, "isDeleted": false, "id": "lane4t",
      "fillStyle": "solid", "strokeWidth": 1, "strokeStyle": "solid", "roughness": 1,
      "opacity": 100, "angle": 0, "x": 876, "y": 128, "strokeColor": "#e03131",
      "backgroundColor": "transparent", "width": 260, "height": 20, "seed": 10, "groupIds": [],
      "frameId": null, "roundness": null, "boundElements": [], "updated": 1, "link": null,
      "locked": false, "fontSize": 16, "fontFamily": 1, "text": "Data stores / Cache / Queue",
      "textAlign": "left", "verticalAlign": "top", "baseline": 16, "containerId": null,
      "originalText": "Data stores / Cache / Queue", "lineHeight": 1.25 }
  ],
  "appState": { "gridSize": 20, "viewBackgroundColor": "#ffffff" },
  "files": {}
}
JSON

echo "Wrote $out"
