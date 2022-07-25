require 'rails_helper'

feature 'User can create question', %q(
        In order to find question that interests me
        As any user
        I'd like to be able to view list of all questions
) do
  given!(:questions) { create_list(:question, 5) }

  scenario 'user tries to view the list of questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
