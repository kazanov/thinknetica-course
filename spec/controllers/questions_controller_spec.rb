require 'rails_helper'
RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    context 'authenticated user' do
      before do
        sign_in user
        get :new
      end

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new Question
      end

      it 'builds new attachment for question' do
        expect(assigns(:question).attachments.first).to be_a_new Attachment
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end
    context 'non-authenticated user' do
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to_not be_a_new Question
      end

      it 'renders new view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'authenticated user' do
      before { sign_in user }
      context 'with valid attributes' do
        it 'saves new question in db' do
          expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end

        it 'connects user and question' do
          post :create, question: attributes_for(:question)
          expect(assigns(:question).user_id).to match user.id
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end
      end
    end

    context 'non-authenticated user' do
      context 'with valid attributes' do
        it 'does not saves new question in db' do
          expect { post :create, question: attributes_for(:question) }.to_not change(Question, :count)
        end

        it 'redirects to user sign in' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end

        it 'redirects to user sign in' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    context 'question owner' do
      before { sign_in question.user }
      it 'is able to delete his own question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirects to root path' do
        question
        delete :destroy, id: question

        expect(response).to redirect_to root_path
      end
    end

    context 'not question owner' do
      before { sign_in user2 }
      it 'is not able to delete another user question' do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'authenticated question owner' do
      before do
        sign_in user
      end

      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, user: user, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'authenticated not question owner' do
      before do
        sign_in user2
      end

      it 'not change question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, user: user2, format: :js
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end

      it 'render update template' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'not authenticated user' do
      it 'not change question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, user: user2, format: :js
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end
end
