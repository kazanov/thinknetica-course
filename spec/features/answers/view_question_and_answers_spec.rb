require_relative '../features_helper'
feature 'User is able to view question and answers', %q{
  In order to get solution
  As an user
  I want to be able to view question and answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create_list(:answer, 5, question: question) }

  scenario 'User try to view question and answers' do
    question
    answer
    visit root_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
