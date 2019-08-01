class MailBandMembersWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(project_id, from_id)
    project = Project.find_by(id: project_id)
    from_user = User.find_by(id: from_id)
    recipients = User.by_band_members.all_but_current(from_user)

    if project && from_user      
      BandMembersMailer.project_activity(recipients, from_user, project).deliver_now
    end
  end
end
