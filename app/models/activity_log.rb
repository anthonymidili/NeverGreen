class ActivityLog < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy

  default_scope { order(created_at: :desc) }
end
