class BandMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_access!, unless: :valid_band_member?

  def index
    @band_members = User.by_band_members
  end

  def destroy
    @band_member = User.find(params[:id])
    @band_member.roles = @band_member.roles - ['band_member']
    @band_member.save
    redirect_to band_members_path
  end
end
