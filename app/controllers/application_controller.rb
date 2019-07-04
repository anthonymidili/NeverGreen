class ApplicationController < ActionController::Base
  include UsersHelper

  def deny_access!
    redirect_to root_path
  end
end
