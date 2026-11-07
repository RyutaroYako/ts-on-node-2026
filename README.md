# ts-on-node-2026

TypeScript を Node.js 上で実行する方法を、構文対応と起動速度で比較する検証コードです。

比較対象は次の 5 つです。

- Node.js 単体（type stripping）
- [tsx](https://tsx.is/)
- [ts-node](https://github.com/TypeStrong/ts-node)（CJS モードと ESM モード）
- [vite-node](https://github.com/antfu-collective/vite-node)
- [oxc-node](https://github.com/oxc-project/oxc-node)（`node --import @oxc-node/core/register` と `oxnode` CLI）

## 検証環境

`results/` の結果は、次の環境で取得したものです（2026-11-06）。

- OS / CPU: WSL2（Linux 6.18） / Intel Core i9-13900H（20 スレッド）
- Node.js: v26.13.0

| ツール | バージョン |
| --- | --- |
| tsx | 4.23.15 |
| ts-node | 10.9.2（typescript 6.0.3 / @swc/core 1.16.21） |
| vite-node | 6.0.0（vite 8.3.5） |
| @oxc-node/core / @oxc-node/cli | 1.0.1 |
| hyperfine | 1.21.0 |

ts-node は TypeScript 7 では起動しないため、TypeScript は 6.0.3 を使っています。

## 使い方

```sh
pnpm install
pnpm typecheck        # tsc --noEmit
pnpm syntax           # 構文対応を検証し、results/syntax.md に出力する
RUNS=50 pnpm perf     # 起動速度を計測し、results/perf/ に出力する（hyperfine が必要）
```

`pnpm perf` は、次の環境変数で動作を変えられます。

| 環境変数 | デフォルト | 内容 |
| --- | --- | --- |
| `RUNS` | `50` | 各コマンドの計測回数 |
| `CACHE_RUNS` | `30` | tsx のキャッシュ有無を比べる計測の回数 |
| `OUT` | `results/perf` | 結果の出力先 |

## 構成

```text
.
├── cases/                     各ツールに実行させるファイル
│   ├── syntax/                構文対応の検証
│   │   ├── 01-basic.ts 〜 10-tsx.tsx
│   │   ├── stack-trace.ts          スタックトレースの行番号の確認
│   │   ├── lib/                    各ケースから import するモジュール
│   │   ├── legacy-decorator/       experimentalDecorators を有効にした tsconfig を持つケース
│   │   ├── cjs/                    "type": "commonjs" のケース
│   │   └── vite.config.paths.ts    vite-node で paths を解決する設定
│   └── perf/                  起動速度の計測
│       ├── hello.ts / hello.js     1 ファイルだけのケース（hello.js は比較用）
│       └── many/                   500 モジュールのケース（scripts/gen-modules.mjs が生成）
├── scripts/
│   ├── syntax.sh
│   ├── perf.sh
│   └── gen-modules.mjs
└── results/
    ├── syntax.md
    └── perf/                  hyperfine の出力
```

ts-node は CJS モードと ESM モードで結果が変わるため、スクリプトの実行時に `"type": "commonjs"` の複製（`.ts-node-cjs/`）を作り、そこでも実行します。

vite-node はデフォルトでは tsconfig の `paths` を解決しません。`vite.config.paths.ts` を使うと解決できます。

```sh
npx vite-node -c cases/syntax/vite.config.paths.ts cases/syntax/07-paths.ts
```

## 注意

- どのツールも型チェックはしません（ts-node のデフォルト設定を除く）。
- `results/perf/` の数値は WSL2 上の計測で、最大で ±20% 程度のばらつきがあります。
