require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to(:author).class_name('User') }

  it { should validate_inclusion_of(:up).in_array([true, false]) }
end
