require_relative '../features_helper'
feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of question
  I want to be able add files to question
} do

  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds file when create questions' do
    fill_in 'question[title]', with: 'Sample title'
    fill_in 'question[body]', with: 'Sample body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    expect(page).to have_link 'spec_helper.rb'
  end
end
