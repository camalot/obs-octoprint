"use strict";
const redis = require("redis");

let redisOptions = {
	host: process.env.REDIS_HOST || "127.0.0.1",
	port: parseInt(process.env.REDIS_PORT || "6379",0)

};

let client = redis.createClient(redisOptions);

module.exports = client;
