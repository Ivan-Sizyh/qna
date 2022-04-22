class Api::V1::AnswersController < Api::V1::BaseController
  expose :question
  expose :answer, find: ->(id){ Answer.with_attached_files.find(id) },
         build: ->(answer_params){ Answer.new(answer_params.merge(question: question, author: current_user)) }

  load_and_authorize_resource

  def index
    render json: question.answers
  end

  def show
    render json: answer
  end

  def create
      if answer.save
        render json: answer
      else
        render json: answer.errors.full_messages, status: :unprocessable_entity
      end
  end

  def update
    if answer.update(answer_params)
      render json: answer
    else
      render json: answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy
    render json: answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy, :id])
  end
end
