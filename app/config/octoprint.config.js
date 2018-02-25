
'use strict';
const npmpackage = require("../../package.json");
let result = {
	OctoPrint: {
		BRAIN_KEY: "OBS-OCTOPRINT",
		VERSION: npmpackage.version,
		TITLE: "OctoPrint",
		URL: npmpackage.homepage,
		SERVER: process.env.OCTOPRINT_HOST,
		PORT: process.env.OCTOPRINT_PORT || 5000,
		API_KEY: process.env.OCTOPRINT_API_KEY
	}
};

module.exports = result;
