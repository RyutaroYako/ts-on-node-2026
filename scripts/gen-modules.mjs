// 大量モジュールの読み込みコストを測るため、型注釈付きの .ts を N 個生成する
import { mkdirSync, rmSync, writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

const N = Number(process.argv[2] ?? 500);
const dir = fileURLToPath(new URL("../cases/perf/many", import.meta.url));
rmSync(dir, { recursive: true, force: true });
mkdirSync(`${dir}/mods`, { recursive: true });

for (let i = 0; i < N; i++) {
  writeFileSync(
    `${dir}/mods/m${i}.ts`,
    `export interface Item${i} {
  id: number;
  label: string;
  tags: readonly string[];
}

export type Mapper${i} = (item: Item${i}) => string;

export function make${i}(id: number): Item${i} {
  return { id, label: \`item-\${id}\`, tags: ["a", "b"] as const };
}

export const map${i}: Mapper${i} = (item) => item.label.toUpperCase();
`,
  );
}

const imports = Array.from(
  { length: N },
  (_, i) => `import { make${i}, map${i} } from "./mods/m${i}.ts";`,
).join("\n");
const calls = Array.from({ length: N }, (_, i) => `map${i}(make${i}(${i}))`).join(",\n  ");
writeFileSync(
  `${dir}/main.ts`,
  `${imports}\n\nconst results: string[] = [\n  ${calls},\n];\nconsole.log(results.length);\n`,
);
