#!/usr/bin/env bash
# cases/perf のファイルで起動時間を hyperfine で計測し、results/perf に出力する
#   hello: 1 ファイルの hello.ts（ツール自体の起動コスト）
#   many:  500 モジュールを import する many/main.ts（変換コスト）
set -eu
cd "$(dirname "$0")/.."
BIN=node_modules/.bin
export NODE_NO_WARNINGS=1
RUNS="${RUNS:-50}"
OUT="${OUT:-results/perf}"
DIR=cases/perf
mkdir -p "$OUT"

node scripts/gen-modules.mjs 500

# ts-node の CJS モードは "type": "commonjs" の場所で動かす必要があるため複製する
CJS_DIR=.ts-node-cjs
rm -rf "$CJS_DIR" && mkdir -p "$CJS_DIR"
cp -r cases "$CJS_DIR/"
cp tsconfig.json "$CJS_DIR/"
echo '{ "type": "commonjs" }' > "$CJS_DIR/package.json"

run() {
  local name="$1" entry="$2"
  hyperfine \
    --warmup 5 \
    --runs "$RUNS" \
    --export-markdown "$OUT/$name.md" \
    --export-json "$OUT/$name.json" \
    -n "node (type stripping)" "node $entry" \
    -n "tsx" "$BIN/tsx $entry" \
    -n "ts-node (typecheck)" "$BIN/ts-node $CJS_DIR/$entry" \
    -n "ts-node (transpileOnly)" "$BIN/ts-node --transpileOnly $CJS_DIR/$entry" \
    -n "ts-node (swc)" "$BIN/ts-node --swc $CJS_DIR/$entry" \
    -n "vite-node" "$BIN/vite-node $entry" \
    -n "oxc-node (--import)" "node --import @oxc-node/core/register $entry" \
    -n "oxnode (CLI)" "$BIN/oxnode $entry"
}

hyperfine --warmup 5 --runs "$RUNS" --export-markdown "$OUT/baseline.md" \
  -n "node hello.js" "node $DIR/hello.js"
run hello "$DIR/hello.ts"
run many "$DIR/many/main.ts"

# tsx は変換結果をディスクにキャッシュするため、キャッシュ無効時も計測する
hyperfine --warmup 3 --runs "${CACHE_RUNS:-30}" --export-markdown "$OUT/tsx-cache.md" \
  -n "tsx (cache)" "$BIN/tsx $DIR/many/main.ts" \
  -n "tsx --no-cache" "$BIN/tsx --no-cache $DIR/many/main.ts" \
  -n "tsx --no-cache (hello)" "$BIN/tsx --no-cache $DIR/hello.ts"
