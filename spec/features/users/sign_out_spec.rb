require 'rails_helper'

feature 'User sign out', %q{
  In order to finish work with service
  As a user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)
    sign_out

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq(root_path)
  end
end
