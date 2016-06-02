require_relative '../features_helper'
feature 'User is able to edit question', %q{
  In order to fix mistake
  As an author of question
  I want to edit my question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'Authenticated question owner' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'try to edit his question with valid parameters', js: true do
      click_on 'Edit question'
      fill_in 'question[title]', with: 'edited title'
      fill_in 'question[body]', with: 'edited body'
      click_on 'Save'

      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'try to edit his question with invalid parameters', js: true do
      within "#question#{question.id}" do
        click_on 'Edit question'
        fill_in 'question[title]', with: ''
        fill_in 'question[body]', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end
  end

  context 'Authenticated not question owner' do
    before do
      sign_in user2
      visit question_path(question)
    end

    scenario 'not able to edit other user question', js: true do
      within "#question#{question.id}" do
        expect(page).to_not have_content 'Edit question'
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'not able to edit question' do
      visit question_path(question)
      expect(page).to_not have_link 'Edit question'
    end
  end
end
