class DailyDigestMailer < ApplicationMailer
  def daily_digest(user)
    @questions = Question.yesterday_created
    mail(to: user.email, subject: 'Questions daily digest')
  end
end
