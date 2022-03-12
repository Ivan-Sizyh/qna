class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, presence: true

  before_destroy :unset_best_answer

  private

  def unset_best_answer
    question.update(best_answer_id: nil) if question.best_answer_id == id
  end
end
