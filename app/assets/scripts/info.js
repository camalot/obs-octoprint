"use strict";
$(function() {
	setInterval(function() {
		let STATES = {
			Operational: "Idle",
			Printing: "Printing"
		};
		$.ajax("/api/job", {
			success: (data, text, xhr) => {
				if (data.status && data.status.job && data.status.progress) {
					let format =
						data.status.progress.printTime <= 90 ? "seconds" : "minutes";
					let duration_elapsed = moment
						.duration({ seconds: data.status.progress.printTime }, format)
						.humanize();
					let duration_remaining =
						STATES[data.status.state] === STATES.Operational
							? "complete"
							: "calculating...";
					if (data.status.progress.printTimeLeft) {
						let format =
							data.status.progress.printTimeLeft <= 90 ? "seconds" : "minutes";
						duration_remaining = moment
							.duration({ seconds: data.status.progress.printTimeLeft }, format)
							.humanize();
					}
					$("#print_state").html((STATES[data.status.state] || "Disconnected").toLowerCase().trim());
					$("#print_remaining").html(duration_remaining);
					$("#print_elapsed").html(duration_elapsed);
					$("#tool0_actual").html(data.printer.temperature.tool0.actual);
					$("#tool0_target").html(data.printer.temperature.tool0.target);
					if (typeof(data.printer.temperature.bed) != 'undefined') {
						$("#bed_actual").html(data.printer.temperature.bed.actual);
						$("#bed_target").html(data.printer.temperature.bed.target);
					} else {
						$("#bed").addClass("hidden")
					}

					if(data.status.job.file && data.status.job.file.name) {
						$(".file").removeClass("hidden");
						let fileName = data.status.job.file.name.replace(/^API3_/i, "").toLowerCase().trim();
						$("#print_file").html(fileName);
					} else {
						$(".file").addClass("hidden");
					}
				}
			}
		});
	}, 1000);
});
