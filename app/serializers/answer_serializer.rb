class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :created_at, :updated_at

  has_many :comments
  has_many :files
  has_many :links
  belongs_to :author, class: 'User'
end
