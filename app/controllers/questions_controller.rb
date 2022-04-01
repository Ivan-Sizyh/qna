class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]

  expose :question, find: ->(id){ Question.with_attached_files.find(id) },
                    build: ->(question_params){ current_user&.questions.new(question_params) }
  expose :questions, ->{ Question.all }
  expose :answer, ->{ Answer.new }
  expose :without_best, ->{ question.answers - [question.best_answer] }

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
    if current_user&.is_author?(question)
      flash.now[:notice] = 'Your question has been successfully updated!' if question.update(question_params)
    end
  end

  def destroy
    if current_user&.is_author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to question
    end
  end

  def set_best_answer
    if current_user&.is_author?(question)
      question.update(best_answer_id: params[:answer_id])
      question.reward&.update(user: Answer.find(params[:answer_id]).author)
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url, :_destroy, :id],
                                     reward_attributes: [:name, :image] )
  end
end
