require 'rails_helper'

feature 'User can upvote or downvote answer', %q(
        In order to rated someone else's answer
        As an authenticated user
        I'd like to be able to vote the answer
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: another_user) }
  given!(:user_answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    describe "tries to vote someone else's answer" do
      given(:old_rating) { answer.reload.rating }

      describe "upvote" do
        scenario "answer they haven't voted yet" do
          @old_rating = old_rating

          within(".answers #answer-#{answer.id}") do
            click_on(class: 'upvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating + 1)
          end
        end

        scenario "answer they upvoted" do
          within(".answers #answer-#{answer.id}") { click_on(class: 'upvote_button') }
          visit current_path

          @old_rating = old_rating

          within(".answers #answer-#{answer.id}") do
            click_on(class: 'upvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating - 1)
          end
        end

        scenario "answer they downvoted" do
          within(".answers #answer-#{answer.id}") { click_on(class: 'downvote_button') }
          visit current_path

          @old_rating = old_rating

          within(".answers #answer-#{answer.id}") do
            click_on(class: 'upvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating + 2)
          end
        end

        scenario "answer they removed vote" do
          within(".answers #answer-#{answer.id}") do
            click_on(class: 'upvote_button')
            click_on(class: 'upvote_button')
          end
          visit current_path

          @old_rating = old_rating

          within(".answers #answer-#{answer.id}") do
            click_on(class: 'upvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating + 1)
          end
        end
      end

      describe "downvote" do
        scenario "answer they haven't voted yet" do
          @old_rating = old_rating

          within(".answers #answer-#{answer.id}") do
            click_on(class: 'downvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to include('active')
            expect(page.find(".rating")).to have_content(@old_rating - 1)
          end
        end

        scenario "answer they upvoted" do
          within(".answers #answer-#{answer.id}") { click_on(class: 'upvote_button') }
          visit current_path

          @old_rating = old_rating

          within(".answers #answer-#{answer.id}") do
            click_on(class: 'downvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to include('active')
            expect(page.find(".rating")).to have_content(@old_rating - 2)
          end
        end

        scenario "answer they downvoted" do
          within(".answers #answer-#{answer.id}") { click_on(class: 'downvote_button') }
          visit current_path

          @old_rating = old_rating

          within(".answers #answer-#{answer.id}") do
            click_on(class: 'downvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating + 1)
          end
        end

        scenario "answer they removed vote" do
          within(".answers #answer-#{answer.id}") do
            click_on(class: 'downvote_button')
            click_on(class: 'downvote_button')
          end
          visit current_path

          @old_rating = old_rating

          within(".answers #answer-#{answer.id}") do
            click_on(class: 'downvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to include('active')
            expect(page.find(".rating")).to have_content(@old_rating - 1)
          end
        end
      end
    end

    scenario 'tries to vote their answer' do
      within(".answers #answer-#{user_answer.id}") { expect(page).to_not have_css('.upvote_button') }
      within(".answers #answer-#{user_answer.id}") { expect(page).to_not have_css('.downvote_button') }
    end
  end

  scenario 'Unauthenticated user tries to vote the answer' do
    visit question_path(question)

    within('.answers') { expect(page).to_not have_css('.upvote_button') }
    within('.answers') { expect(page).to_not have_css('.downvote_button') }
  end
end
