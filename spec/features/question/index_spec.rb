require 'rails_helper'

feature 'User can view question list', %q(
        In order to find question that interests me
        As any user
        I'd like to be able to view list of all questions
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }

  scenario 'user tries to view the list of questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
