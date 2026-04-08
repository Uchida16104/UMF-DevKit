/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "../vue/index.html",
    "../vue/src/**/*.{vue,js,ts,jsx,tsx}",
    "../htmx/**/*.html",
  ],
  theme: {
    extend: {
      fontFamily: {
        mono: ["ui-monospace", "SFMono-Regular", "Menlo", "Monaco", "Consolas", "monospace"],
      },
    },
  },
  plugins: [],
};
