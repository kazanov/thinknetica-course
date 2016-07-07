class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  scope :yesterday_created, -> { where(created_at: Time.now.yesterday.all_day) }

  after_create :subscribe_author

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :title, presence: true, length: { maximum: 140 }
  validates :body, :user_id, presence: true

  private

  def subscribe_author
    subscriptions.create(user: user)
  end
end
