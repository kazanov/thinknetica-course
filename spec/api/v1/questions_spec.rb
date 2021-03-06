require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 5) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status if access_token is valid' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(5)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options={})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:access_token) { create(:access_token) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get api_v1_question_path(question), format: :json, access_token: access_token.token }

      it 'returns 200 status if access_token is valid' do
        expect(response.status).to eq 200
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      it 'question object contains comments' do
        expect(response.body).to have_json_size(3).at_path('comments')
      end

      %w(id text created_at updated_at commentable_id commentable_type user_id).each do |attr|
        it "question comment object contains #{attr}" do
          expect(response.body).to be_json_eql(comments.last.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
        end
      end

      it 'question object contains attachments' do
        expect(response.body).to have_json_size(2).at_path('attachments')
      end

      it 'question attachment have file url' do
        expect(response.body).to be_json_eql(attachments.last.file.url.to_json).at_path('attachments/0/file/url')
      end
    end

    def do_request(options={})
      get api_v1_question_path(question), { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'valid attributes' do
      it 'creates and saves question in db' do
        expect {
          post api_v1_questions_path, format: :json,
                                      access_token: access_token.token,
                                      question: attributes_for(:question)
        }.to change(Question, :count).by 1
      end

      it 'connects user and question' do
        post api_v1_questions_path, format: :json,
                                    access_token: access_token.token,
                                    question: attributes_for(:question)
        expect(assigns(:question).user_id).to match user.id
      end

      it 'returns 201 status' do
        post api_v1_questions_path, format: :json,
                                    access_token: access_token.token,
                                    question: attributes_for(:question)
        expect(response.status).to eq 201
      end
    end

    context 'invalid attributes' do
      it 'not saves question in db' do
        expect {
          post api_v1_questions_path, format: :json,
                                      access_token: access_token.token,
                                      question: attributes_for(:invalid_question)
        }.to_not change(Question, :count)
      end

      it 'returns 422 status' do
        post api_v1_questions_path, format: :json,
                                    access_token: access_token.token,
                                    question: attributes_for(:invalid_question)
        expect(response.status).to eq 422
      end
    end
  end
end
