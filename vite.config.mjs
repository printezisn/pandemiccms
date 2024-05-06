import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  build: { sourcemap: false },
  plugins: [
    RubyPlugin(),
  ],
})
