class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  has_many :answers
  has_many :votes

  def user_voted?
    votable.votes.exists?(user: current_user)
  end

  def author_of?(object)
    id == object.user_id
  end
end
