require 'rails_helper'
RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create (question)' do
    context 'with valid attributes' do
      before { sign_in user }
      let(:question_comment_create) do
        post :create, commentable: 'questions', question_id: question.id, comment: attributes_for(:comment), format: :js
      end

      it 'increase the comments count of question' do
        expect { question_comment_create }.to change(question.comments, :count).by(1)
      end

      it 'increase the comments count of user' do
        expect { question_comment_create }.to change(user.comments, :count).by(1)
      end

      it 'check the question of comment' do
        question_comment_create
        expect(assigns(:commentable)).to match question
      end

      it 'connects user and comment' do
        question_comment_create
        expect(assigns(:comment).user_id).to match user.id
      end
    end

    context 'with invalid attributes' do
      before { sign_in user }
      let(:question_invalid_comment_create) do
        post :create, commentable: 'questions', question_id: question.id, comment: attributes_for(:invalid_comment), format: :js
      end

      it 'doesn not increase the comments count of question' do
        expect { question_invalid_comment_create }.to_not change(question.comments, :count)
      end
    end
  end

  describe 'POST #create (answer)' do
    context 'with valid attributes' do
      before { sign_in user }
      let(:question_comment_create) do
        post :create, commentable: 'answers', answer_id: answer.id, comment: attributes_for(:comment), format: :js
      end

      it 'increase the comments count of answer' do
        expect { question_comment_create }.to change(answer.comments, :count).by(1)
      end

      it 'increase the comments count of user' do
        expect { question_comment_create }.to change(user.comments, :count).by(1)
      end

      it 'check the answer of comment' do
        question_comment_create
        expect(assigns(:commentable)).to match answer
      end

      it 'connects user and comment' do
        question_comment_create
        expect(assigns(:comment).user_id).to match user.id
      end
    end

    context 'with invalid attributes' do
      before { sign_in user }
      let(:question_invalid_comment_create) do
        post :create, commentable: 'answer', answer_id: answer.id, comment: attributes_for(:invalid_comment), format: :js
      end

      it 'doesn not increase the comments count of answer' do
        expect { question_invalid_comment_create }.to_not change(answer.comments, :count)
      end
    end
  end
end
