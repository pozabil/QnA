require 'rails_helper'

feature 'User can delete their answer to question', %q(
        In order to remove answers to question
        As an authenticated user
        I'd like to be able to delete their answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  describe 'Authenticated user' do
    given(:another_user) { create(:user) }
    given!(:another_answer) { create(:answer, question_id: question.id, user_id: another_user.id) }

    background { login(user) }

    scenario 'tries to delete their answer' do
      visit question_path(question)
      click_link 'Delete answer', href: "/answers/#{answer.id}"

      expect(page).to have_content 'Your answer has been deleted'
      expect(page).not_to have_content answer.body
    end

    scenario "tries to delete someone else's answer" do
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer', href: "/answers/#{another_answer.id}"
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer', href: "/answers/#{answer.id}"
  end
end
