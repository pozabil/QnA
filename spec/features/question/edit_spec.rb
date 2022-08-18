require 'rails_helper'

feature 'User can edit question', %q(
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    given(:another_user) { create(:user) }

    background { login(user) }

    scenario 'tries to edit their question' do
      custom_question_data = attributes_for(:question, :custom)

      visit question_path(question)

      within('.question') do
        click_on 'Edit question'
        fill_in 'question[title]', with: custom_question_data[:title]
        fill_in 'question[body]', with: custom_question_data[:body]
        click_on 'Save'

        expect(page).to have_content custom_question_data[:title]
        expect(page).to have_content custom_question_data[:body]
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to have_content 'Your question has been successfully edited'
    end

    scenario 'tries to edit their question with errors' do
      visit question_path(question)

      within('.question') do
        click_on 'Edit question'
        fill_in 'question[title]', with: nil
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit someone else's question" do
      another_user = create(:user)
      another_question = create(:question, user: another_user)
      visit question_path(another_question)

      within('.question') { expect(page).to_not have_link 'Edit question' }
    end
  end

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    within('.question') { expect(page).to_not have_link 'Edit question' }
  end
end