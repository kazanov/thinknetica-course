require_relative '../features_helper'
feature 'User is able to comment answer', %q{
  In order to ask details
  As an authenticated user
  I want to be able to comment answer
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'Try to comment answer with valid parameters', js: true do
      within "#answer#{answer.id}" do
        click_on 'Add comment'
        fill_in 'comment[text]', with: 'Sample comment'
        click_on 'Save'

        expect(page).to have_content 'Sample comment'
      end
    end

    scenario 'Try to comment answer with invalid parameters', js: true do
      within "#answer#{answer.id}" do
        click_on 'Add comment'
        click_on 'Save'

        expect(page).to have_content "Text can't be blank"
      end
    end
  end

  scenario 'Non-authenticated user try to comment answer' do
    visit question_path(question)
    within "#answer#{answer.id}" do
      expect(page).to_not have_link 'Add comment'
    end
  end
end
