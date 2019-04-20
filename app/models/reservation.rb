class Reservation < ApplicationRecord
  enum status: {Waiting: 0, Approved: 1, Declined: 2}
<<<<<<< HEAD

  after_create_commit :create_notification

  belongs_to :user
  belongs_to :motorbike

  scope :current_week_revenue, -> (user) {
    joins(:motorbike)
    .where("motorbikes.user_id = ? AND reservations.updated_at >= ? AND reservations.status = ?", user.id, 1.week.ago, 1)
    .order(updated_at: :asc)
  }

  private
    def create_notification
      guest = User.find(self.user_id)

      Notification.create(content: "#{guest.fullname}さんから予約がありました", user_id: self.motorbike.user_id)
    end
=======
  
  belongs_to :user
  belongs_to :motorbike
>>>>>>> origin/master
end
