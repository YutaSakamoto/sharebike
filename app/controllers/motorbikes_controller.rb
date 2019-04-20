class MotorbikesController < ApplicationController
  before_action :set_motorbike, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorised, only: [:listing, :pricing, :description, :photo_upload, :amenities, :location, :update]

  def index
    @motorbikes = current_user.motorbikes
  end

  def new
    @motorbike = current_user.motorbikes.build
  end

  def create
    if !current_user.is_active_host
      return redirect_to payout_method_path, alert: "支払い設定を完了してください"
    end

    @motorbike = current_user.motorbikes.build(motorbike_params)
    if @motorbike.save
      redirect_to listing_motorbike_path(@motorbike), notice: "保存されました"
    else
      flash[:alert] = "保存に失敗しました"
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

  def location
  end

  def update

    new_params = motorbike_params
    new_params = motorbike_params.merge(active: true) if is_ready_motorbike

    if @motorbike.update(new_params)
      flash[:notice] = "保存されました"
    else
      flash[:alert] = "保存に失敗しました"
    end
    redirect_back(fallback_location: request.referer)
  end

  # --- Reservations ---
  def preload
    today = Date.today
    reservations = @motorbike.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)
    unavailable_dates = @motorbike.calendars.where("status = ? AND day > ?", 1, today)

    special_dates = @motorbike.calendars.where("status = ? AND day > ? AND price <> ?",0, today, @motorbike.price)

    render json: {
        reservations: reservations,
        unavailable_dates: unavailable_dates,
        special_dates: special_dates
    }
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @motorbike)
    }

    render json: output
  end

  private
    def is_conflict(start_date, end_date, motorbike)
      check = motorbike.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
      check_2 = motorbike.calendars.where("day BETWEEN ? AND ? AND status = ?", start_date, end_date, 1).limit(1)

      check.size > 0 || check_2.size > 0 ? true : false
    end

    def set_motorbike
      @motorbike = Motorbike.find(params[:id])
    end

    def is_authorised
      redirect_to root_path, alert: "権限がありません" unless current_user.id == @motorbike.user_id
    end

    def is_ready_motorbike
      !@motorbike.active && !@motorbike.price.blank? && !@motorbike.listing_name.blank? && !@motorbike.photos.blank? && !@motorbike.address.blank?
    end

    def motorbike_params
      params.require(:motorbike).permit(:listing_name, :summary, :address, :price, :active, :instant)
    end
end
