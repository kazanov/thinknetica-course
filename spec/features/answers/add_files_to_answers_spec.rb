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

  scenario 'User adds files when create answers', js: true do
    fill_in 'answer[body]', with: 'Sample body'

    click_on 'add file'
    fields = all('input[type="file"]')
    fields[0].set("#{Rails.root}/spec/spec_helper.rb")
    fields[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Save'

    within '#answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
