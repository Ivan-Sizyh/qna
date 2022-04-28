class AnswerNotificationService
  def send_notification(answer)
    answer.question.subscriptions.find_each do |subscription|
      NewAnswerMailer.notify(subscription.user, answer).deliver_later
    end
  end
end
