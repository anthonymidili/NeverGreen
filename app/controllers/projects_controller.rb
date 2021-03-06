class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_access!, unless: :valid_band_member?
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :remove_notification, only: [:show, :edit]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @comment = Comment.new
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    ActiveRecord::Base.transaction do
      respond_to do |format|
        if @project.save
          # Set and send notifications to band members.
          @project.create_send_notifications(current_user)
          # Create an ActivityLog.
          @project.create_activity_log(current_user, 'created project - added', @project.added_track_names)
          format.html { redirect_to @project, notice: 'Project was successfully created.' }
          format.json { render :show, status: :created, location: @project }
        else
          # Remove all blobs that do not have attachments
          ActiveStorage::Blob.where(metadata: nil).each { |blob| blob.purge }
          format.html { render :new }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    ActiveRecord::Base.transaction do
      respond_to do |format|
        # Find all project's current track ids.
        current_track_ids = @project.current_track_ids
        # Attach new tracks to existing project.
        @project.tracks.attach(project_params[:tracks]) if project_params[:tracks]

        if @project.update(project_params)
          # Find all project's newly added track names.
          added_track_names = @project.added_track_names(current_track_ids)
          # Create an ActivityLog.
          @project.create_activity_log(current_user, 'added', added_track_names)
          # Set and send notifications to band members.
          @project.create_send_notifications(current_user)
          format.html { redirect_to @project, notice: 'Project was successfully updated.' }
          format.json { render :show, status: :ok, location: @project }
        else
          # Remove all blobs that do not have attachments
          ActiveStorage::Blob.where(metadata: nil).each { |blob| blob.purge }
          format.html { render :edit }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, tracks: [])
    end

    def remove_notification
      @project.remove_notifications(current_user)
    end
end
