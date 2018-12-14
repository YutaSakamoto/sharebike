class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline]

  def create
    motorbike = Motorbike.find(params[:motorbike_id])

    if current_user == motorbike.user
      flash[:alert] = "自分のバイクの予約はできません!"
    elsif current_user.stripe_id.blank?
      flash[:alert] = "支払い方法の設定をしてください"
      return redirect_to payment_method_path
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      days = (end_date - start_date).to_i + 1

      @reservation = current_user.reservations.build(reservation_params)
      @reservation.motorbike = motorbike
      @reservation.price = motorbike.price
      # @reservation.total = motorbike.price * days
      # @reservation.save

      @reservation.total = motorbike.price * (days - special_dates.count)
      special_dates.each do |date|
          @reservation.total += date.price
      end

      if @reservation.Waiting!
        if motorbike.Request?
          flash[:notice] = "リクエストが送られました!"
        else
          charge(motorbike, @reservation)
        end
      else
        flash[:alert] = "予約ができませんでした!"
      end

    end
    redirect_to motorbike
  end

  def your_trips
    @trips = current_user.reservations.order(start_date: :asc)
  end

  def your_reservations
    @motorbikes = current_user.motorbikes
  end

  def approve
    charge(@reservation.motorbike, @reservation)
    @reservation.Approved!
    redirect_to your_reservations_path
  end

  def decline
    @reservation.Declined!
    redirect_to your_reservations_path
  end

  private
  def charge(motorbike, reservation)
    if !reservation.user.stripe_id.blank?
      customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
      charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => reservation.total * 100,
        :description => motorbike.listing_name,
        :currency => "jpy",
        :destination => {
        :amount => reservation.total * 80,
        :account => motorbike.user.merchant_id
      }

      )

      if charge
        reservation.Approved!
        flash[:notice] = "予約されました!"
      else
        reservation.Declined!
        flash[:alert] = "本支払い方法では決済できません!"
      end
    end
    rescue Stripe::CardError => e
    reservation.declined!
    flash[:alert] = e.message
    end


    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
