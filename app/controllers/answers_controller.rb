class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question
  expose :answer, build: ->(answer_params){ Answer.new(answer_params.merge(question: question, author: current_user)) }

  def create
    if answer.save
      redirect_to answer.question, notice: 'Your answer has been successfully created!'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.is_author?(answer)
      answer.destroy
      redirect_to question, notice: 'Your answer successfully deleted.'
    else
      redirect_to question
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
