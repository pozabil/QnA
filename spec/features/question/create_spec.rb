require 'rails_helper'

feature 'User can create question', %q(
        In order to get answer from community
        As an authenticated user
        I'd like to able to ask question
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

    scenario 'tries to ask a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
