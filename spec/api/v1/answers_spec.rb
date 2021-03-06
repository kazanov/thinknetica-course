require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 5, question: question) }

      before { get '/api/v1/answers', format: :json, access_token: access_token.token }

      it 'returns 200 status if access_token is valid' do
        expect(response.status).to eq 200
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(5)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options={})
      get '/api/v1/answers', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:access_token) { create(:access_token) }
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
    let!(:attachments) { create_list(:attachment, 2, attachable: answer) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get api_v1_answer_path(answer), format: :json, access_token: access_token.token }

      it 'returns 200 status if access_token is valid' do
        expect(response.status).to eq 200
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      it 'answer object contains comments' do
        expect(response.body).to have_json_size(3).at_path('comments')
      end

      %w(id text created_at updated_at commentable_id commentable_type user_id).each do |attr|
        it "answer comment object contains #{attr}" do
          expect(response.body).to be_json_eql(comments.last.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
        end
      end

      it 'answer object contains attachments' do
        expect(response.body).to have_json_size(2).at_path('attachments')
      end

      it 'answer attachment have file url' do
        expect(response.body).to be_json_eql(attachments.last.file.url.to_json).at_path('attachments/0/file/url')
      end
    end

    def do_request(options={})
      get api_v1_answer_path(answer), { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question) { create(:question) }

    context 'valid attributes' do
      it 'creates and saves question in db' do
        expect {
          post api_v1_answers_path, format: :json, access_token: access_token.token,
                                    answer: attributes_for(:answer),
                                    question_id: question.id
        }.to change(Answer, :count).by(1)
      end

      it 'connects answer and user' do
        post api_v1_answers_path, format: :json, access_token: access_token.token,
                                  answer: attributes_for(:answer),
                                  question_id: question.id
        expect(assigns(:answer).user_id).to match user.id
      end

      it 'connects answer and question' do
        post api_v1_answers_path, format: :json, access_token: access_token.token,
                                  answer: attributes_for(:answer),
                                  question_id: question.id
        expect(assigns(:answer).question_id).to match question.id
      end

      it 'returns 201 status' do
        post api_v1_answers_path, format: :json, access_token: access_token.token,
                                  answer: attributes_for(:answer),
                                  question_id: question.id
        expect(response.status).to eq 201
      end
    end

    context 'invalid attributes' do
      it 'not saves answer in db' do
        expect {
          post api_v1_answers_path, format: :json, access_token: access_token.token,
                                    answer: attributes_for(:invalid_answer),
                                    question_id: question.id
        }.to_not change(Answer, :count)
      end

      it 'returns 422 status' do
        post api_v1_answers_path, format: :json, access_token: access_token.token,
                                  answer: attributes_for(:invalid_answer),
                                  question_id: question.id
        expect(response.status).to eq 422
      end
    end
  end
end
