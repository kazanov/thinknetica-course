module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    votes.create(user: user, value: 1)
  end

  def vote_down(user)
    votes.create(user: user, value: -1)
  end

  def remove_vote(user)
    votes.exists?(user: user) && votes.find_by(user: user).destroy
  end

  def voted_by?(user)
    votes.where(user: user).present?
  end

  def rating
    votes.sum(:value)
  end

  def able_to_vote(user)
  !voted_by?(user) && !user.author_of?(self)
  end
end
