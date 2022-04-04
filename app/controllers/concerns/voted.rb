module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote unvote]
  end

  def vote
    unless current_user.is_author?(@votable) || current_user.voted_for?(@votable)
      @vote = Vote.new(votable: @votable, author: current_user, up: vote_status)
      render json: { score: @votable.score, votable_type: @vote.votable_type.downcase, id: @votable.id }, status: :ok if @vote.save
    end
  end

  def unvote
    @vote = current_user.vote(@votable)

    if @vote && current_user.is_author?(@vote)
      @vote.destroy
      render json: { score: @votable.score, votable_type: @vote.votable_type.downcase, id: @votable.id }, status: :ok
    end
  end

  private

  def votable_name
    params[:votable]
  end

  def vote_status
    params[:up]
  end

  def set_votable
    @votable = votable_name.singularize.capitalize.constantize.find(params[:id])
  end
end