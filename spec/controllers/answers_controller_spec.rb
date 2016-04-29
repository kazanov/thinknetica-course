require 'rails_helper'
RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before do
      sign_in user
      get :new, question_id: question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { sign_in user }
      let(:post_create) do
        post :create, question_id: question.id, answer: attributes_for(:answer)
      end

      it 'increase the answers count of question' do
        expect { post_create }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post_create
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'check the question of an answer' do
        post_create
        expect(assigns(:answer).question).to match question
      end
    end

    context 'with invalid answer' do
      before { sign_in user }
      let(:post_create) do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
      end

      it 'does not save the answer' do
        expect { post_create }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post_create
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated answer owner' do
      before { sign_in answer.user }
      it 'is able to delete his own answer' do
        expect { delete :destroy, question_id: answer.question, id: answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question path' do
        answer
        delete :destroy, question_id: answer.question, id: answer
        expect(response).to redirect_to answer.question
      end
    end

    context 'authenticated not answer owner' do
      before do
        sign_in user
        answer
      end
      it 'is not able to delete another user answer' do
        expect { delete :destroy, question_id: answer.question, id: answer }.to_not change(question.answers, :count)
      end
    end

    context 'non-authenticated user' do
      it 'is not able to delete answers' do
        answer
        expect { delete :destroy, question_id: answer.question, id: answer }.to_not change(Answer, :count)
      end
    end
  end
end
