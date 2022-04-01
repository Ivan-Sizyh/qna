class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :rewards, dependent: :destroy
  has_many :questions, dependent: :destroy, foreign_key: 'author_id'
  has_many :answers, dependent: :destroy, foreign_key: 'author_id'
  has_many :votes, dependent: :destroy, foreign_key: 'author_id'

  def is_author?(resource)
    resource.author_id == id
  end

  def vote(resource)
    votes.find_by(votable: resource)
  end

  def voted_for?(resource)
    vote(resource).present?
  end
end
