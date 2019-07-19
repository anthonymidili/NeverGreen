class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :validatable, :trackable,
    :invitable, validate_on_invite: true

  has_many :downloaded_tracks, dependent: :destroy

  validates :name, presence: true

  scope :by_band_members, -> { where("'band_member' = ANY (roles)") }

  def new_user?
    sign_in_count == 0
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
