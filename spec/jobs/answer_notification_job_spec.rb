require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let!(:answer) { create(:answer) }
  let(:service) { double('AnswerNotificationService') }

  before do
    allow(AnswerNotificationService).to receive(:new).and_return(service)
  end

  it 'calls AnswerNotificationService#send_notification' do
    expect(service).to receive(:send_notification)
    AnswerNotificationJob.perform_now(answer)
  end
end
