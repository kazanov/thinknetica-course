require_relative '../features_helper'
feature 'User is able to search', %q{
  In order to find information
  As an user
  I want to be able to find information
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:question_comment) { create(:comment, commentable: question, user: user) }
  given!(:answer_comment) { create(:comment, commentable: answer, user: user) }

  context 'Search' do
    before do
      index
      visit question_path(question)
    end

    scenario 'type :all', type: :sphinx do
      fill_in 'query', with: ''
      select 'all', from: 'type'
      click_on 'Search'
      expect(page).to have_content question.title
      expect(page).to have_content user.email
      expect(page).to have_content answer.body
      expect(page).to have_content question_comment.text
      expect(page).to have_content answer_comment.text
    end

    scenario 'type :questions', type: :sphinx do
      fill_in 'query', with: question.body
      select 'questions', from: 'type'
      click_on 'Search'
      expect(page).to have_content question.title
      expect(page).to_not have_content user.email
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content question_comment.text
    end

    scenario 'type :answers', type: :sphinx do
      fill_in 'query', with: answer.body
      select 'answers', from: 'type'
      click_on 'Search'
      expect(page).to have_content answer.body
      expect(page).to_not have_content user.email
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question_comment.text
      expect(page).to_not have_content answer_comment.text
    end

    scenario 'type :comments', type: :sphinx do
      fill_in 'query', with: answer_comment.text
      select 'comments', from: 'type'
      click_on 'Search'
      expect(page).to have_content answer_comment.text
      expect(page).to_not have_content user.email
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question_comment.text
      expect(page).to_not have_content answer.body
    end

    scenario 'type :users', type: :sphinx do
      fill_in 'query', with: user.email
      select 'users', from: 'type'
      click_on 'Search'
      expect(page).to have_content user.email
      expect(page).to_not have_content answer_comment.text
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question_comment.text
      expect(page).to_not have_content answer.body
    end
  end
end
