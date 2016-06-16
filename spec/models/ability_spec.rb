require 'rails_helper'
describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:own_question) { create(:question, user: user) }
    let(:other_user_question) { create(:question, user: other_user) }
    let(:own_answer) { create(:answer, question: own_question, user: user) }
    let(:other_user_answer) { create(:answer, question: other_user_question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }

    it { should be_able_to :update, own_question, user: user }
    it { should_not be_able_to :update, other_user_question, user: user }
    it { should be_able_to :update, own_answer, user: user }
    it { should_not be_able_to :update, other_user_answer, user: user }

    it { should be_able_to :destroy, own_question, user: user }
    it { should_not be_able_to :destroy, other_user_question, user: user }
    it { should be_able_to :destroy, own_answer, user: user }
    it { should_not be_able_to :destroy, other_user_answer, user: user }

    it { should be_able_to :best_answer, own_answer, user: user }
    it { should_not be_able_to :best_answer, other_user_answer, user: user }

    it { should be_able_to :vote_up, other_user_question, user: user }
    it { should_not be_able_to :vote_up, own_question, user: user }
    it { should be_able_to :vote_up, other_user_answer, user: user }
    it { should_not be_able_to :vote_up, own_answer, user: user }

    it { should be_able_to :vote_down, other_user_question, user: user }
    it { should_not be_able_to :vote_down, own_question, user: user }
    it { should be_able_to :vote_down, other_user_answer, user: user }
    it { should_not be_able_to :vote_down, own_answer, user: user }
  end
end
