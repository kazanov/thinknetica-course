require_relative '../features_helper'
feature 'Delete files from answer', %q{
  In order to fix my answer
  As an author of answer
  I want to be able to delete files from answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User delete files from answer', js: true do
    fill_in 'answer[body]', with: 'Sample body'
    attach_file 'answer[attachments_attributes][1][file]', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save answer'

    within '#answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'

      click_on 'Edit answer'
      within '#attachments' do
        click_on 'remove file'
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end
  end
end
