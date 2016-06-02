class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { maximum: 140 }
  validates :body, :user_id, presence: true
end
