class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @motorbikes = @user.motorbikes

    # Display all the guest reviews to host (if this user is a host)
    @guest_reviews = Review.where(type: "GuestReview", host_id: @user.id)

    # Display all the host reviews to host (if this user is a guest)
    @host_reviews = Review.where(type: "HostReview", guest_id: @user.id)
<<<<<<< HEAD
=======

>>>>>>> origin/master
  end

  def update_phone_number
    current_user.update_attributes(user_params)

    redirect_to edit_user_registration_path, notice: "保存しました"
  rescue Exception => e
    redirect_to edit_user_registration_path, alert: "#{e.message}"
  end

<<<<<<< HEAD
  def payment
  end

  def payout
    if !current_user.merchant_id.blank?
      account = Stripe::Account.retrieve(current_user.merchant_id)
    end
  end

  def add_card
    if current_user.stripe_id.blank?
      customer = Stripe::Customer.create(
        email: current_user.email
      )
      current_user.stripe_id = customer.id
      current_user.save

      # Add Credit Card to Stripe
      customer.sources.create(source: params[:stripeToken])
    else
      customer = Stripe::Customer.retrieve(current_user.stripe_id)
      customer.source = params[:stripeToken]
      customer.save
    end

    flash[:notice] = "カードが保存されました"
    redirect_to payment_method_path
  rescue Stripe::CardError => e
    flash[:notice] = "カードの保存に失敗しました"
    redirect_to payment_method_path
  end

  private

    def user_params
      params.require(:user).permit(:phone_number, :pin)
=======
  private

    def user_params
      params.require(:user).permit(:phone_number)
>>>>>>> origin/master
    end
end
