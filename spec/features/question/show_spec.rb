require 'rails_helper'

feature 'User can view question and answers to it', %q(
        In order to view question that interests me and answers to it
        As any user
        I'd like to be able to go to the question page
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answers) { create_list(:answer, 5, question_id: question.id, user_id: user.id) }

  scenario 'user tries to view question and answers to it' do
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end
