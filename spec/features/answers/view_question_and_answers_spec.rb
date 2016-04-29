require 'rails_helper'
feature 'User is able to view question and answers', %q{
  In order to get solution
  As an user
  I want to be able to view question and answers
} do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'User try to view question and answers' do
    question
    answer
    visit root_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question.answers.first.body
  end
end
