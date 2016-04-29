require 'rails_helper'
feature 'User is able to view questions list', %q{
  In order to get solution
  As an user
  I want to be able to view questions list
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User try to view questions list' do
    question
    visit root_path

    expect(page).to have_content question.title
  end
end
