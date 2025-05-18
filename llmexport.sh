#!/bin/bash
[ -e llmexport.txt ] && rm llmexport.txt
find . -name "*.swift" | while read -r file; do
  echo "=== File: $file ==="
  cat "$file"
  echo ""
done > llmexport.txt