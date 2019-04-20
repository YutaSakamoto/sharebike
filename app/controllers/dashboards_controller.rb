class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @motorbikes = current_user.motorbikes
  end
end
