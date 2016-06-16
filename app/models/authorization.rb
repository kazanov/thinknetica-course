class Authorization < ActiveRecord::Base
  belongs_to :user, dependent: :destroy

  validates :user_id, :provider, :uid, presence: true
end
