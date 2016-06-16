require_relative '../features_helper'
feature 'User sign up', %q{
  In order to ask question
  As a user
  I want to be able to sign up
} do
  given(:user) { create(:user) }
  given(:new_user) { build(:user) }

  scenario 'User try to sign up' do
    visit new_user_registration_path
    clear_emails
    fill_in 'user[email]', with: new_user.email
    fill_in 'user[password]', with: new_user.password
    fill_in 'user[password_confirmation]', with: new_user.password_confirmation
    within '.panel-body' do
      click_on 'Sign up'
    end

    open_email(new_user.email)
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed'

    visit new_user_session_path
    fill_in 'user[email]', with: new_user.email
    fill_in 'user[password]', with: new_user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Already registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    fill_in 'user[password_confirmation]', with: user.password_confirmation
    within '.panel-body' do
      click_on 'Sign up'
    end

    expect(page).to have_content 'has already been taken'
  end
end
