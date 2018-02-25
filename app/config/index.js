"use strict";
const merge = require("merge");
//const rules = merge(require("../rules/config"));

let outConfig = {};

const normalizedPath = require("path").join(__dirname, "./");
require("fs")
	.readdirSync(normalizedPath)
	.forEach(function(file) {
		var configMatch = /.*?\.config\.js/i;
		if (
			file !== "index.js" &&
			file !== "config.js" &&
			configMatch.test(file)
		) {
			outConfig = merge(outConfig, require("./" + file));
		}
	});

let result = merge({}, outConfig);
module.exports = result;
