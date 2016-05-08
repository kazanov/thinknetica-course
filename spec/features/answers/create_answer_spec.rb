require 'rails_helper'
feature 'User is able to create answer', %q{
  In order to answer question
  As an authenticated user
  I want to be able to create answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path question
    end

    scenario 'Try to create answer with valid parameters' do
      fill_in 'answer[body]', with: 'Sample answer'
      click_on 'Add answer'

      expect(page).to have_content 'Sample answer'
    end

    scenario 'Try to create answer with invalid parameters' do
      click_on 'Add answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path question
    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
