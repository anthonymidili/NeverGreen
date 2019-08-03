class MailBandMembersWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(project_id, from_id, recipients_ids)
    project = Project.find_by(id: project_id)
    from_user = User.find_by(id: from_id)
    recipients = User.where(id: recipients_ids)

    if project && from_user && recipients.any?
      BandMembersMailer.project_activity(recipients, from_user, project).deliver_now
    end
  end
end
