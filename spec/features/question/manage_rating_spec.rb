require 'rails_helper'

feature 'User can upvote or downvote question', %q(
        In order to rated someone else's question
        As an authenticated user
        I'd like to be able to vote the question
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: another_user) }
  given(:user_question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background { login(user) }

    describe "tries to vote someone else's question" do
      given(:old_rating) { question.reload.rating }

      background { visit question_path(question) }

      describe "upvote" do
        scenario "question they haven't voted yet" do
          @old_rating = old_rating

          within('.question') do
            click_on(class: 'upvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating + 1)
          end
        end

        scenario "question they upvoted" do
          within(".question") { click_on(class: 'upvote_button') }
          visit current_path

          @old_rating = old_rating

          within(".question") do
            click_on(class: 'upvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating - 1)
          end
        end

        scenario "question they downvoted" do
          within(".question") { click_on(class: 'downvote_button') }
          visit current_path

          @old_rating = old_rating

          within(".question") do
            click_on(class: 'upvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating + 2)
          end
        end

        scenario "question they removed vote" do
          within(".question") do
            click_on(class: 'upvote_button')
            click_on(class: 'upvote_button')
          end
          visit current_path

          @old_rating = old_rating

          within(".question") do
            click_on(class: 'upvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating + 1)
          end
        end
      end

      describe "downvote" do
        scenario "question they haven't voted yet" do
          @old_rating = old_rating

          within(".question") do
            click_on(class: 'downvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to include('active')
            expect(page.find(".rating")).to have_content(@old_rating - 1)
          end
        end

        scenario "question they upvoted" do
          within(".question") { click_on(class: 'upvote_button') }
          visit current_path

          @old_rating = old_rating

          within(".question") do
            click_on(class: 'downvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to include('active')
            expect(page.find(".rating")).to have_content(@old_rating - 2)
          end
        end

        scenario "question they downvoted" do
          within(".question") { click_on(class: 'downvote_button') }
          visit current_path

          @old_rating = old_rating

          within(".question") do
            click_on(class: 'downvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to_not include('active')
            expect(page.find(".rating")).to have_content(@old_rating + 1)
          end
        end

        scenario "question they removed vote" do
          within(".question") do
            click_on(class: 'downvote_button')
            click_on(class: 'downvote_button')
          end
          visit current_path

          @old_rating = old_rating

          within(".question") do
            click_on(class: 'downvote_button')
            sleep(1)

            expect(page.find(".upvote_button")[:class]).to_not include('active')
            expect(page.find(".downvote_button")[:class]).to include('active')
            expect(page.find(".rating")).to have_content(@old_rating - 1)
          end
        end
      end
    end

    scenario 'tries to vote their question' do
      visit question_path(user_question)

      within(".question") { expect(page).to_not have_css('.upvote_button') }
      within(".question") { expect(page).to_not have_css('.downvote_button') }
    end
  end

  scenario 'Unauthenticated user tries to vote the question' do
    visit question_path(question)

    within('.question') { expect(page).to_not have_css('.upvote_button') }
    within('.question') { expect(page).to_not have_css('.downvote_button') }
  end
end
