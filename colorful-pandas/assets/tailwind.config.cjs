const defaultTheme = require("tailwindcss/defaultTheme");
const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

module.exports = {
  content: ["./js/**/*.js", "../lib/*/web/**/*.*ex"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Manrope", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        teal: "#197278",
        chestnut: "#772E25",
        black: "#051923",
        "light-blue": "#EDF6F9",
        "green": "#C1DBB3",
      },
      borderRadius: {
        md: "0.25rem",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(function({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "./vendor/phosphor");
      let values = {};
      fs.readdirSync(iconsDir).map((file) => {
        let name = path.basename(file, ".svg");
        values[name] = { name, fullPath: path.join(iconsDir, file) };
      });
      matchComponents(
        {
          phosphor: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, "");
            return {
              [`--phosphor-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              "-webkit-mask": `var(--phosphor-${name})`,
              mask: `var(--phosphor-${name})`,
              "background-color": "currentColor",
              "vertical-align": "middle",
              display: "inline-block",
              width: theme("spacing.5"),
              height: theme("spacing.5"),
            };
          },
        },
        { values }
      );
    }),
  ],
};
