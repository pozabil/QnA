require 'rails_helper'

feature 'User can edit answer', %q(
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  describe 'Authenticated user', js: true do
    given!(:extra_answers) { create_list(:answer, 3, question_id: question.id, user_id: user.id) }
    given(:another_user) { create(:user) }
    given(:another_answer) { create(:answer, question_id: question.id, user_id: another_user.id) }
    given(:custom_answer_data) { attributes_for(:answer, :custom) }

    background { login(user) }

    scenario 'tries to edit their answer' do
      visit question_path(question)

      within(".answers #answer-#{answer.id}") do
        click_on 'Edit'
        fill_in 'Your Answer', with: custom_answer_data[:body]
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
        fill_in 'Your Answer', with: nil
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit someone else's answer" do
      another_answer
      visit question_path(question)

      within(".answers #answer-#{another_answer.id}") do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
