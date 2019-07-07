class TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_access!, unless: :valid_band_member?
  before_action :set_project
  before_action :set_track

  def destroy
    respond_to do |format|
      @track.try(:purge)
      format.html { redirect_to edit_project_path(@project) }
      format.js
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_track
      @track = @project.tracks.find_by(id: params[:id])
    end
end
