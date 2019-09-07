class NotifiableNotificationsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(notifiable_type, notifiable_id, created_by_id, recipient_id)
    notifiable = notifiable_type.constantize.find_by(id: notifiable_id)
    created_by = User.find_by(id: created_by_id)
    recipient = User.find_by(id: recipient_id)

    if notifiable && created_by && recipient
      notifiable.notifications.find_or_create_by(recipient: recipient) do |notification|
        notification.created_by = created_by
      end
    end
  end
end
