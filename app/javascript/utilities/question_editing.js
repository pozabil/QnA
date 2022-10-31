document.addEventListener('turbolinks:load', function() {
	if ($('.question').length) {
		$('.question').on('click', '.edit-question-link', function(event) {
			event.preventDefault()

			$('html').animate({
				scrollTop: $('nav').offset().top
			}, 100)

			$(this).hide()
			$('.question .question-title').hide()
			$('.question .question-body').hide()
			$('.question form').show()
			$('.question .remove-attachment-link').show()
			$('.question .remove-link-link').show()
		})
	}
})
