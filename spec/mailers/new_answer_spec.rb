require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe "notify" do
    let(:answer) { create(:answer) }
    let(:user) { answer.question.author }
    let(:mail) { NewAnswerMailer.notify(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello from QNA!")
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
