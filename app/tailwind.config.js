/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['"Inter"', '"Noto Sans SC"', 'system-ui', 'sans-serif'],
        mono: ['"JetBrains Mono"', 'monospace'],
      },
      colors: {
        ark: {
          bg: '#141414',
          surface: '#1e1e1e',
          card: '#242424',
          border: '#333333',
          line: '#444444',
          yellow: '#e8e000',
          white: '#f0f0f0',
          muted: '#888888',
          dim: '#555555',
        },
      },
    },
  },
  plugins: [],
}