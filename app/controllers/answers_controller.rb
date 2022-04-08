class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!

  after_action :publish_answer, only: [:create]

  expose :question
  expose :answer, find: ->(id){ Answer.with_attached_files.find(id) },
         build: ->(answer_params){ Answer.new(answer_params.merge(question: question, author: current_user)) }

  def create
    respond_to do |format|
      if answer.save
        format.json { render json: answer }
      else
        format.json { render json: answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    if current_user&.is_author?(answer)
      flash.now[:notice] = 'Your answer has been successfully updated!' if answer.update(answer_params)
    end
  end

  def destroy
    if current_user&.is_author?(answer)
      respond_to :js, flash.now[:notice] = 'Your answer successfully deleted.' if answer.destroy
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy, :id])
  end

  def publish_answer
    unless answer.errors.any?
      rendered_answer = ApplicationController.render(
        partial: 'answers/answer',
        locals: {
          answer: answer,
          current_user: current_user,
          question: question
        })

      ActionCable.server.broadcast("question-#{question.id}",
                                   {
                                     answer: rendered_answer,
                                     answer_id: answer.id,
                                     answer_author_id: answer.author.id,
                                     question_author_id: question.author.id
                                   })
    end
  end
end
