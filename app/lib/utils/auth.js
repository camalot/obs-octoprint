'use strict';

module.exports = {
	isLoggedIn: (req, res, next) => {
		process.nextTick(() => {
			// if user is authenticated in the session, carry on
			if (req.isAuthenticated())
				return next();

			if (/^\/$/gi.test(req.route.path)) {
				return res.redirect("/");
			}
			// if they aren't redirect them to the home page
			return res.redirect("/login");
		});
	}
};
