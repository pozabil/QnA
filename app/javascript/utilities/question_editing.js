document.addEventListener('turbolinks:load', function() {
	if ($('.question').length) {
		$('.question').on('click', '.edit-question-link', function(event) {
			event.preventDefault()

			$(this).hide()
			$('.question .question-title').hide()
			$('.question .question-body').hide()
			$('.question form').show()
			$('.question .remove-attachment-link').show()
		})
	}
})
