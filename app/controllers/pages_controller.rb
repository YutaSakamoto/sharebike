class PagesController < ApplicationController
  PER = 6
  def home
    @motorbikes = Motorbike.where(active: true).limit(30).page(params[:page]).per(PER)
  end

  def search
    # STEP 1
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    end

    # STEP 2
    if session[:loc_search] && session[:loc_search] != ""
      @motorbikes_address = Motorbike.where(active: true).near(session[:loc_search], 5, order: 'distance')
    else
      @motorbikes_address = Motorbike.where(active: true).all
    end

    # STEP 3
    @search = @motorbikes_address.ransack(params[:q])
    @motorbikes = @search.result

    @arrMotorbikes = @motorbikes.to_a

    # STEP 4
  end
end
