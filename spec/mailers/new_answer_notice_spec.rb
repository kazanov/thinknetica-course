require "rails_helper"

RSpec.describe NewAnswerNotice, type: :mailer do
  describe '#new_answer' do
    let(:user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }
    let(:email) { described_class.new_answer(question, user.email) }

    it 'sends email' do
      expect { NewAnswerNotice.new_answer(question, user.email).deliver_now }
        .to change(ActionMailer::Base.deliveries, :count).by 1
    end

    it 'email contains question title' do
      expect(email).to have_content question.title
    end

    it 'receiver is author of answers question' do
      expect(email.to).to eq([answer.question.user.email])
    end
  end
end
