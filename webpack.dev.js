const path = require("path");
// eslint-disable-next-line import/no-extraneous-dependencies
const { merge } = require("webpack-merge");
const common = require("./webpack.common");

const pluginPath = "./web/wp-content/plugins/"$PLUGIN_NAME"/";

// mode, devtools, devServer
module.exports = merge(common, {
  mode: "development",
  devtool: "source-map",
  devServer: {
    contentBase: path.resolve(__dirname, pluginPath, "./public/js"),
  },
});
