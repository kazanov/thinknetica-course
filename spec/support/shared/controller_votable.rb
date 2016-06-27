shared_examples_for 'Controller votable' do
  describe 'POST #vote_up' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    before { user.id = parent.user_id }

    context 'authenticated not votable owner' do
      before do
        sign_in user2
      end

      it 'upvote votable' do
        expect(parent.rating).to eq 0
        post :vote_up, model: parent, id: parent.id, rating: 1, format: :json
        expect(parent.rating).to eq 1
      end
    end

    context 'authenticated votable owner' do
      before do
        sign_in user
      end

      it 'does not upvote votable and return status 403' do
        expect(parent.rating).to eq 0
        post :vote_up, model: parent, id: parent.id, rating: 1, format: :json
        expect(parent.rating).to eq 0
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #vote_down' do
    context 'authenticated not votable owner' do
      before do
        sign_in user2
      end

      it 'downvote votable' do
        expect(parent.rating).to eq 0
        post :vote_down, model: parent, id: parent.id, rating: -1, format: :json
        expect(parent.rating).to eq(-1)
      end
    end

    context 'authenticated votable owner' do
      before do
        sign_in user
      end

      it 'does not downvote votable and return status 403' do
        expect(parent.rating).to eq 0
        post :vote_down, model: parent, id: parent.id, rating: -1, format: :json
        expect(parent.rating).to eq 0
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE #remove_vote' do
    context 'authenticated not votable owner' do
      before do
        sign_in user2
      end

      it 'remove vote for votable' do
        post :vote_up, model: parent, id: parent.id, rating: 1, format: :json
        expect(parent.rating).to eq 1
        post :remove_vote, model: parent, id: parent.id, rating: 0, format: :json
        expect(parent.rating).to eq 0
      end
    end

    context 'authenticated votable owner' do
      before do
        sign_in user
      end

      it 'does not remove vote for votable and return status 403' do
        post :remove_vote, model: parent, id: parent.id, rating: -1, format: :json
        expect(response.status).to eq 403
      end
    end
  end
end
