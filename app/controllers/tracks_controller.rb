class TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_access!, unless: :valid_band_member?
  before_action :set_project
  before_action :set_track

  def downloaded
    current_user.downloaded_tracks.find_or_create_by(track_id: @track.id) do |dt|
      dt.project = @project
    end

    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if !track_params[:filename].blank? && @track.blob.update(track_params)
        format.html { redirect_to edit_project_path(@project), notice: 'Track was successfully updated.' }
        format.json { render :edit, status: :ok, location: @project }
      else
        format.html {
          flash[:notice] = 'Something went wrong.'
          render :edit
        }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      respond_to do |format|
        # Find all associated DownloadedTrack(s) model objects and destroy them manually.
        @project.downloaded_tracks.destroy_associated(@track)
        # Create an ActivityLog.
        @project.create_activity_log(current_user, 'removed', [@track.blob.filename.to_s])
        @track.try(:purge)
        format.html { redirect_to edit_project_path(@project) }
        format.js
      end
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_track
      @track = @project.tracks.find_by(id: params[:id])
    end

    def track_params
      params.require(:attachment).permit(:filename)
    end
end
