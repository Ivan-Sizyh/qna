require 'rails_helper'

RSpec.describe AnswerNotificationService do
  let(:answer) { create(:answer) }
  let(:question) { answer.question }

  it 'sends new answer' do
    expect(NewAnswerMailer).to receive(:notify).with(question.author, answer).and_call_original
    subject.send_notification(answer)
  end
end
