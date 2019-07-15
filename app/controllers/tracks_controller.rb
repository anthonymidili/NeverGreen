class TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_access!, unless: :valid_band_member?
  before_action :set_project
  before_action :set_track

  def downloaded
    current_user.downloaded_tracks.find_or_create_by(track_id: @track.id) do |dt|
      dt.project = @project
    end
  end

  def destroy
    respond_to do |format|
      @project.downloaded_tracks.destroy_associated(@track)
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
