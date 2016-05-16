require 'rails_helper'
RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should belong_to :question }
  it { should validate_presence_of :question_id }
  it { should have_db_index :question_id }

  it { should belong_to :user }
  it { should have_db_index :user_id }

  describe 'make_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question, user: user, best: false) }
    let!(:answer2) { create(:answer, question: question, user: user, best: true) }

    it 'should change answer.best to true' do
      expect { answer1.make_best! }.to change { answer1.best }.from(false).to(true)
    end

    it 'should be only one best answer' do
      answer1.make_best!
      expect(answer1.best).to be true

      answer2.reload
      expect(answer2.best).to be false
    end
  end
end
