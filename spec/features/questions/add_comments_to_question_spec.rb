require_relative '../features_helper'
feature 'User is able to comment question', %q{
  In order to ask details
  As an authenticated user
  I want to be able to comment question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'Try to comment question with valid parameters', js: true do
      within "#question#{question.id}" do
        click_on 'Add comment'
        fill_in 'comment[text]', with: 'Sample comment'
        click_on 'Save'

        expect(page).to have_content 'Sample comment'
      end
    end

    scenario 'Try to comment question with invalid parameters', js: true do
      within "#question#{question.id}" do
        click_on 'Add comment'
        click_on 'Save'

        expect(page).to have_content "Text can't be blank"
      end
    end
  end

  scenario 'Non-authenticated user try to comment question' do
    visit question_path(question)
    within "#question#{question.id}" do
      expect(page).to_not have_link 'Add comment'
    end
  end
end
