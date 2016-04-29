require 'rails_helper'
feature 'User is able to delete question', %q{
  In order to fix error question
  As an authenticated user
  I want to be able to delete question
} do
  given(:user) { create(:user) }
  given(:question) { build(:question) }

  context 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'Is able to delete his own question' do
      click_on 'Add new question'
      fill_in 'question[title]', with: question.title
      fill_in 'question[body]', with: question.body
      click_on 'Create question'

      expect(page).to have_content 'Delete question'
      click_on 'Delete question'

      expect(page).to eq root_path
    end

    # scenario 'Not able to delete another user question' do
    # end
  end

  # context 'Non-authenticated user' do
  #   scenario 'Not able to delete any questions' do
  #   end
  # end
end
