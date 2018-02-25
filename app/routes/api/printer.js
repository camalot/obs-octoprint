"use strict";
const express = require("express");
const merge = require("merge");
const router = express.Router();
const Promise = require("promise");
const config = require("./job.config.js");
// const brain = require('../lib/brain');
const utils = require("../../lib/utils");
const OctoPrintServer = require("octoprint");

/* GET home page. */
router.get("/", (req, res, next) => {
	let settings = {
		address: `http://${config.OctoPrint.SERVER}:${config.OctoPrint.PORT}`,
		APIKey: config.OctoPrint.API_KEY,
		version: "0.1"
	};

	let url = `http://${config.OctoPrint.SERVER}:${config.OctoPrint.PORT}`;

	let server = new OctoPrintServer(settings);
	server.restGET("/api/printer").then((output, err) => {
		if (err) {
			return res.status(500).send(err.message);
		}
		res.json(output);
	});
});


module.exports = router;
