class Question < ActiveRecord::Base
<<<<<<< HEAD
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { maximum: 140 }
=======
  has_many :answers

  validates :title, :body, presence: true, length: { maximum: 140 }
>>>>>>> 62eb033b7ab98121a634f18a63c175b08b260bcb
  validates :body, presence: true
end
