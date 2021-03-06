class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_gon_question, only: %i[show]

  after_action :publish_question, only: [:create]

  expose :question, find: ->(id){ Question.with_attached_files.find(id) },
         build: ->(question_params){ current_user&.questions&.new(question_params) }
  expose :questions, ->{ Question.all }
  expose :answer, ->{ Answer.new }
  expose :without_best, ->{ question.answers - [question.best_answer] }

  load_and_authorize_resource

  def new
    question.links.new
    question.reward = Reward.new(question_id: question)
  end

  def show
    answer.links.new
  end

  def create
    if question.save
      redirect_to question, notice: 'Your question successfully created!'
    else
      render :new
    end
  end

  def update
    flash.now[:notice] = 'Your question has been successfully updated!' if question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  def set_best_answer
    question.update(best_answer_id: params[:answer_id])
    question.reward&.update(user: Answer.find(params[:answer_id]).author)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url, :_destroy, :id],
                                     reward_attributes: [:name, :image] )
  end

  def publish_question
    unless question.errors.any?
      ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
          partial: 'questions/question',
          locals: {
            question: question,
            current_user: current_user
            },
          )
      )
    end
  end

  def set_gon_question
    gon.question_id = question.id
  end
end
