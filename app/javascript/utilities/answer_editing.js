document.addEventListener('turbolinks:load', function() {
	if ($('.answers').length) {
		$('.answers').on('click', '.edit-answer-link', function(event) {
			event.preventDefault()
			var answerId = $(this).data('answerId')

			$(this).hide()
			$(`.answers #answer-${answerId} .answer-body`).hide()
			$(`.answers #answer-${answerId} form.edit-answer-form`).show()
			$(`.answers #answer-${answerId} .remove-attachment-link`).show()
			$(`.answers #answer-${answerId} td:nth-child(2)`).after('<td class="balancing-column"></td>')
		})
	}
})
