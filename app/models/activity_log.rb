class ActivityLog < ApplicationRecord
  belongs_to :project
  belongs_to :user

  default_scope { order(created_at: :desc) }
end
