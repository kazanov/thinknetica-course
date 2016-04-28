require 'rails_helper'

feature 'User is able to create question', %q{
  In order to get solution
  As a user
  I want to be able to ask question
} do

  scenario 'User try to create question' do
    visit root_path
    click_on 'Add new question'

    expect(page).to have_content 'Add question'
  end
end
