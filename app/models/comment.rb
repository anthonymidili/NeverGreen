class Comment < ApplicationRecord
  after_commit :create_notifications, on: :create

  belongs_to :commentable, polymorphic: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true

  default_scope { order(created_at: :asc) }

  private

    def create_notifications
      # Find all band members that are not the current user and unnotified.
      recipients = User.by_band_members.all_but_current(created_by).by_unnotified(self)
      # Create notifications in a background job.
      recipients.each do |recipient|
        NotifiableNotificationsWorker.perform_async(self.class.name, self.id, created_by.id, recipient.id)
      end
      # Send mass email in a background job.
      MailBandMembersWorker.perform_async(commentable.project.id, created_by.id, recipients.ids)
    end
end
