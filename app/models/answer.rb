class Answer < ActiveRecord::Base
<<<<<<< HEAD
  belongs_to :question

  validates :question, presence: true
=======
  belongs_to :question, dependent: :destroy

>>>>>>> 62eb033b7ab98121a634f18a63c175b08b260bcb
  validates :body, presence: true
end
