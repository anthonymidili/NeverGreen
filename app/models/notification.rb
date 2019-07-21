class Notification < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :notifiable, polymorphic: true

  # Find all band members that are not the current user.
  def self.new_activity(notifiable, created_by)
    User.by_band_members.all_but_current(created_by).each do |recipient|
      create_notification(notifiable, created_by, recipient)
    end
  end

  private

    # Creat a notification.
    def self.create_notification(notifiable, created_by, recipient)
      notifiable.notifications.find_or_create_by(recipient: recipient) do |notification|
        notification.created_by = created_by
      end
    end
end
