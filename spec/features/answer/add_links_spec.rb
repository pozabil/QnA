require 'rails_helper'

feature 'User can add links to answer', %q(
        In order to provide additional info to my answer
        As an answer's author
        I'd like to able to add links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer_data) { attributes_for(:answer) }
  given(:correct_link_data) { attributes_for(:link, :correct) }
  given(:another_correct_link_data) { attributes_for(:link, :another_correct) }
  given(:wrong_link_data) { attributes_for(:link, :wrong) }

  background { login(user) }

  describe 'User adds one link when gives answer', js: true do
    background do
      visit question_path(question)
      within('.new-answer') { fill_in 'Your Answer', with: answer_data[:body] }
    end

    scenario 'correct link' do
      within('.new-answer') do
        fill_in 'Link name', with: correct_link_data[:name]
        fill_in 'Link URL', with: correct_link_data[:url]
        click_on 'Post Your Answer'
      end

      within('.answers') { expect(page).to have_link correct_link_data[:name], href: Link.format_url(correct_link_data[:url]) }
    end

    scenario 'wrong link' do
      within('.new-answer') do
        fill_in 'Link name', with: wrong_link_data[:name]
        fill_in 'Link URL', with: wrong_link_data[:url]
        click_on 'Post Your Answer'
      end

      expect(page).to have_content 'url is invalid'
      expect(page).to_not have_link wrong_link_data[:name], href: Link.format_url(wrong_link_data[:url])
    end
  end

  scenario 'User adds multiple links when gives answer', js: true do
    visit question_path(question)

    within('.new-answer') do
      fill_in 'Your Answer', with: answer_data[:body]

      within('.links') do
        within('.nested-fields') do
          fill_in 'Link name', with: correct_link_data[:name]
          fill_in 'Link URL', with: correct_link_data[:url]
        end

        click_link 'Add Link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: another_correct_link_data[:name]
          fill_in 'Link URL', with: another_correct_link_data[:url]
        end
      end

      click_on 'Post Your Answer'
    end

    within('.answers') do
      expect(page).to have_link correct_link_data[:name], href: Link.format_url(correct_link_data[:url])
      expect(page).to have_link another_correct_link_data[:name], href: Link.format_url(another_correct_link_data[:url])
    end
  end
end
