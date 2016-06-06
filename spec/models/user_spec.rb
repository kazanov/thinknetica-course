require 'rails_helper'
RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }

  describe '#check auhtor_of?' do
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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end
  end
end
