const path = require("path");
/* eslint-disable import/no-extraneous-dependencies */
const WebpackShellPluginNext = require("webpack-shell-plugin-next");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
// const env = require("dotenv").config({ path: ".env.example" });


const pluginPath = "./web/wp-content/plugins/"$PLUGIN_NAME"/";
const pluginName = ""$PLUGIN_NAME"";

// This is our JavaScript rule that specifies what to do with .js files
const javascript = {
  test: /\.(js)$/,
  exclude: /(node_modules)/,
  use: {
    loader: "babel-loader",
    options: {
      presets: ["@babel/preset-env"],
    },
  },
};

/*
  This is our postCSS loader which gets fed into the next loader.
*/

const postcss = {
  loader: "postcss-loader",
  options: {
    postcssOptions: {
      plugins: { autoprefixer: true },
    },
  },
};

// this is our sass/css loader. It handles files that are require('something.scss')
const styles = {
  test: /\.(scss)$/,
  // We don't just pass an array of loaders, we run them through the extract plugin so they can be outputted to their own .css file
  use: [
    MiniCssExtractPlugin.loader,
    {
      loader: "css-loader",
      options: {
        sourceMap: true,
      },
    },
    {
      loader: "resolve-url-loader",
    },
    postcss,
    {
      loader: "sass-loader",
      options: {
        sourceMap: true,
      },
    },
  ],
};

// OK - now it's time to put it all together
const config = {
  entry: {
    [pluginName]: path.resolve(
      __dirname,
      pluginPath,
      "./includes/src/index.js"
    ),
  },
  // Once things are done, we kick it out to a file.
  output: {
    // path is a built in node module
    // __dirname is a variable from node that gives us the
    path: path.resolve(__dirname, pluginPath, "public", "js"),
    // we can use "substitutions" in file names like [name] and [hash]
    // name will be `App` because that is what we used above in our entry
    filename: "[name]-public.js",
  },
  module: {
    rules: [javascript, styles],
  },
  // finally we pass it an array of our plugins
  plugins: [
    // here is where we tell it to output our css to a separate file
    new MiniCssExtractPlugin({
      filename: `../css/${pluginName}-public.css`,
    }),
    new WebpackShellPluginNext({
      onBuildStart: {
        scripts: ['echo "Webpack Start... Regenerating last css and js";'],
        blocking: true,
        parallel: false,
      },
      onBuildEnd: {
        scripts: ['echo "Webpack End... "'],
        blocking: false,
        parallel: true,
      },
    }),
  ],
};

module.exports = config;
