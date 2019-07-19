class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :deny_access!, only: [:new, :create, :destroy],
    unless: :valid_admin?

  # GET /resource/invitation/new
  # POST /resource/invitation
  def create
    ActiveRecord::Base.transaction do
      # Find if user already exists in the database.
      user = User.find_by(email: invite_params[:email])

      # If user is found, send an invitation and set the role.
      if user
        user.invite!(current_user) do |u|
          (u.roles += ['band_member']).uniq!
        end
        set_flash_message :notice, :send_instructions, email: user.email
        redirect_to band_members_directory_path
      # If user is not found, Create the user, send in invitation and set the role.
      else
        self.resource =
          invite_resource do |u|
            (u.roles += ['band_member']).uniq!
          end
        resource_invited = resource.errors.empty?
        yield resource if block_given?
        if resource_invited
          if is_flashing_format? && self.resource.invitation_sent_at
            set_flash_message :notice, :send_instructions, email: self.resource.email
          end
          respond_with resource, location: band_members_directory_path
        else
          respond_with_navigational(resource) { render :new }
        end
      end
    end
  end

  def edit
    if resource.new_user?
      super
    else
      resource.update(invitation_token: nil, invitation_accepted_at: Time.current)
      if resource.save
        redirect_to new_user_session_path
      else
        redirect_to root_path, notice: 'Something went wrong.'
      end
    end
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite) do |user_params|
      user_params.permit(:name, :email)
    end
  end
end
