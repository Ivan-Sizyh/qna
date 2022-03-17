class LinksController < ApplicationController
  before_action :authenticate_user!

  expose :link, ->{ Link.find(params[:id]) }

  def destroy
    link.destroy if current_user&.is_author?(link.linkable)
  end
end
