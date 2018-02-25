"use strict";

const config = require("./index");
const Strategy = require("passport-github2").Strategy;

module.exports = passport => {
	passport.serializeUser((user, done) => {
		done(null, user);
	});

	passport.deserializeUser((obj, done) => {
		done(null, obj);
	});

	passport.use(new Strategy(
			{
				clientID: config.github.authClientID,
				clientSecret: config.github.authClientSecret,
				callbackURL: config.GRB.BOTURL + "/login/auth/return"
			},
			function(accessToken, refreshToken, profile, callback) {
				callback(null, profile);
			}
		));
};
