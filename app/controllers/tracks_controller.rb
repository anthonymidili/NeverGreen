class TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_access!, unless: :valid_band_member?
  before_action :set_project
  before_action :set_track

  def downloaded
    current_user.downloaded_tracks.create(
      project_id: @project.id,
      track_id: @track.id
    )
  end

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
