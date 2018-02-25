"use strict";
const config = require('../../config');
module.exports = (req, res, next) => {
	res.locals.YTSB = config.YTSB;
	next();
};
