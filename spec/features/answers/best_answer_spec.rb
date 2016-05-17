require_relative '../features_helper'
feature 'Question author is able to select best answer', %q{
  In order to set question solution
  As an author of question
  I want to select best answer
} do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:answer2) { create(:answer, question: question, user: user2) }

  context 'Question author' do
    before do
      sign_in(user)
      visit question_path question
    end

    scenario 'is able to select best answer', js: true do
      expect(page).to_not have_content 'SOLUTION:'
      within '#answers' do
        within "#answer-#{answer2.id}" do
          click_on 'Solution!'

          expect(page).to have_content 'SOLUTION:'
        end
      end
    end

    scenario 'is able to select another best answer', js: true do
      within '#answers' do
        within "#answer-#{answer2.id}" do
          click_on 'Solution!'
        end

        within "#answer-#{answer.id}" do
          click_on 'Solution!'

          expect(page).to have_content 'SOLUTION:'
        end

        within "#answer-#{answer2.id}" do
          expect(page).to_not have_content 'SOLUTION:'
        end
      end
    end

    scenario 'Best answer showing first', js: true do
      expect(first('#answers div')).to have_content answer.body

      within '#answers' do
        within "#answer-#{answer2.id}" do
          click_on 'Solution!'
        end
      end

      expect(first('#answers div')).to have_content answer2.body
    end
  end

  context 'Authenticated not question owner' do
    scenario 'not able to select best answer' do
      sign_in(user2)
      visit question_path question

      expect(page).to_not have_content 'Solution!'
    end
  end

  context 'Non-authenticated not question owner' do
    scenario 'not able to select best answer' do
      visit question_path question

      expect(page).to_not have_content 'Solution!'
    end
  end
end
