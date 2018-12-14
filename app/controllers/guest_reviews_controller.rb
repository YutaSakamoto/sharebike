class GuestReviewsController < ApplicationController

  def create
    # Step 1: Check if the reservation exist (motorbike_id, host_id, host_id)

    # Step 2: Check if the current host already reviewed the guest in this reservation.

    @reservation = Reservation.where(
                    id: guest_review_params[:reservation_id],
                    motorbike_id: guest_review_params[:motorbike_id]
                   ).first

    if !@reservation.nil? && @reservation.motorbike.user.id == guest_review_params[:host_id].to_i

      @has_reviewed = GuestReview.where(
                        reservation_id: @reservation.id,
                        host_id: guest_review_params[:host_id]
                      ).first

      if @has_reviewed.nil?
          # Allow to review
          @guest_review = current_user.guest_reviews.create(guest_review_params)
          logger.debug(@test)
          flash[:success] = "レビューが保存されました"
      else
          # Already reviewed
          flash[:success] = "すでにレビューがされています"
      end
    else
      flash[:alert] = "予約が見つかりませんでした"
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @guest_review = Review.find(params[:id])
    @guest_review.destroy

    redirect_back(fallback_location: request.referer, notice: "削除しました")
  end

  private
    def guest_review_params
      params.require(:guest_review).permit(:comment, :star, :motorbike_id, :reservation_id, :host_id)
    end
end
