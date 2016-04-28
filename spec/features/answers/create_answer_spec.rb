require 'rails_helper'

feature 'User is able to create answer', %q{
  In order to answer question
  As an user
  I want to be able to create answer
} do

  given(:question) { create(:question) }

  scenario 'User try to create answer' do
    question
    visit root_path
    click_on question.title
    click_on 'Add answer'
    fill_in 'answer[body]', with: 'Sample answer body'
    click_on 'Add answer'

    expect(page).to have_content 'Sample answer body'
  end
end
