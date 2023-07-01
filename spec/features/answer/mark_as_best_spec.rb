require 'rails_helper'

feature 'Author can choose best answer for their question', %q(
        In order to indicate answer that I liked
        As an author of question
        I'd like to be able to mark answer as best
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:extra_answers) { create_list(:answer, 3, question: question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background { login(user) }

    describe 'tries to mark answer as best for their question' do
      scenario 'question has no best answer' do
        visit question_path(question)
        within(".answers #answer-#{answer.id}") { click_on 'Mark as best' }

        within('.answers') do
          expect(page).to have_css "#answer-#{answer.id}.best-answer"
          expect(page.find("#answer-#{answer.id}.best-answer")).to have_content(answer.body)
          expect(page.find('tr', match: :first)).to have_content(answer.body)
        end

        expect(page).to have_content 'Selected answer has been marked as best'
      end

      scenario 'question has best answer' do
        other_answer = create(:answer, question: question, user: user)

        visit question_path(question)
        within(".answers #answer-#{answer.id}") { click_on 'Mark as best' }
        within(".answers #answer-#{other_answer.id}") { click_on 'Mark as best' }

        within('.answers') do
          expect(page).to have_css "#answer-#{other_answer.id}.best-answer"
          expect(page).to_not have_css "#answer-#{answer.id}.best-answer"
          expect(page).to have_css "#answer-#{answer.id}"
          expect(page.find("#answer-#{other_answer.id}.best-answer")).to have_content(other_answer.body)
          expect(page.find("#answer-#{answer.id}")).to have_content(answer.body)
          expect(page.find('tr', match: :first)).to have_content(other_answer.body)
        end

        expect(page).to have_content 'Selected answer has been marked as best'
      end
    end

    scenario "tries to mark answer as best for someone else's question" do
      another_user = create(:user)
      another_question = create(:question, user: another_user)
      another_answer = create(:answer, question: another_question, user: another_user)
      visit question_path(another_question)

      within(".answers #answer-#{another_answer.id}") { expect(page).to_not have_button 'Mark as best' }
    end
  end

  scenario 'Unauthenticated user tries to mark answer as best' do
    visit question_path(question)

    within('.answers') { expect(page).to_not have_button 'Mark as best' }
  end
end
