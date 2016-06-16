require_relative '../features_helper'
feature 'Facebook sign in', %q{
  In order to ask question
  As a user
  I want to be able to sign in with Facebook
} do
  scenario 'User is able to sign in with valid credentials' do
    visit new_user_session_path
    mock_auth_valid_hash('facebook', 'sample@sample.com')
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario 'User not able sign in with valid invalid credentials' do
    visit new_user_session_path
    mock_auth_invalid_hash('facebook')
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Could not authenticate you because of invalid credentials'
  end
end
