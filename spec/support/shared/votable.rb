shared_examples_for 'Votable' do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:votable) { create(described_class) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#vote_up' do
    it 'should change votes count' do
      expect { votable.vote_up(user) }.to change(votable.votes, :count).by(1)
    end

    it 'should vote up' do
      votable.vote_up(user)
      expect(votable.rating).to eq(1)
    end
  end

  describe '#vote_down' do
    it 'should change votes count' do
      expect { votable.vote_down(user) }.to change(votable.votes, :count).by(1)
    end

    it 'should vote down' do
      votable.vote_down(user)
      expect(votable.rating).to eq(-1)
    end
  end

  describe '#remove_vote' do
    before { votable.vote_up(user) }
    it 'should change votes count' do
      expect { votable.remove_vote(user) }.to change(votable.votes, :count).by(-1)
    end

    it 'should remove vote' do
      expect(votable.rating).to eq(1)
      votable.remove_vote(user)
      expect(votable.rating).to eq(0)
    end
  end

  describe '#rating' do
    it 'should return sum of all votes' do
      users = create_list(:user, 7)
      users[0..4].each { |u| votable.vote_up(u) }
      users[5..7].each { |u| votable.vote_down(u) }
      expect(votable.rating).to eq(3)
    end
  end

  describe '#voted_by?' do
    it 'should return true if user voted' do
      votable.vote_up(user)
      expect(votable).to be_voted_by(user)
    end
  end
end
