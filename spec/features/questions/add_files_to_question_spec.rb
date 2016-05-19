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

  scenario 'User adds files when create questions', js: true do
    fill_in 'question[title]', with: 'Sample title'
    fill_in 'question[body]', with: 'Sample body'
    click_on 'add file'
    fields = all('input[type="file"]')
    fields[0].set("#{Rails.root}/spec/spec_helper.rb")
    fields[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Save'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
