class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  has_many :attachments, dependent: :destroy, as: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, :question_id, :user_id, presence: true

  scope :best_first, -> { order('best DESC', 'created_at') }

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
