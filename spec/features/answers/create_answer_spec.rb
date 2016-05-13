require_relative '../features_helper'
feature 'User is able to create answer', %q{
  In order to answer question
  As an authenticated user
  I want to be able to create answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path question
    end

    scenario 'Try to create answer with valid parameters', js: true do
      fill_in 'answer[body]', with: 'Sample answer'
      click_on 'Save answer'

      expect(current_path).to eq question_path(question)
      within '#answers' do
        expect(page).to have_content 'Sample answer'
      end
    end

    scenario 'Try to create answer with invalid parameters', js: true do
      click_on 'Save answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path question
    click_on 'Save answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
