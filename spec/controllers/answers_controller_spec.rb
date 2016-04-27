require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  # describe 'GET #index' do
  #   let(:answers) { create_list(:answer, 2, question: question) }
  #   before { get :index, question_id: question }
  #
  #   it 'populates an array of all answers' do
  #     expect(assigns(:answers)).to match_array(answers)
  #   end
  # end

  describe 'GET #new' do
    before { get :new, question_id: question }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
       let(:post_create) do
         post :create, question_id: question.id, answer: attributes_for(:answer)
       end

      it 'saves new answer of a question in db' do
        expect { post_create }.to change(Answer, :count).by(1)
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

    context 'with no body answer' do
      let(:post_create) do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
      end

      it 'does not save new answer of a question in db' do
        expect { post_create }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post_create
        expect(response).to render_template :new
      end
    end

  end

end
