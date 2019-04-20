class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

<<<<<<< HEAD
  def stripe_connect
    auth_data = request.env["omniauth.auth"]
    @user = current_user

    if @user.persisted?
      @user.merchant_id = auth_data.uid
      @user.save

      if !@user.merchant_id.blank?

        # Update Payout Schedule
        account = Stripe::Account.retrieve(current_user.merchant_id)

        # account.payout_schedule.monthly_anchor = 15
        # account.payout_schedule.interval = "monthly"



        logger.debug "#{account}"
      end

      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Stripeに正しく接続されました" if is_navigational_format?

    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      redirect_to dashboard_path
    end
  end

=======
>>>>>>> origin/master
  def failure
    redirect_to root_path
  end
end
