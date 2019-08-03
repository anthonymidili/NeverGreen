class BandMembersMailer < ApplicationMailer
  def project_activity(to, from, project)
    @to_users = to
    @from_user = from
    @project = project

    mail to: @to_users.pluck(:email),
    subject: "New Activity on #{@project.name} by #{@from_user.name}"
  end
end
