require_relative '../features_helper'
feature 'User is able to view questions list', %q{
  In order to get solution
  As an user
  I want to be able to view questions list
} do
  given(:user) { create(:user) }
  given(:question) { create_list(:question, 5) }

  scenario 'User try to view questions list' do
    question
    visit root_path

    question.each do |question|
      expect(page).to have_content question.title
    end
  end
end
