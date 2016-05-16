require_relative '../features_helper'
feature 'User is able to edit answer', %q{
  In order to fix mistake
  As an author of question
  I want to edit my answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:user2) { create(:user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }

  scenario 'Non-authenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'try to edit his answer with valid parameters', js: true do
      within '#answers' do
        click_on 'Edit answer'
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit his answer with invalid parameters', js: true do
      within '#answers' do
        click_on 'Edit answer'
        fill_in 'answer[body]', with: ''
        click_on 'Save answer'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'try to edit other users answer' do
      within '#answer-2' do
        expect(page).to have_content answer2.body
        expect(page).to_not have_link 'Edit answer'
      end
    end
  end
end
