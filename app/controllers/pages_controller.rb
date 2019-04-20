class PagesController < ApplicationController
  PER = 6
<<<<<<< HEAD

=======
>>>>>>> origin/master
  def home
    @motorbikes = Motorbike.where(active: true).limit(30).page(params[:page]).per(PER)
  end

<<<<<<< HEAD
  def about
  end

  def owners
  end

  def renters
  end

=======
>>>>>>> origin/master
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
<<<<<<< HEAD
    if (params[:start_date] && params[:end_date] && !params[:start_date].empty? &&  !params[:end_date].empty?)

        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])

        @motorbikes.each do |motorbike|

        not_available = motorbike.reservations.where(
          "((? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (start_date < ? AND ? < end_date))
          AND status = ?",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date,
          1
        ).limit(1)

        not_available_in_calendar = motorbike.calendars.where(
          "motorbike_id = ? AND status = ? AND day <= ? AND day >= ?",
          motorbike.id, 1, end_date, start_date
        ).limit(1)

        if not_available.length > 0 || not_available_in_calendar.length > 0
          @arrMotorbikes.delete(motorbike)
        end
      end
    end
=======
>>>>>>> origin/master
  end
end
