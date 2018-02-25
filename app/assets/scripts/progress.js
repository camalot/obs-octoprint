"use strict";
$(function() {
	setInterval(function() {
		$.ajax("/api/job", {
			success: (data, text, xhr) => {
				let progressBar = document
				.querySelector(".mdl-js-progress");
				let percentage = 0;
				if (data.status.job && data.status.progress) {
					percentage = Math.ceil(data.status.progress.completion);
				} else {
					percentage = 0;
				}
				// if ($(".mdl-js-progress .progressbar-label").length === 0) {
				// 	// $(".mdl-js-progress").append(`<div class="progressbar-label">${percentage}%</div>`);
				// }
				progressBar.MaterialProgress.setProgress(percentage);
			}
		});
	}, 1000);
});
