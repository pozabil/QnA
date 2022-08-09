require 'rails_helper'

feature 'User can delete their answer to question', %q(
        In order to remove answers to question
        As an author of answer
        I'd like to be able to delete my answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  describe 'Authenticated user', js: true do
    given!(:extra_answers) { create_list(:answer, 3, question_id: question.id, user_id: user.id) }

    background { login(user) }

    scenario 'tries to delete their answer' do
      visit question_path(question)

      within(".answers #answer-#{answer.id}") { accept_alert { click_link 'Delete' } }

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Your answer has been deleted'
    end

    scenario "tries to delete someone else's answer" do
      another_user = create(:user)
      another_answer = create(:answer, question_id: question.id, user_id: another_user.id)
      visit question_path(question)

      within(".answers #answer-#{another_answer.id}") { expect(page).to_not have_link 'Delete' }
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    within('.answers') { expect(page).to_not have_link 'Delete' }
  end
end
