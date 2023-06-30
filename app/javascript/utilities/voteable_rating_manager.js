document.addEventListener('turbolinks:load', function() {
    var $answersContainer = $('.answers')
    if ($answersContainer.length) {
        $answersContainer.on('ajax:success', '.upvote_button_form, .downvote_button_form', function(e) {
            var response = e.detail[0]
            var answerId = response.answer.id
            var answerRating = response.answer.rating
            var action = response.answer.action

            var $answerRow = $answersContainer.find('#answer-' + answerId)
            var $answerRating = $answerRow.find('.rating')
            var $upvoteButton = $answerRow.find('.upvote_button')
            var $downvoteButton = $answerRow.find('.downvote_button')

            $answerRating.text(answerRating)
            if (action == 'upvote') {
                $upvoteButton.hasClass('active') ? $upvoteButton.removeClass('active') : $upvoteButton.addClass('active')
                $downvoteButton.removeClass('active')
            } else if (action == 'downvote') {
                $upvoteButton.removeClass('active')
                $downvoteButton.hasClass('active') ? $downvoteButton.removeClass('active') : $downvoteButton.addClass('active')
            }
        })
    }

    var $questionContainer = $('.question')
    if ($questionContainer.length) {
        $questionContainer.on('ajax:success', '.upvote_button_form, .downvote_button_form', function(e) {
            var response = e.detail[0]
            var questionRating = response.question.rating
            var action = response.question.action

            var $questionRating = $questionContainer.find('.rating')
            var $upvoteButton = $questionContainer.find('.upvote_button')
            var $downvoteButton = $questionContainer.find('.downvote_button')

            $questionRating.text(questionRating)
            if (action == 'upvote') {
                $upvoteButton.hasClass('active') ? $upvoteButton.removeClass('active') : $upvoteButton.addClass('active')
                $downvoteButton.removeClass('active')
            } else if (action == 'downvote') {
                $upvoteButton.removeClass('active')
                $downvoteButton.hasClass('active') ? $downvoteButton.removeClass('active') : $downvoteButton.addClass('active')
            }
        })
    }
})
