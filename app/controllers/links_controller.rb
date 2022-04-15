class LinksController < ApplicationController
  before_action :authenticate_user!

  expose :link, ->{ Link.find(params[:id]) }

  load_and_authorize_resource

  def destroy
    link.destroy
  end
end
