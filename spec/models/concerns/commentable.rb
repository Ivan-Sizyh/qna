require 'rails_helper'

RSpec.shared_examples_for "commentable" do
  it { should have_many :votes }
end
