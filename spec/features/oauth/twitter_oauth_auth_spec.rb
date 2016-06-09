require_relative '../features_helper'
feature 'Twitter sign in', %q{
  In order to ask question
  As a user
  I want to be able to sign in with Twitter
} do
  scenario 'User is able to sign in with valid credentials' do
    visit new_user_session_path
    mock_auth_valid_hash('twitter', nil)
    click_on 'Sign in with Twitter'
    fill_in 'auth[info][email]', with: 'sample@sample.com'
    click_on 'Send'

    open_email 'sample@sample.com'
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed'

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario 'User not able sign in with valid invalid credentials' do
    visit new_user_session_path
    mock_auth_invalid_hash('twitter')
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
  end
end
