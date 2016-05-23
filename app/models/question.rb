class Question < ActiveRecord::Base
  include Attachable
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable

  validates :title, presence: true, length: { maximum: 140 }
  validates :body, :user_id, presence: true
end
