import { basename } from "node:path";
const base: string = basename(import.meta.url);
console.log(base);
