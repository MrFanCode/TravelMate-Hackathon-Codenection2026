import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        paper: "#F3E9D2",
        paper2: "#EDE0BF",
        ink: "#22314A",
        inkSoft: "#5B5142",
        rust: "#B84A2E",
        rustDark: "#8E3821",
        mustard: "#D89B34",
        pine: "#3B5C4C",
        line: "#CBB98A",
        cream: "#FBF6E9",
      },
      fontFamily: {
        display: ["Fraunces", "serif"],
        body: ["Public Sans", "sans-serif"],
        mono: ["Space Mono", "monospace"],
      },
    },
  },
  plugins: [],
};
export default config;
