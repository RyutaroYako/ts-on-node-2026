/** @jsxRuntime classic */
/** @jsx h */
const h = (tag: string, _props: unknown, ...children: string[]) =>
  `<${tag}>${children.join("")}</${tag}>`;
console.log(<div>hello</div>);

declare global {
  namespace JSX {
    interface IntrinsicElements {
      [tag: string]: unknown;
    }
  }
}
export {};
