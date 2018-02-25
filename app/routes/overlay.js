'use strict';
const express = require('express');
const router = express.Router();
const Promise = require('promise');
const config = require('./overlay.config.js');
// const brain = require('../lib/brain');
const utils = require("../lib/utils");
const OctoPrintServer = require("octoprint");

/* GET home page. */
router.get('/progress', (req, res, next) => {
	res.render("progress", { layout: null });
});

/* GET home page. */
router.get('/info', (req, res, next) => {
	res.render("info", { layout: null });
});

module.exports = router;
