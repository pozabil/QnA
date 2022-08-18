require 'rails_helper'

feature 'User can edit answer', %q(
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    given!(:extra_answers) { create_list(:answer, 3, question: question, user: user) }

    background { login(user) }

    scenario 'tries to edit their answer' do
      custom_answer_data = attributes_for(:answer, :custom)

      visit question_path(question)

      within(".answers #answer-#{answer.id}") do
        click_on 'Edit'
        fill_in 'answer[body]', with: custom_answer_data[:body]
        click_on 'Save'

        expect(page).to have_content custom_answer_data[:body]
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to have_content 'Your answer has been successfully edited'
    end

    scenario 'tries to edit their answer with errors' do
      visit question_path(question)

      within(".answers #answer-#{answer.id}") do
        click_on 'Edit'
        fill_in 'answer[body]', with: nil
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit someone else's answer" do
      another_user = create(:user)
      another_answer = create(:answer, question: question, user: another_user)
      visit question_path(question)

      within(".answers #answer-#{another_answer.id}") { expect(page).to_not have_link 'Edit' }
    end
  end

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    within('.answers') { expect(page).to_not have_link 'Edit' }
  end
end
