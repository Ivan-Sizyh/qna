module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def score
    votes.where(:up => true).count - votes.where(:up => false).count
  end
end
