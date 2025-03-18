import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';

export default defineConfig({
  plugins: [
    RubyPlugin(),
  ],
  resolve: {
    alias: {
      '@': '/app/javascript',
    },
  },
  build: {
    outDir: 'public/vite',
    assetsDir: '',
    rollupOptions: {
      external: [], // List external dependencies here if needed, e.g. '@rails/ujs'
      output: {
        // Sometimes you may want to specify external for specific output formats
      },
    },
    commonjsOptions: {
      include: /node_modules/, // Ensure CommonJS modules are properly handled
    },
  },
  server: {
    host: 'localhost',
    port: 3000,
  },
});
