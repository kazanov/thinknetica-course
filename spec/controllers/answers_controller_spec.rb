require 'rails_helper'
RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:answer2) { create(:answer, question: question, user: user2) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { sign_in user }
      let(:post_create) do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
      end

      it 'increase the answers count of question' do
        expect { post_create }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post_create
        expect(response).to render_template 'create'
      end

      it 'check the question of an answer' do
        post_create
        expect(assigns(:answer).question).to match question
      end

      it 'connects user and answer' do
        post_create
        expect(assigns(:answer).user_id).to match user.id
      end
    end

    context 'with invalid answer' do
      before { sign_in user }
      let(:post_create) do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js
      end

      it 'does not save the answer' do
        expect { post_create }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post_create
        expect(response).to render_template 'create'
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'change answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body' }, user: user, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'assigns answer to question' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to match question
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated answer owner' do
      before { sign_in answer.user }
      it 'is able to delete his own answer' do
        expect { delete :destroy, question_id: answer.question, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question path' do
        delete :destroy, question_id: answer.question, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'authenticated not answer owner' do
      before do
        sign_in user2
      end
      it 'is not able to delete another user answer' do
        expect { delete :destroy, question_id: answer.question, id: answer, format: :js }.to_not change(Answer, :count)
      end
    end

    context 'non-authenticated user' do
      it 'is not able to delete answers' do
        expect { delete :destroy, question_id: answer.question, id: answer, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'POST #best_answer' do
    context 'authenticated question owner' do
      before do
        sign_in user
      end

      it 'assigns the requested answer to @answer' do
        post :best_answer, question_id: question.id, id: answer2
        expect(assigns(:answer)).to eq answer2
      end

      it 'redirects to question' do
        post :best_answer, question_id: question.id, id: answer2
        expect(response).to redirect_to answer2.question
      end

      it 'is able to select best answer' do
        expect(answer2.best).to eq false
        post :best_answer, question_id: question.id, id: answer2
        answer2.reload
        expect(answer2.best).to eq true
      end
    end

    context 'authenticated not question owner' do
      before do
        sign_in user2
      end

      it 'not able to select best answer' do
        expect(answer.best).to eq false
        post :best_answer, question_id: question.id, id: answer
        answer.reload
        expect(answer.best).to eq false
      end
    end

    context 'non-authenticated user' do
      it 'not able to select best answer' do
        expect(answer.best).to eq false
        post :best_answer, question_id: question.id, id: answer
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end
end
