function logged<T extends (...args: any[]) => any>(
  value: T,
  context: ClassMethodDecoratorContext,
) {
  return function (this: unknown, ...args: any[]) {
    console.log(`call ${String(context.name)}`);
    return value.apply(this, args);
  };
}
class Calc {
  @logged
  add(a: number, b: number) {
    return a + b;
  }
}
console.log(new Calc().add(1, 2));
