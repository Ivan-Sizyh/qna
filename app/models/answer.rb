class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  after_create :notify_subscribers
  before_destroy :unset_best_answer

  private

  def unset_best_answer
    question.update(best_answer_id: nil) if question.best_answer_id == id
  end

  def notify_subscribers
    AnswerNotificationJob.perform_later(self)
  end
end
