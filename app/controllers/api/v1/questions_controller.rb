class Api::V1::QuestionsController < Api::V1::BaseController
  expose :question, find: ->(id){ Question.with_attached_files.find(id) },
         build: ->(question_params){ current_resource_owner&.questions&.new(question_params) }
  expose :questions, ->{ Question.all }
  expose :answer, ->{ Answer.new }

  load_and_authorize_resource

  def index
    render json: questions
  end

  def show
    render json: question
  end

  def create
    if question.save
      render json: question
    else
      head :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question
    else
      render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    question.destroy
    render json: question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url, :_destroy, :id],
                                     reward_attributes: [:name, :image] )
  end
end
