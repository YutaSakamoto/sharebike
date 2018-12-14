class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @motorbikes = @user.motorbikes

    # Display all the guest reviews to host (if this user is a host)
    @guest_reviews = Review.where(type: "GuestReview", host_id: @user.id)

    # Display all the host reviews to host (if this user is a guest)
    @host_reviews = Review.where(type: "HostReview", guest_id: @user.id)

  end

  def update_phone_number
    current_user.update_attributes(user_params)

    redirect_to edit_user_registration_path, notice: "保存しました"
  rescue Exception => e
    redirect_to edit_user_registration_path, alert: "#{e.message}"
  end

  private

    def user_params
      params.require(:user).permit(:phone_number)
    end
end
