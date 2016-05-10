require 'rails_helper'
feature 'User sign up', %q{
  In order to ask question
  As a user
  I want to be able to sign up
} do
  given(:user) { create(:user) }
  given(:new_user) { build(:user) }

  scenario 'User try to sign up' do
    visit new_user_registration_path
    fill_in 'user[email]', with: new_user.email
    fill_in 'user[password]', with: new_user.password
    fill_in 'user[password_confirmation]', with: new_user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Already registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    fill_in 'user[password_confirmation]', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'has already been taken'
  end
end
