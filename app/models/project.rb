class Project < ApplicationRecord
  has_many_attached :tracks
  has_many :downloaded_tracks, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :activity_logs, dependent: :destroy

  validates :name, presence: true

  def new_tracks(user)
    @new_tracks ||=
      tracks.where('created_at > :last_sign_in', last_sign_in: user.last_sign_in_at)
  end

  def old_tracks(user)
    @old_tracks ||=
      tracks.where('created_at < :last_sign_in', last_sign_in: user.last_sign_in_at)
  end

  # Find project, user, notification.
  def find_notification(user)
    notifications.find_by(recipient: user)
  end

  # Return true if project, user, notification present. Else false.
  def has_new_activity?(user)
    find_notification(user).present?
  end

  # Create notifications and send mass email.
  def create_send_notifications(created_by)
    # Find all band members that are not the current user and unnotified.
    recipients = User.by_band_members.all_but_current(created_by).by_unnotified(self)
    # Create notifications in a background job.
    recipients.each do |recipient|
      ProjectNotificationsWorker.perform_async(self.id, created_by.id, recipient.id)
    end
    # Send mass email in a background job.
    MailBandMembersWorker.perform_async(self.id, created_by.id, recipients.ids)
  end

  # Find all exisiting track ids for the project.
  def current_track_ids
    tracks.where.not(id: nil).ids
  end

  # Find all the newly created track names for the project.
  def added_track_names(current_track_ids = [])
    tracks.joins(:blob).where.not(id: current_track_ids).pluck(:filename)
  end

  # Create a new activity log for the project.
  def create_activity_log(user, action, track_names)
    if track_names.present?
      activity_logs.create(
        user: user,
        action: action,
        tracks_count: track_names.count,
        track_names: track_names
      )
    end
  end
end
