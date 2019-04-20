class PhotosController < ApplicationController

  def create
    @motorbike = Motorbike.find(params[:motorbike_id])

    if params[:images]
      params[:images].each do |img|
        @motorbike.photos.create(image: img)
      end

      @photos = @motorbike.photos
      redirect_back(fallback_location: request.referer, notice: "保存されました")
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @motorbike = @photo.motorbike

    @photo.destroy
    @photos = Photo.where(motorbike_id: @motorbike.id)

    respond_to :js
  end
end
