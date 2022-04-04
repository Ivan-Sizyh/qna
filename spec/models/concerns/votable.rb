require 'rails_helper'

RSpec.shared_examples_for "votable" do
  it { should have_many :votes }

  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  it "#score" do
    create(:vote, author: user, votable: model, up: 1)
    score = model.votes.sum(:up)
    expect(model.score).to eq(score)
  end
end
