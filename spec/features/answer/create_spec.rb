require 'rails_helper'

feature 'User can create answer', %q(
        In order to answer the question
        As an authenticated user
        I'd like to be able to give the answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    given(:answer_data) { attributes_for(:answer) }

    background do
      login(user)
      visit question_path(question)
    end

    scenario 'tries to give answer' do
      within('.new-answer') do
        fill_in 'Your Answer', with: answer_data[:body]
        click_on 'Post Your Answer'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Your answer successfuly posted'
      within('.answers') { expect(page).to have_content answer_data[:body] }
    end

    scenario 'tries to give answer with errors' do
      within('.new-answer') { click_on 'Post Your Answer' }

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to give answer with files' do
      within('.new-answer') do
        fill_in 'Your Answer', with: answer_data[:body]

        attach_file 'answer[files][]', [
          "#{Rails.root}/spec/features/answer/create_spec.rb",
          "#{Rails.root}/app/models/answer.rb"
        ]
        click_on 'Post Your Answer'
      end

      within('.answers') do
        expect(page).to have_link 'create_spec.rb'
        expect(page).to have_link 'answer.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries to give answer', js: true do
    visit question_path(question)
    within('.new-answer') { click_on 'Post Your Answer' }

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
