require_relative '../features_helper'
feature 'User sign in', %q{
  In order to ask question
  As a user
  I want to be able to sign in
} do
  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Un-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'some_wrong_email@sample.com'
    fill_in 'Password', with: 'some_password'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
  end
end
