class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable

  validates :title, presence: true, length: { maximum: 140 }
  validates :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments
end
