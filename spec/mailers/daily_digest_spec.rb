require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:questions) { create_list(:question, 2) }

  describe "digest" do
    let(:mail) { DailyDigestMailer.digest(user, questions) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello from QNA!")
      expect(mail.body.encoded).to match(questions.first.title)
    end
  end
end
