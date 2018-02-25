var request = require("request-promise");

class OctoPrintServer {
	constructor(settings) {
		this.address = settings.address;
		this.APIKey = settings.APIKey;
	}
	getEndpoint(path, qs) {
		let self = this;
		return new Promise((resolve, reject) => {
			let url = self.address + path;
			let options = {
				method: "GET",
				url: url,
				headers: {
					"X-Api-Key": self.APIKey
				},
				qs: qs,
				json: true // Automatically parses the JSON string in the response
			};

			request(options)
				.then((body) => {
					return resolve(body);
				})
				.catch((err) => {
					return reject(err);
				});
		});
	}
	printerStatus() {
		let self = this;
		return new Promise ((resolve, reject) => {
			let path = "/api/printer";
			self.getEndpoint(path).then( (body) => {
				return resolve(body);
			}).catch( (err) => {
				return reject(err);
			});
		});
	}
	jobStatus() {
		let self = this;
		return new Promise( (resolve, reject) => {
			let path = "/api/job";
			self.getEndpoint(path).then((body) => {
				return resolve(body);
			}).catch((err) => {
				return reject(err);
			});
		});
	}
}
module.exports = OctoPrintServer;
