require_relative '../features_helper'
feature 'Authenticated user is able to unsubscribe to question', %q{
  In order to stop recieve new answers
  As an authenticated user
  I want to be able to unsubscribe to question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:subscription) { create(:subscription, question: question, user: user2) }

  context 'Authenticated user not question author' do
    before do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'Is able able to unsubscribe from question', js: true do
      click_on 'Unsubscribe'
      expect(page).to_not have_button 'Unsubscribe'
      expect(page).to have_content 'Successfully unsubscribed!'
    end
  end

  context 'Question author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Is able able to unsubscribe from his question', js: true do
      expect(page).to have_button 'Unsubscribe'
      click_on 'Unsubscribe'
      expect(page).to_not have_button 'Unsubscribe'
      expect(page).to have_content 'Successfully unsubscribed!'
    end
  end

  context 'Non-authenticated user' do
    scenario 'Not able to unsubscribe from questions' do
      visit question_path(question)
      expect(page).to_not have_button 'Subscribe'
      expect(page).to_not have_button 'Unsubscribe'
    end
  end
end
