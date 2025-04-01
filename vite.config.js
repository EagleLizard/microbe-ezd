
import path from'path';
import { defineConfig, loadEnv } from 'vite';

const _config = defineConfig((config) => {
  return {
    build: {
      rollupOptions: {
        input: {
          app: './src/index.html',
        },
      },
    },
  };
});

export default _config;
