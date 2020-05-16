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

  def found_notification?(user)
    @found_notification ||=
      find_notification(user).present?
  end

  def find_comment_notifications(user)
    comment_notifications = []
    activity_logs.map do |activity_log|
      activity_log.comments.map do |comment|
        comment_notifications << comment.notifications.where(recipient: user)
      end
    end
    comment_notifications.reject(&:blank?)
  end

  def found_comment_notifications?(user)
    @found_comment_notifications ||=
      find_comment_notifications(user).any?
  end

  # Return true if project, user, notification present. Else false.
  def has_new_activity?(user)
    found_notification?(user) || found_comment_notifications?(user)
  end

  # Create notifications and send mass email.
  def create_send_notifications(created_by)
    # Find all band members that are not the current user and unnotified.
    recipients = User.by_band_members.all_but_current(created_by).by_unnotified(self)
    # Create notifications in a background job.
    recipients.each do |recipient|
      NotifiableNotificationsWorker.perform_async(self.class.name, self.id, created_by.id, recipient.id)
    end
    # Send mass email in a background job.
    MailBandMembersWorker.perform_async(self.id, created_by.id, recipients.ids)
  end

  def remove_notifications(user)
    find_notification(user).destroy if found_notification?(user)
    find_comment_notifications(user).map(&:destroy_all) if found_comment_notifications?(user)
  end

  # Find all exisiting track ids for the project.
  def current_track_ids
    tracks.where.not(id: nil).ids
  end

  # Find all the newly created track names for the project.
  def added_track_names(current_track_ids = [])
    tracks_attachments.joins(:blob).where.not(id: current_track_ids).pluck(:filename)
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
