require 'rails_helper'

feature 'User can add links to question', %q(
        In order to provide additional info to my question
        As an question's author
        I'd like to able to add links
) do
  given(:user) { create(:user) }
  given(:question_data) { attributes_for(:question) }
  given(:correct_link) { {name: 'google', url: 'google.com'} }

  background { login(user) }

  describe 'User adds one link when asks question', js: true do
    background do
      visit new_question_path
      fill_in 'Title', with: question_data[:title]
      fill_in 'Body', with: question_data[:body]
    end

    scenario 'correct link' do
      fill_in 'Link name', with: correct_link[:name]
      fill_in 'Link URL', with: correct_link[:url]
      click_on 'Ask'

      expect(page).to have_link correct_link[:name], href: correct_link[:url]
    end
  end

  scenario 'User adds multiple links when asks question', js: true do
    another_correct_link = {name: 'thinknetica', url: 'thinknetica.com'}
    visit new_question_path
    fill_in 'Title', with: question_data[:title]
    fill_in 'Body', with: question_data[:body]

    within('.links') do
      within('.nested-fields') do
        fill_in 'Link name', with: correct_link[:name]
        fill_in 'Link URL', with: correct_link[:url]
      end

      click_link 'Add Link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: another_correct_link[:name]
        fill_in 'Link URL', with: another_correct_link[:url]
      end
    end

    click_on 'Ask'

    expect(page).to have_link correct_link[:name], href: correct_link[:url]
    expect(page).to have_link another_correct_link[:name], href: another_correct_link[:url]
  end
end
