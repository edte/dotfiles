#!/usr/bin/env bash
# Render a Mermaid diagram as terminal text to a temp file.
# Only `graph`/`flowchart` and `sequenceDiagram` are supported by mermaid-ascii.
#
# Usage:
#   ascii.sh <input.mmd>     # read from file
#   ascii.sh                 # read mermaid source from STDIN
#   echo '...' | ascii.sh
set -euo pipefail

BIN="$(command -v mermaid-ascii || true)"
[[ -z "$BIN" && -x "$HOME/go/bin/mermaid-ascii" ]] && BIN="$HOME/go/bin/mermaid-ascii"
[[ -n "$BIN" ]] || {
  echo "ascii.sh: mermaid-ascii missing. install patched fork: gh repo clone edte/mermaid-ascii /tmp/mermaid-ascii-edte && cd /tmp/mermaid-ascii-edte && go install ." >&2
  exit 3
}

if [[ $# -ge 1 && "$1" != "-" ]]; then
  INPUT="$1"
  [[ -f "$INPUT" ]] || { echo "ascii.sh: input not found: $INPUT" >&2; exit 2; }
else
  INPUT="$(mktemp -t mermaid-ascii-input).mmd"
  trap 'rm -f "$INPUT"' EXIT
  cat > "$INPUT"
  [[ -s "$INPUT" ]] || { echo "ascii.sh: empty stdin" >&2; exit 2; }
fi

first_kw="$(grep -m1 -oE '^[[:space:]]*(graph|flowchart|sequenceDiagram|classDiagram|stateDiagram|erDiagram|gantt|journey|pie|gitGraph|mindmap|timeline|quadrantChart)' "$INPUT" | tr -d '[:space:]' || true)"
case "$first_kw" in
  graph|flowchart|sequenceDiagram) ;;
  "") echo "ascii.sh: cannot detect diagram type" >&2; exit 4 ;;
  *)  echo "ascii.sh: diagram type '$first_kw' not supported by mermaid-ascii" >&2; exit 4 ;;
esac

OUTPUT="$(mktemp -t mermaid-ascii-out).txt"
ERR="$(mktemp -t mermaid-ascii-err).txt"
if ! "$BIN" --file "$INPUT" > "$OUTPUT" 2>"$ERR"; then
  reason="$(sed -n '1,3p' "$ERR" | tr '\n' ' ' | sed 's/[[:space:]]*$//')"
  [[ -n "$reason" ]] || reason="likely unsupported syntax"
  echo "ascii.sh: mermaid-ascii failed: $reason" >&2
  rm -f "$OUTPUT" "$ERR"
  exit 5
fi
rm -f "$ERR"
echo "$OUTPUT"
