"use strict";
const express = require("express");
const merge = require("merge");
const router = express.Router();
const Promise = require("promise");
const config = require("./job.config.js");
const utils = require("../../lib/utils");
const OctoPrintServer = require("../../lib/octoprint");

/* GET home page. */
router.get("/", (req, res, next) => {
	let settings = {
		address: `http://${config.OctoPrint.SERVER}:${config.OctoPrint.PORT}`,
		APIKey: config.OctoPrint.API_KEY
	};
	let server = new OctoPrintServer(settings);
	server.printerStatus().then((printer) => {
		server.jobStatus().then((output, err) => {
			if (err) {
				return res.status(500).send(err.message);
			}
			return res.json({ printer: printer, status: output });
		}).catch( (err) => {
			if (err) {
				return res.status(500).send(err.message);
			}
		});
	}).catch( (err) => {
		if (err) {
			return res.status(500).send(err.message);
		}
		return next();
	});
});

module.exports = router;
