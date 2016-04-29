require 'rails_helper'

feature 'User is able to create question', %q{
  In order to get solution
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }
  given(:question) { build(:question) }

  scenario 'Authenticated user try to create question' do
    visit root_path
    sign_in(user)
    click_on 'Add new question'
    fill_in 'question[title]', with: question.title
    fill_in 'question[body]', with: question.body
    click_on 'Create question'

    expect(page).to have_content question.title
  end

  scenario 'Non-authenticated user try to create question' do
    visit root_path
    click_on 'Add new question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
