class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { maximum: 140 }
  validates :body, presence: true
end
