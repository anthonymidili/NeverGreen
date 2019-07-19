class BandMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_access!, unless: :valid_band_member?

  def directory
    @band_members = User.by_band_members
  end

  def kickout
    @band_member = User.find(params[:id])
    @band_member.roles = @band_member.roles - ['band_member']
    @band_member.save
    redirect_to band_members_directory_path
  end
end
