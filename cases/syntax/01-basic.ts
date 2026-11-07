type Point = { x: number; y: number };
const p: Point = { x: 1, y: 2 };
function add(a: number, b: number): number {
  return a + b;
}
console.log(add(p.x, p.y) satisfies number);
