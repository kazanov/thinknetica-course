require_relative '../features_helper'
feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I want to be able add files to answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User adds file when create answers', js: true do
    fill_in 'answer[body]', with: 'Sample body'
    attach_file 'answer[attachments_attributes][0][file]', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    within '#answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
