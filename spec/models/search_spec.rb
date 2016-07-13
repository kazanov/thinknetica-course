require 'rails_helper'

RSpec.describe Search, type: :sphinx do
  describe '.find' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:comment) { create(:comment, commentable: question, user: user) }

    before(:each) do
      index
    end

    it 'returns results with type :all' do
      expect(Search.find('', 'all')).to match_array [question, answer, user, comment]
    end

    it 'returns results with type :questions' do
      expect(Search.find(question.title, 'questions')).to match_array [question]
    end

    it 'returns results with type :answers' do
      expect(Search.find(answer.body, 'answers')).to match_array [answer]
    end

    it 'returns results with type :comments' do
      expect(Search.find(user.email, 'users')).to match_array [user]
    end

    it 'returns results with type :users' do
      expect(Search.find(comment.text, 'comments')).to match_array [comment]
    end

    it 'returns empty array if type is invalid' do
      expect(Search.find('123', '123')).to match_array []
    end
  end
end
