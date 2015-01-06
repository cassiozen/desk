class AttachmentsController < ApplicationController
  def create
    attachment = Attachment.new()
    attachment.file = params[:file]
    if attachment.save
      render json: {:success => true, :url => attachment.file.url, :id => attachment.id ,:status => :created}
    else
      render json: attachment.errors, status: :unprocessable_entity
    end
  end
end
