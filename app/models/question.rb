class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  scope :yesterday_created, -> { where(created_at: Time.now.yesterday.all_day) }

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { maximum: 140 }
  validates :body, :user_id, presence: true
end
