module ProjectsHelper
  def alert_icon(has_new_activity)
    if has_new_activity == true
      fa_icon "headphones"
    end
  end
end
