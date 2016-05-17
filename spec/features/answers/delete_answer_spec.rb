require_relative '../features_helper'
feature 'User is able to delete answer', %q{
  In order to fix error answer
  As an user
  I want to be able to delete answer
} do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  context 'Authenticated user' do
    scenario 'Is able to delete his own answer', js: true do
      sign_in(answer.user)
      visit question_path(answer.question)
      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
    end

    scenario 'Not able to delete another user answer' do
      sign_in(user)
      visit question_path(answer.question)
      expect(page).to_not have_content 'Delete answer'
    end
  end

  context 'Non-authenticated user' do
    scenario 'Not able to delete any questions' do
      visit question_path(answer.question)
      expect(page).to_not have_content 'Delete answer'
    end
  end
end
