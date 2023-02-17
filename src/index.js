// This is the main entry point for the custom scss.
// Webpack will watch this file for any changes and recompile into css
// if the server is running:   Use npm run start:webdev
import "./scss/main.scss";

import { jsObj } from "./js/example";

console.log("WEBPACK BUILD SUCCESSFUL 2");

const test = () => {
  const data = "hello";
  console.log(data, "this worked");
};

test();
console.log("input result", jsObj.example);
