require 'rails_helper'

feature 'User can delete their question', %q(
        In order to remove question
        As an authenticated user
        I'd like to be able to delete my question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user' do
    given(:another_user) { create(:user) }
    given(:another_question) { create(:question, user_id: another_user.id) }

    background { login(user) }

    scenario 'tries to delete their question' do
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question has been deleted'
      expect(page).to_not have_content question.title
    end

    scenario "tries to delete someone else's answer" do
      visit question_path(another_question)

      expect(page).to_not have_content "Delete question"
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_content "Delete question"
  end
end
