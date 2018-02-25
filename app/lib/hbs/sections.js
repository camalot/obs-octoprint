'use strict';
const hbs = require ('hbs');

hbs.registerHelper('section', function (name, context) {
	if (!this._sections) {
		this._sections = {};
	}

	if (!this._sections[name]) {
		this._sections[name] = [];
	}
	this._sections[name].push(context.fn(this));
	return null;
});


hbs.registerHelper("block", function (name) {
	if (!this._sections) {
		this._sections = {};
	}
	let val = (this._sections[name] || []).join('\n');
	this._sections[name] = [];
	return val;
});
