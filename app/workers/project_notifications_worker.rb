class ProjectNotificationsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(project_id, created_by_id, recipient_id)
    project = Project.find_by(id: project_id)
    created_by = User.find_by(id: created_by_id)
    recipient = User.find_by(id: recipient_id)

    if project && created_by && recipient
      project.notifications.find_or_create_by(recipient: recipient) do |notification|
        notification.created_by = created_by
      end
    end
  end
end
