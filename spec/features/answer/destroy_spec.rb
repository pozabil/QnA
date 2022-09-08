require 'rails_helper'

feature 'User can delete their answer to question', %q(
        In order to remove answers to question
        As an author of answer
        I'd like to be able to delete my answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    given!(:extra_answers) { create_list(:answer, 3, question: question, user: user) }

    background { login(user) }

    scenario 'tries to delete their answer' do
      visit question_path(question)

      within(".answers #answer-#{answer.id}") { accept_alert { click_link 'Delete' } }

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Your answer has been deleted'
    end

    scenario 'tries to delete their best answer' do
      answer.mark_as_best
      visit question_path(question)

      within(".answers .best-answer") { accept_alert { click_link 'Delete' } }

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Your answer has been deleted'
    end

    scenario "tries to delete someone else's answer" do
      another_user = create(:user)
      another_answer = create(:answer, question: question, user: another_user)
      visit question_path(question)

      within(".answers #answer-#{another_answer.id}") { expect(page).to_not have_link 'Delete' }
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    within('.answers') { expect(page).to_not have_link 'Delete' }
  end
end
