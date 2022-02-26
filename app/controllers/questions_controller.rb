class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question, build: ->(question_params){ current_user&.questions.new(question_params) }
  expose :questions, ->{ Question.all }
  expose :answer, ->{ question.answers.new }

  def create
    if question.save
      redirect_to question, notice: 'Your question successfully created!'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
