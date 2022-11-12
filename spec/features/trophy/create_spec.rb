require 'rails_helper'

feature 'User can create trophy for best answer', %q(
        In order to reward the answerer
        As the question's author
        I'd like to able to create a trophy for best answer
) do
  given(:user) { create(:user) }
  given(:question_data) { attributes_for(:question) }

  background do
    login(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question_data[:title]
    fill_in 'Body', with: question_data[:body]
  end

  describe 'tries to create a trophy' do
    given(:trophy_title) { 'best_answer_trophy' }

    scenario 'with correct data' do
      within('.trophy') do
        fill_in 'Trophy title', with: trophy_title
        attach_file 'Trophy image', file_fixture('pes_s_rukoi.jpg')
      end

      click_on 'Ask'

      within('.trophy') do
        expect(page).to have_content trophy_title
        expect(page).to have_css("img[src$='pes_s_rukoi.jpg']")
      end
    end

    describe 'with errors' do
      scenario 'empty title' do
        within('.trophy') { attach_file 'Trophy image', file_fixture('pes_s_rukoi.jpg') }

        click_on 'Ask'

        expect(page).to have_content "Trophy title can't be blank"
      end

      scenario 'missing image' do
        within('.trophy') { fill_in 'Trophy title', with: trophy_title }

        click_on 'Ask'

        expect(page).to have_content "Trophy image can't be blank"
      end

      scenario 'attach not-image file' do
        within('.trophy') do
          fill_in 'Trophy title', with: trophy_title
          attach_file 'Trophy image', file_fixture('simple_text.txt')
        end

        click_on 'Ask'

        expect(page).to have_content "Trophy image has an invalid content type"
      end
    end
  end
end
