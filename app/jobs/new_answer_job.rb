class NewAnswerJob < ActiveJob::Base
  queue_as :mailers

  def perform(question)
    question.subscriptions.find_each do |subscription|
      NewAnswerNotice.new_answer(question, subscription.user.email).deliver_later
    end
  end
end
