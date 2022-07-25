require 'rails_helper'

feature 'User can view question and answers to it', %q(
        In order to view question that interests me and answers to it
        As any user
        I would like to be able to go to question page
) do
  given!(:question) { create(:question) }
  given!(:answers) {create_list(:answer, 5, question_id: question.id)}

  scenario 'user tries to view question and answers to it' do
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end
