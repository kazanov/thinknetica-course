require_relative '../features_helper'
feature 'Authenticated user is able to subscribe to question', %q{
  In order to recieve new answers
  As an authenticated user
  I want to be able to subscribe to question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'Authenticated user not question author' do
    before do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'Is able able to subscribe to question', js: true do
      click_on 'Subscribe'
      expect(page).to_not have_button 'Subscribe'
      expect(page).to have_content 'Successfully subscribed!'
    end
  end

  context 'Question author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Automatically subscribes to his question', js: true do
      expect(page).to have_button 'Unsubscribe'
    end
  end

  context 'Non-authenticated user' do
    scenario 'Not able to subscribe to questions' do
      visit question_path(question)
      expect(page).to_not have_button 'Subscribe'
      expect(page).to_not have_button 'Unsubscribe'
    end
  end
end
