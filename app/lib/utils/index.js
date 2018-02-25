"use strict";
const fs = require("fs");
const path = require("path");
const normalizedPath = path.join(__dirname, "./");

let libs = {};
fs.readdirSync(normalizedPath).forEach(file => {
	let configMatch = /.*?\.config\.js/i;
	if (file !== "index.js" && file !== "config.js" && !configMatch.test(file)) {
		var name = file.substring(0, file.lastIndexOf("."));
		libs[name] = require("./" + name);
	}
});

module.exports = libs;
