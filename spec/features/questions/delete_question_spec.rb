require_relative '../features_helper'
feature 'User is able to delete question', %q{
  In order to fix error question
  As an user
  I want to be able to delete question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Is able to delete his own question' do
    sign_in(question.user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to_not have_content question.title
  end

  scenario 'Not able to delete another user question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end

  context 'Non-authenticated user' do
    scenario 'Not able to delete any questions' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete question'
    end
  end
end
