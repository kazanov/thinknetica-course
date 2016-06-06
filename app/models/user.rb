class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations

  def author_of?(object)
    id == object.user_id
  end
end
