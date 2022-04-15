class FilesController < ApplicationController
  before_action :authenticate_user!

  expose :file, find: ->(id){ ActiveStorage::Attachment.find(id) }

  authorize_resource

  def destroy
    file.purge
  end
end
