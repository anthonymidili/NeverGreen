class Notification < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :notifiable, polymorphic: true

  # Find all band members that are not the current user and unnotified.
  def self.new_activity(project, created_by)
    # Create notifications in a background job.
    recipients = User.by_band_members.all_but_current(created_by).by_unnotified(project)

    recipients.each do |recipient|
      ProjectNotificationsWorker.perform_async(project.id, created_by.id, recipient.id)
    end

    # Send mass email in a background job.
    MailBandMembersWorker.perform_async(project.id, created_by.id, recipients.ids)
  end
end
