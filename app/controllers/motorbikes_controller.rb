class MotorbikesController < ApplicationController
  before_action :set_motorbike, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]

  def index
    @motorbikes = current_user.motorbikes
  end

  def new
    @motorbike = current_user.motorbikes.build
  end

  def create


    @motorbike = current_user.motorbikes.build(motorbike_params)
    if @motorbike.save
      redirect_to listing_motorbike_path(@motorbike), notice: "保存しました"
    else
      flash[:alert] = "エラーが発生しました"
      render :new
    end
  end

  def show
    @photos = @motorbike.photos
    @guest_reviews = @motorbike.guest_reviews
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @motorbike.photos
  end

  def amenities
  end

  def location
  end

  def update

    new_params = motorbike_params
    new_params = motorbike_params.merge(active: true) if is_ready_motorbike

    if @motorbike.update(new_params)
      flash[:notice] = "保存されました"
    else
      flash[:alert] = "エラーが発生しました"
    end
    redirect_back(fallback_location: request.referer)
  end

  private

    def set_motorbike
      @motorbike = Motorbike.find(params[:id])
    end

    def is_ready_motorbike
      !@motorbike.active && !@motorbike.price.blank? && !@motorbike.listing_name.blank? && !@motorbike.photos.blank? && !@motorbike.address.blank?
    end

    def motorbike_params
      params.require(:motorbike).permit(:listing_name, :summary, :address, :price, :active, :instant)
    end
end
