document.addEventListener('turbolinks:load', function() {
	if ($('.answers')) {
		$('.answers').on('click', '.edit-answer-link', function(event) {
			event.preventDefault()
			var answerId = $(this).data('answerId')

			$(this).hide()
			$(`.answers #answer-${answerId} .answer-body`).hide()
			$(`.answers #answer-${answerId} form`).show()
		})
	}
})
