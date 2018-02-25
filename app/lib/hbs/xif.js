'use strict';
const hbs = require("hbs");
hbs.registerHelper('xif', function(v1, operator, v2, options) {
	switch (operator) {
		case '==':
			/*jshint -W116*/
			return (v1 == v2) ? options.fn(this) : options.inverse(this);
			/*jshint +W116*/
		case '===':
			return (v1 === v2) ? options.fn(this) : options.inverse(this);
		case '!=':
			/*jshint -W116*/
			return (v1 != v2) ? options.fn(this) : options.inverse(this);
			/*jshint +W116*/
		case '!==':
			return (v1 !== v2) ? options.fn(this) : options.inverse(this);
		case '<':
			return (v1 < v2) ? options.fn(this) : options.inverse(this);
		case '<=':
			return (v1 <= v2) ? options.fn(this) : options.inverse(this);
		case '>':
			return (v1 > v2) ? options.fn(this) : options.inverse(this);
		case '>=':
			return (v1 >= v2) ? options.fn(this) : options.inverse(this);
		case '&&':
			return (v1 && v2) ? options.fn(this) : options.inverse(this);
		case '||':
			return (v1 || v2) ? options.fn(this) : options.inverse(this);
		default:
			return options.inverse(this);
	}
});
