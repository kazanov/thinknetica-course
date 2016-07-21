class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :question, touch: true

  validates :user_id, :question_id, presence: true
  validates :user_id, uniqueness: { scope: :question_id, message: 'already subscribed' }
end
