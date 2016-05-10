require 'rails_helper'
RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'check auhtor_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'should check if user is author of question' do
      expect(user).to be_author_of(question)
    end

    it 'should check if user is author of answer' do
      expect(user).to be_author_of(answer)
    end
  end
end
