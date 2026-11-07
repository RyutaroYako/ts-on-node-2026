const metadata: string[] = [];
(Reflect as any).metadata = (key: string, value: unknown) => () => {
  metadata.push(`${key}=${String(value)}`);
};
function Injectable(): ClassDecorator {
  return () => {};
}
class Dep {}
@Injectable()
class Service {
  dep: Dep;
  constructor(dep: Dep) {
    this.dep = dep;
  }
}
console.log(new Service(new Dep()).dep instanceof Dep, metadata);
