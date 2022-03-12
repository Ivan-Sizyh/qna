class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question
  expose :answer, find: ->(id){ Answer.with_attached_files.find(id) },
                  build: ->(answer_params){ Answer.new(answer_params.merge(question: question, author: current_user)) }

  def create
    flash.now[:notice] = 'Your answer has been successfully created!' if answer.save
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

  def delete_attached_file
    if current_user&.is_author?(answer)
      answer.files.find(params[:file]).purge
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
