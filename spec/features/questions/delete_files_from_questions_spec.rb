require_relative '../features_helper'
feature 'Delete files from question', %q{
  In order to fix my question
  As an author of question
  I want to be able to delete files from question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in user
  end

  scenario 'User delete files from question', js: true do
    click_on 'Add new question'
    fill_in 'question[title]', with: 'Sample title'
    fill_in 'question[body]', with: 'Sample body'
    attach_file 'question[attachments_attributes][0][file]', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    click_on 'Edit question'
    within '.question' do
      within '#attachments' do
        click_on 'remove file'
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end
  end
end
