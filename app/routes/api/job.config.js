"use strict";

const xconfig = require("../../config");
const merge = require("merge");

let config = {
	"api/job": {
		route: "/api/job"
	}
};

module.exports = merge(xconfig, config);
