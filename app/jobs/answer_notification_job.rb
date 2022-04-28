class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotificationService.new.send_notification(answer)
  end
end
