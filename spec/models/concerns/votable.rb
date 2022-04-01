require 'rails_helper'

RSpec.shared_examples_for "votable" do
  it { should have_many :votes }

  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  it "#score" do
    create(:vote, author: user, votable: model, up: true)
    score = model.votes.where(:up => true).count - model.votes.where(:up => false).count
    expect(model.score).to eq(score)
  end
end
