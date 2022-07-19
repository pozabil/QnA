require 'rails_helper'

feature 'User can sign out', %q(
        In order to end session
        As an authenticated user
        I'd like to able to sign out
) do
  given(:user) { create(:user) }

  background do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  scenario 'authenticated user tries to sign out' do
    click_on I18n.t('sign_out')

    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end
end
