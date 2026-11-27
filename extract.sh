#!/bin/sh
set -u
IN="${1:-/tmp/probe.log}"
OUT="${2:-/tmp/probe_sections.txt}"
if [ ! -f "$IN" ]; then
  echo "usage: sh extract_probe.sh <raw log> [out]"
  exit 2
fi
awk '
  /^== \[/ { inseg=1; print; next }
  inseg && /^  / { print; next }
  { inseg=0 }
' "$IN" > "$OUT"
n=$(wc -l < "$OUT")
s=$(wc -c < "$OUT")
echo "sections: $OUT  ($n lines, $s bytes)"
grep -c "^== \[" "$OUT" | sed 's/^/blocks: /'
grep -o "^== \[[0-9]\+\]" "$OUT" | sort -u | tr '\n' ' '
echo
