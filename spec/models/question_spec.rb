require 'rails_helper'
RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should validate_length_of(:title).is_at_most(140) }

  it { should have_many(:answers).dependent(:destroy) }

  it { should belong_to :user }
  it { should have_db_index :user_id }

  it { should have_many(:subscriptions).dependent(:destroy) }

  it_behaves_like 'Votable'
  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'

  describe '#subscribe_author' do
    let(:user) { create :user }
    let(:question) { build(:question, user: user) }

    it 'subscribes author to question' do
      expect { question.save }.to change(user.subscriptions, :count).by 1
    end
  end
end
