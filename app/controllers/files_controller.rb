class FilesController < ApplicationController
  before_action :authenticate_user!

  expose :file, find: ->(id){ ActiveStorage::Attachment.find(id) }

  def destroy
    file.purge if current_user&.is_author?(file.record)
  end
end
