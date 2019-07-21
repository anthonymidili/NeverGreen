class Project < ApplicationRecord
  has_many_attached :tracks
  has_many :downloaded_tracks, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :name, presence: true

  # Find project, user, notification.
  def find_user_notification(user)
    notifications.find_by(recipient: user)
  end

  # Return true if project, user, notification present. Else false.
  def has_new_activity?(user)
    find_user_notification(user).present?
  end
end
