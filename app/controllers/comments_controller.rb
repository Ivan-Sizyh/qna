class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = current_user.comments.create(comment_params.merge(commentable: @commentable))
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def commentable_name
    params[:commentable_type]
  end

  def set_commentable
    @commentable = commentable_name.singularize.capitalize.constantize.find(params[:commentable_id])
  end

  def publish_comment
    unless @comment.errors.any?
      ActionCable.server
                 .broadcast('comments',
                            {
                              comment: @comment.text,
                              commentable_type: @comment.commentable_type.underscore,
                              commentable_id: @comment.commentable_id,
                              author_email: @comment.author.email
                            })
    end
  end
end
