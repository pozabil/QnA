document.addEventListener('turbolinks:load', function() {
	if ($('.gist-link').length) {
		$('.gist-link').each(function() {
			gistPreviewLoader(this)
		})
	}

	let answers = $('.answers')

	let answerCreationObserver = new MutationObserver(function(mutations) {
		$.each(mutations, function() {
			let addedGistLinks = $(this.addedNodes).find('.gist-link')
			if (this.type === 'childList' && addedGistLinks.length) {
				addedGistLinks.each(function() {
					gistPreviewLoader(this)
				})
			}
		})
	})

	answers.each(function() {
		answerCreationObserver.observe(this, { childList: true, subtree: true })
	})
})

function gistPreviewLoader(gistLink) {
	let $this = $(gistLink)
	let gistId = $this.attr('href').split('/').pop()
	let oneGist = new Gh3.Gist({id:gistId})

	oneGist.fetchContents(function (err, res) {
		if(err) {
			$this.text($this.data('gistLinkName') + '(invalid gist URL)')
			throw 'Something went wrong'
		}

		$this.parent().addClass('gist-preview-container')

		let gistPreview = $('<div class="gist-preview-files">')

		oneGist.eachFile(function (file) {
			let fileNameElement = $('<div>').text(file.filename + ':')
			let fileContent = _.escape(file.content)
			let fileTextElement = $('<div class="gist-preview-text" style="white-space: break-spaces;">').html(fileContent)
			gistPreview.append(fileNameElement)
			gistPreview.append(fileTextElement)
		})

		$this.siblings('.gist-preview-files').remove()
		$this.parent().append(gistPreview)
	})
}
