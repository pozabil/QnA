require 'rails_helper'

feature 'User can create answer', %q(
        In order to answer the question
        As an authenticated user
        I'd like to be able to give the answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user' do
    given(:answer_data) { attributes_for(:answer) }

    background do
      login(user)
      visit question_path(question)
    end

    scenario 'tries to give answer' do
      fill_in 'Your Answer', with: answer_data[:body]
      click_on 'Post Your Answer'

      expect(page).to have_content 'Your answer successfuly posted'
      expect(page).to have_content answer_data[:body]
    end

    scenario 'tries to give answer with errors' do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give answer' do
    visit question_path(question)
    click_on 'Post Your Answer'

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
