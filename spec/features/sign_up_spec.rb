require 'rails_helper'

feature 'User can sign up', %q(
        In order to use full functionality of service
        As an unregistered user
        I'd like to able to sign up
) do
  given(:userdata) { attributes_for(:user) }

  background { visit new_user_registration_path }

  scenario 'user, whose data is not yet in database, tries to sign up' do
    fill_in 'Email', with: userdata[:email]
    fill_in 'Password', with: userdata[:password]
    fill_in 'Password confirmation', with: userdata[:password]
    click_on 'Sign up'

    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end

  scenario 'user, whose data is already in database, tries to register' do
    user = create(:user)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content "Email has already been taken"
  end

  scenario 'user entered mismatched passwords while trying to sign up' do
    fill_in 'Email', with: userdata[:email]
    fill_in 'Password', with: userdata[:password]
    fill_in 'Password confirmation', with: 'wrong' + userdata[:password]
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
