class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :validatable, :trackable,
    :invitable, validate_on_invite: true

  has_many :downloaded_tracks, dependent: :destroy
  has_many :notifications, foreign_key: 'recipient_id', dependent: :destroy
  has_many :activity_logs

  validates :name, presence: true

  scope :by_band_members, -> { where("'band_member' = ANY (roles)") }
  scope :all_but_current, -> (current_user) { where.not(id: current_user) }
  scope :by_unnotified, -> (project) { where.not(id: project.notifications.pluck(:recipient_id)) }

  def new_user?
    sign_in_count == 0
  end

  def has_new_project_activity?
    notifications.any?
  end

  private
    # A Devise method
    def after_sign_in_path_for(resource)
      session['user_return_to'] || root_path
    end

    # A Devise Invitable method
    def block_from_invitation?
      if new_user?
        # If the user has no account, have them follow the link in thier email.
        return invited_to_sign_up?
      else
        # if the user already has an account, let them in.
        return false
      end
    end
end
