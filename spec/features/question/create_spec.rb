require 'rails_helper'

feature 'User can create question', %q(
        In order to get answer from community
        As an authenticated user
        I'd like to able to ask the question
) do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:question_data) { attributes_for(:question) }

    background do
      login(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'tries to ask question' do
      fill_in 'Title', with: question_data[:title]
      fill_in 'Body', with: question_data[:body]
      click_on 'Ask'

      expect(page).to have_content 'Your question successfuly created'
      expect(page).to have_content question_data[:title]
      expect(page).to have_content question_data[:body]
    end

    scenario 'tries to ask question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'tries to ask question with files' do
      fill_in 'Title', with: question_data[:title]
      fill_in 'Body', with: question_data[:body]

      attach_file 'File', ["#{Rails.root}/spec/features/question/create_spec.rb", "#{Rails.root}/app/models/question.rb"]
      click_on 'Ask'

      expect(page).to have_link 'create_spec.rb'
      expect(page).to have_link 'question.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
