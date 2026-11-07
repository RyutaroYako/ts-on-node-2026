## 構文対応

| case | node | tsx | ts-node | ts-node-cjs | vite-node | oxnode |
|---|---|---|---|---|---|---|
| cases/syntax/01-basic.ts | OK: 3  | OK: 3  | OK: 3  | OK: 3  | OK: 3  | OK: 3  |
| cases/syntax/02-enum.ts | NG: SyntaxError [ERR_UNSUPPORTED_TYPESCRIPT_SYNTAX]: TypeScript enum is not supported in strip-  | OK: 1  | NG: SyntaxError: TypeScript enum is not supported in strip-only mode  | OK: 1  | OK: 1  | OK: 1  |
| cases/syntax/03-namespace.ts | NG: SyntaxError [ERR_UNSUPPORTED_TYPESCRIPT_SYNTAX]: TypeScript namespace declaration is not su  | OK: 42  | NG: SyntaxError: TypeScript namespace declaration is not supported in strip-only mode  | OK: 42  | OK: 42  | OK: 42  |
| cases/syntax/04-param-props.ts | NG: SyntaxError [ERR_UNSUPPORTED_TYPESCRIPT_SYNTAX]: TypeScript parameter property is not suppo  | OK: alice  | NG: SyntaxError: TypeScript parameter property is not supported in strip-only mode  | OK: alice  | OK: alice  | OK: alice  |
| cases/syntax/05-decorator.ts | NG: SyntaxError: Invalid or unexpected token  | OK: 3  | NG: SyntaxError: Invalid or unexpected token  | NG: SyntaxError: Invalid or unexpected token  | NG: SyntaxError: Invalid or unexpected token  | NG: Error: Failed to transform file://cases/syntax/05-decorator.ts: decorators require `"  |
| cases/syntax/06-import-without-type.ts | NG: SyntaxError: The requested module './lib/types.ts' does not provide an export named 'User'  | OK: alice 1.0.0  | NG: SyntaxError: The requested module './lib/types.ts' does not provide an export named 'User'  | OK: alice 1.0.0  | OK: alice 1.0.0  | OK: alice 1.0.0  |
| cases/syntax/07-paths.ts | NG: ERR_MODULE_NOT_FOUND  | OK: hello, paths  | NG: Error [ERR_MODULE_NOT_FOUND]: Cannot find package '@/greet.ts' imported from cases/sy  | NG: Error: Cannot find module '@/greet.ts'  | NG: Error(`Cannot find ${isBareImport(id) ? "package" : "module"} '${id}'${importer ? ` i  | OK: hello, paths  |
| cases/syntax/08-js-extension.ts | NG: ERR_MODULE_NOT_FOUND  | OK: hello, js-ext  | NG: Error [ERR_MODULE_NOT_FOUND]: Cannot find module 'cases/syntax/lib/greet.js' imported  | NG: Error: Cannot find module './lib/greet.js'  | OK: hello, js-ext  | OK: hello, js-ext  |
| cases/syntax/09-extensionless.ts | NG: ERR_MODULE_NOT_FOUND  | OK: hello, extensionless  | NG: Error [ERR_MODULE_NOT_FOUND]: Cannot find module 'cases/syntax/lib/greet' imported fr  | OK: hello, extensionless  | OK: hello, extensionless  | OK: hello, extensionless  |
| cases/syntax/10-tsx.tsx | NG: ERR_UNKNOWN_FILE_EXTENSION  | OK: <div>hello</div>  | NG: TypeError [ERR_UNKNOWN_FILE_EXTENSION]: Unknown file extension ".tsx" for cases/syntax/10  | OK: <div>hello</div>  | OK: <div>hello</div>  | OK: <div>hello</div>  |
| cases/syntax/legacy-decorator/main.ts | NG: SyntaxError: Invalid or unexpected token  | OK: true []  | NG: SyntaxError: Invalid or unexpected token  | OK: true [ 'design:paramtypes=class Dep {\n}' ]  | OK: true [ 'design:paramtypes=class Dep {}' ]  | OK: true [ 'design:paramtypes=class Dep {}' ]  |
| cases/syntax/cjs/main.cts | OK: main.cts  | OK: main.cts  | OK: main.cts  | OK: main.cts  | NG: Error(base.message), base);  | OK: main.cts  |
| cases/syntax/cjs/esm-in-cjs.ts | NG: SyntaxError: Cannot use import statement outside a module  | OK: esm-in-cjs.ts  | NG: SyntaxError: Cannot use import statement outside a module  | NG: TSError(diagnosticText, diagnosticCodes, diagnostics);  | OK: esm-in-cjs.ts  | OK: esm-in-cjs.ts  |

## スタックトレースの行番号（期待値: stack-trace.ts:9）

| case | node | tsx | ts-node | ts-node-cjs | vite-node | oxnode |
|---|---|---|---|---|---|---|
| cases/syntax/stack-trace.ts | stack-trace.ts:9:9 | stack-trace.ts:9:9 | stack-trace.ts:9:9 | stack-trace.ts:9:9 | stack-trace.ts:9:9 | stack-trace.ts:9:9 |
