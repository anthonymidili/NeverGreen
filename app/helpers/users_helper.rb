module UsersHelper
  def valid_band_member?
    @valid_band_member ||=
      current_user.roles.include?('band_member')
  end

  def valid_admin?
    @valid_admin ||=
      current_user.roles.include?('admin')
  end
end
