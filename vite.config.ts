import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";
import { componentTagger } from "lovable-tagger";

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => ({
  server: {
    host: "::",
    port: 8080,
    hmr: {
      // Improve HMR stability
      protocol: 'ws',
      host: 'localhost',
      clientPort: 8080,
    },
    watch: {
      // Exclude node_modules and build directories from watching
      ignored: ['**/node_modules/**', '**/.git/**', '**/dist/**', '**/.next/**'],
      // Use polling on Windows if issues persist
      usePolling: false,
    },
  },
  plugins: [
    react(),
    mode === 'development' &&
    componentTagger(),
  ].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  // Optimize for better performance
  optimizeDeps: {
    include: ['react', 'react-dom', 'react-router-dom'],
  },
}));
