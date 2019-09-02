class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

  validates :body, presence: true

  default_scope { order(created_at: :asc) }
end
