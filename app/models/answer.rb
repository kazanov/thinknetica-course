class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :user
  belongs_to :question

  validates :body, :question_id, :user_id, presence: true

  scope :best_first, -> { order('best DESC', 'created_at') }

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
