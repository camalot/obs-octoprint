var request = require("request-promise");

class OctoPrintServer {
	constructor(settings) {
		this.address = settings.address;
		this.APIKey = settings.APIKey;
		this.version = settings.version;
	}
	getEndpoint(path, qs) {
		var self = this;
		return new Promise(function(resolve, reject) {
			var url = self.address + path;
			var options = {
				method: "GET",
				url: url,
				headers: {
					"X-Api-Key": self.APIKey
				},
				qs: qs,
				json: true // Automatically parses the JSON string in the response
			};

			request(options)
				.then(function(body) {
					return resolve(body);
				})
				.catch(function(err) {
					return reject(err);
				});
		});
	}
}
module.exports = {};
