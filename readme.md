# OBS-OCTOPRINT

This provides OBS Overlay endpoints to show information about a network printer.

![](https://i.imgur.com/f0vJDcy.png)

### ENDPOINTS
 - `/overlay/progress` : Shows a progress bar
 - `/overlay/info` : Shows print info label
 - `/api/job` : The endpoint that provides the info to the UI endpoints

### REQUIRED ENVIRONMENT VARIABLES

- `OCTOPRINT_API_KEY` : The OctoPrint API Key
- `OCTOPRINT_HOST` : OctoPrint server Host name
- `OCTOPRINT_PORT` : OctoPrint server Port

---

### RUN IN DOCKER

The conainer exposes port 3000. `-P` will map the port on the host.

```shell
$ docker build --pull --tag camalot/obs-octoprint -f "./Dockerfile" .
$ docker run -d -P \
	--restart unless-stopped \
	--name "obs-octoprint" \
	-e OCTOPRINT_API_KEY="${OCTOPRINT_API_KEY}" \
	-e OCTOPRINT_HOST="${OCTOPRINT_HOST}" \
	-e OCTOPRINT_PORT="${OCTOPRINT_PORT}" \
	-t camalot/obs-octoprint
```

### RUN IN NODE

- Create a `.env` file in the `obs-octoprint` directory. 
- Add the following:
```
OCTOPRINT_API_KEY=<MY_OCTOPRINT_API_KEY>
OCTOPRINT_HOST=<MY_OCTOPRINT_HOST_NAME>
OCTOPRINT_PORT=5000
```
- Open shell and run the following:
```shell
$ npm install
$ npm start
```
- Open a browser to http://localhost:3000/overlay/info
