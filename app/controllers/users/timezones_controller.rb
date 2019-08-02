class Users::TimezonesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit
    @return_to = params[:return_to] if params[:return_to]
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html {
          redirect_to return_to_url, notice: 'Timezone was successfully updated.'
        }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:timezone)
    end

    def return_to_url
      if params[:return_to] == 'band_members'
        band_members_path
      else
        edit_user_registration_path
      end
    end
 end
