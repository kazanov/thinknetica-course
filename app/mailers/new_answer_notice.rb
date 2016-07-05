class NewAnswerNotice < ApplicationMailer
  default from: 'notifications@example.com'

  def new_answer(question, email)
    @question = question
    @email = email
    mail(to: @email, subject: 'New answer on subscribed question')
  end
end
