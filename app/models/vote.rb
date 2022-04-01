class Vote < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :votable, polymorphic: true

  validates :up, inclusion: { in: [ true, false ] }
end
