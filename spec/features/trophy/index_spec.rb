require 'rails_helper'

feature 'User can view their trophies', %q(
        In order to enjoy my trophies awarded for the best answers
        As an authenticated user
        I'd like to be able to view list of all my trophies
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 4, user: user) }
  3.times { |i| eval("let!(:trophy_#{i+1}) { create(:trophy, question: questions[#{i+1}]) }") }
  4.times { |i| eval("let!(:user_answer_to_question_#{i}) { create(:answer, question: questions[#{i}], user: user) }") }
  given(:another_user) { create(:user) }
  4.times { |i| eval("let!(:another_user_answer_to_question_#{i}) { create(:answer, question: questions[#{i}], user: another_user) }") }

  scenario 'Authenticated user tries to view the list of their trophy' do
    3.times { |i| eval("user_answer_to_question_#{i}.mark_as_best") }
    another_user_answer_to_question_3.mark_as_best
    login(user)
    visit questions_path
    within('nav') { click_on 'My trophies' }

    user.trophies.each { |trophy| expect(page).to have_content trophy.title }
  end

  scenario 'Unauthenticated user tries to view the list of their trophy' do
    visit questions_path

    expect(page).to_not have_link 'My trophies'
  end
end
