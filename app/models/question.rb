class Question < ActiveRecord::Base
  has_many :answers

  validates :title, :body, presence: true, length: { maximum: 140 }
  validates :body, presence: true
end
