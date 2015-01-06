class ImagesController < ApplicationController
  def create
    image = Image.new()
    image.file = params[:image]
    if image.save
      render json: {:success => true, :url => image.file.url ,:status => :created}
    else
      render json: image.errors, status: :unprocessable_entity
    end
  end
end
