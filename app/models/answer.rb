class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :question, touch: true

  validates :body, :question_id, :user_id, presence: true

  scope :best_first, -> { order('best DESC', 'created_at').includes(:user) }

  after_create :notify_subscribers

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def notify_subscribers
    NewAnswerJob.perform_later(self.question)
  end
end
