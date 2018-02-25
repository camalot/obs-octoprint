"use strict";

module.exports = (req, res, next) => {
	res.locals.user = req.user;
	next();
};
