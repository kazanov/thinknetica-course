require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/answers', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/answers', format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 5, question: question) }

      before { get '/api/v1/answers', format: :json, access_token: access_token.token }

      it 'returns 200 status if access_token is valid' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(5)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  # describe 'GET /show' do
  #   let(:access_token) { create(:access_token) }
  #   let(:user) { create(:user) }
  #   let!(:question) { create(:question, user: user) }
  #   let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
  #   let!(:attachments) { create_list(:attachment, 2, attachable: question) }
  #
  #   context 'unauthorized' do
  #     it 'returns 401 status if there is no access_token' do
  #       get api_v1_question_path(question), format: :json
  #       expect(response.status).to eq 401
  #     end
  #
  #     it 'returns 401 status if access_token is invalid' do
  #       get api_v1_question_path(question), format: :json, access_token: '123456'
  #       expect(response.status).to eq 401
  #     end
  #   end
  #
  #   context 'authorized' do
  #     before { get api_v1_question_path(question), format: :json, access_token: access_token.token }
  #
  #     it 'returns 200 status if access_token is valid' do
  #       expect(response.status).to eq 200
  #     end
  #
  #     %w(id title body created_at updated_at).each do |attr|
  #       it "question object contains #{attr}" do
  #         expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
  #       end
  #     end
  #
  #     it 'contains comments in question' do
  #       expect(response.body).to have_json_size(3).at_path('comments')
  #     end
  #
  #     %w(id text created_at updated_at commentable_id commentable_type user_id).each do |attr|
  #       it "question comment object contains #{attr}" do
  #         expect(response.body).to be_json_eql(comments.last.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
  #       end
  #     end
  #
  #     it 'contains attachments in question' do
  #       expect(response.body).to have_json_size(2).at_path('attachments')
  #     end
  #
  #     it 'question attachment have file url' do
  #       expect(response.body).to be_json_eql(attachments.last.file.url.to_json).at_path('attachments/0/file/url')
  #     end
  #   end
  # end
end
