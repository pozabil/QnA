require 'rails_helper'

feature 'User can add links to answer', %q(
        In order to provide additional info to my answer
        As an answer's author
        I'd like to able to add links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:answer_data) { attributes_for(:answer) }
  given(:correct_link) { create(:link, :correct, linkable: answer) }
  given(:correct_link_data) { attributes_for(:link, :correct) }
  given(:another_correct_link_data) { attributes_for(:link, :another_correct) }
  given(:another_correct_link) { create(:link, :another_correct, linkable: answer) }
  given(:wrong_link_data) { attributes_for(:link, :wrong) }
  given(:gist_plain_text_link) { create(:link, :gist_plain_text, linkable: answer) }
  given(:gist_plain_text_link_data) { attributes_for(:link, :gist_plain_text) }
  given(:gist_html_js_code_link_data) { attributes_for(:link, :gist_html_js_code) }
  given(:gist_multiple_files_link_data) { attributes_for(:link, :gist_multiple_files) }
  given(:wrong_gist_link_data) { attributes_for(:link, :wrong_gist) }

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

    describe 'gist link', billy: true do
      scenario 'plain text' do
        gist_id = gist_plain_text_link_data[:url].split('/').last
        stub_gist_request(gist_id, 200)

        within('.new-answer') do
          fill_in 'Link name', with: gist_plain_text_link_data[:name]
          fill_in 'Link URL', with: gist_plain_text_link_data[:url]
          click_on 'Post Your Answer'
        end
        sleep(1)

        within('.answers') do
          expect(page).to have_link gist_plain_text_link_data[:name], href: Link.format_url(gist_plain_text_link_data[:url])
          Octokit.gist(gist_id).files.each do |k, v|
            expect(page).to have_content correct_text_for_expect(v.filename)
            expect(page).to have_content correct_text_for_expect(v.content)
          end
        end
      end

      scenario 'html_js_code' do
        gist_id = gist_html_js_code_link_data[:url].split('/').last
        stub_gist_request(gist_id, 200)

        within('.new-answer') do
          fill_in 'Link name', with: gist_html_js_code_link_data[:name]
          fill_in 'Link URL', with: gist_html_js_code_link_data[:url]
          click_on 'Post Your Answer'
        end
        sleep(1)

        within('.answers') do
          expect(page).to have_link gist_html_js_code_link_data[:name], href: Link.format_url(gist_html_js_code_link_data[:url])
          Octokit.gist(gist_id).files.each do |k, v|
            expect(page).to have_content correct_text_for_expect(v.filename)
            expect(page).to have_content correct_text_for_expect(v.content)
          end
        end
      end

      scenario 'multiple_files' do
        gist_id = gist_multiple_files_link_data[:url].split('/').last
        stub_gist_request(gist_id, 200)

        within('.new-answer') do
          fill_in 'Link name', with: gist_multiple_files_link_data[:name]
          fill_in 'Link URL', with: gist_multiple_files_link_data[:url]
          click_on 'Post Your Answer'
        end
        sleep(1)

        within('.answers') do
          expect(page).to have_link gist_multiple_files_link_data[:name], href: Link.format_url(gist_multiple_files_link_data[:url])
          Octokit.gist(gist_id).files.each do |k, v|
            expect(page).to have_content correct_text_for_expect(v.filename)
            expect(page).to have_content correct_text_for_expect(v.content)
          end
        end
      end

      scenario 'wrong gist' do
        gist_id = wrong_gist_link_data[:url].split('/').last
        stub_gist_request(gist_id, 404)

        within('.new-answer') do
          fill_in 'Link name', with: wrong_gist_link_data[:name]
          fill_in 'Link URL', with: wrong_gist_link_data[:url]
          click_on 'Post Your Answer'
        end
        sleep(1)

        within('.answers') do
          wrong_gist_link_text = wrong_gist_link_data[:name] + '(invalid gist URL)'
          expect(page).to have_link wrong_gist_link_text, href: Link.format_url(wrong_gist_link_data[:url])
        end
      end
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

  describe "Answer's author edits their answer", js: true do
    scenario 'to try to remove links' do
      correct_link
      another_correct_link
      gist_plain_text_link

      visit question_path(question)

      within(".answers #answer-#{answer.id}") do
        click_on 'Edit'

        within(".answer-links #link-#{another_correct_link.id}") { click_link 'Remove' }

        sleep(1)
        expect(page).to have_link correct_link.name
        expect(page).to have_link gist_plain_text_link.name
        expect(page).to_not have_link another_correct_link.name
      end
    end

    scenario "to try to add links" do
      answer
      visit question_path(question)

      within(".answers #answer-#{answer.id}") do
        click_on 'Edit'

        click_link 'Add Link'
        fill_in 'Link name', with: correct_link_data[:name]
        fill_in 'Link URL', with: correct_link_data[:url]
        click_on 'Save'

        sleep(1)
        expect(page).to have_link correct_link_data[:name], href: Link.format_url(correct_link_data[:url])
      end
    end
  end
end
