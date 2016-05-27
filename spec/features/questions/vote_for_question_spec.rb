require_relative '../features_helper'
feature 'User is able to vote for question', %q{
  In order to change question rating
  As an authenticated user
  I want to be able to vote for question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user2) }

  describe 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'is able to vote up', js: true do
      within "#question#{question.id}" do
        click_on '+'

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_button('+', disabled: true)
        expect(page).to have_button('-', disabled: true)
        expect(page).to have_button('x', disabled: false)
      end
    end

    scenario 'is able to vote down', js: true do
      within "#question#{question.id}" do
        click_on '-'

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_button('+', disabled: true)
        expect(page).to have_button('-', disabled: true)
        expect(page).to have_button('x', disabled: false)
      end
    end

    scenario 'is able to remove vote', js: true do
      within "#question#{question.id}" do
        click_on '+'
        click_on 'x'

        expect(page).to have_content 'Rating: 0'
        expect(page).to have_button('+', disabled: false)
        expect(page).to have_button('-', disabled: false)
        expect(page).to have_button('x', disabled: true)
      end
    end
  end

  describe 'Authenticated question owner' do
    background do
      sign_in user2
      visit question_path(question)
    end

    scenario 'not able to vote for his question', js: true do
      within "#question#{question.id}" do
        expect(page).to have_content 'Rating:'
        expect(page).to_not have_button('+')
        expect(page).to_not have_button('-')
        expect(page).to_not have_button('x')
      end
    end
  end

  describe 'Not authenticated user' do
    scenario 'not able to vote for question' do
      visit question_path(question)
      expect(page).to have_content 'Rating:'
      expect(page).to_not have_button('+')
      expect(page).to_not have_button('-')
      expect(page).to_not have_button('x')
    end
  end
end
