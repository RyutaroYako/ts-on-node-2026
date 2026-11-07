#!/usr/bin/env bash
# cases/syntax の各ケースを各ツールで実行し、結果を Markdown 表で results/syntax.md に出力する
set -u
cd "$(dirname "$0")/.."
ROOT="$PWD"
export PATH="$ROOT/node_modules/.bin:$PATH"
export NODE_NO_WARNINGS=1

declare -A RUNNERS=(
  [node]="node"
  [tsx]="tsx"
  [ts-node]="ts-node --esm"
  [ts-node-cjs]="ts-node"
  [vite-node]="vite-node"
  [oxnode]="oxnode"
)
ORDER=(node tsx ts-node ts-node-cjs vite-node oxnode)
CASES=(
  cases/syntax/[0-9]*.ts
  cases/syntax/[0-9]*.tsx
  cases/syntax/legacy-decorator/main.ts
  cases/syntax/cjs/main.cts
  cases/syntax/cjs/esm-in-cjs.ts
)

# ts-node は CJS モードと ESM モードで結果が変わるため、"type": "commonjs" の複製ディレクトリでも実行する
CJS_DIR=.ts-node-cjs
rm -rf "$CJS_DIR" && mkdir -p "$CJS_DIR"
cp -r cases "$CJS_DIR/"
cp tsconfig.json "$CJS_DIR/"
echo '{ "type": "commonjs" }' > "$CJS_DIR/package.json"

run() {
  local runner="$1" file="$2"
  [ "$runner" = ts-node-cjs ] && file="$CJS_DIR/$file"
  timeout 30 ${RUNNERS[$runner]} "$file" 2>&1
}

header() {
  printf '| %s |' "$1"; for r in "${ORDER[@]}"; do printf ' %s |' "$r"; done; echo
  printf '|---|'; for _ in "${ORDER[@]}"; do printf -- '---|'; done; echo
}

{
  echo "## 構文対応"
  echo
  header case
  for c in "${CASES[@]}"; do
    printf '| %s |' "$c"
    for r in "${ORDER[@]}"; do
      out=$(run "$r" "$c")
      code=$?
      out=${out//$ROOT\//}
      if [ $code -eq 0 ]; then
        cell="OK: $(echo "$out" | tail -1)"
      else
        cell="NG: $(echo "$out" | grep -m1 -oE '(ERR_[A-Z_]+|[A-Za-z]*Error[^|]{0,80}|TS[0-9]+[^|]{0,80})' || echo "$out" | head -1)"
      fi
      printf ' %s |' "$(echo "$cell" | tr '\n|' ' /' | cut -c1-110)"
    done
    echo
  done

  echo
  echo "## スタックトレースの行番号（期待値: stack-trace.ts:9）"
  echo
  header case
  printf '| %s |' cases/syntax/stack-trace.ts
  for r in "${ORDER[@]}"; do
    printf ' %s |' "$(run "$r" cases/syntax/stack-trace.ts | grep -m1 -oE 'stack-trace\.ts:[0-9]+:[0-9]+' || echo '-')"
  done
  echo
} | tee results/syntax.md
