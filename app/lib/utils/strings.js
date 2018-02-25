"use strict";

module.exports = {
	slug: (s) => {
		return s
			.replace(/\s/gi, "-")
			.trim()
			.toLowerCase();
	}
};
