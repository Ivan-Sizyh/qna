class AnswersController < ApplicationController
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer, parent: :question

  def create
    if answer.save
      redirect_to answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
