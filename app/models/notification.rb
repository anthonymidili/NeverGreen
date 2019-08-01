class Notification < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :notifiable, polymorphic: true

  # Find all band members that are not the current user.
  # notifiable posibilities are [project]
  def self.new_activity(project, created_by)
    recipients = User.by_band_members.all_but_current(created_by)

    # Create notifications in the background
    recipients.each do |recipient|
      ProjectNotificationsWorker.perform_async(project.id, created_by.id, recipient.id)
    end

    # Send mass email
    MailBandMembersWorker.perform_async(project.id, created_by.id)
  end
end
