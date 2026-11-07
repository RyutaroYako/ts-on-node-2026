interface Config {
  name: string;
  retries: number;
}

type Handler = (config: Config) => void;

const handler: Handler = (config) => {
  throw new Error(`boom: ${config.name}`);
};

handler({ name: "x", retries: 3 });
