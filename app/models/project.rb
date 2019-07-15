class Project < ApplicationRecord
  has_many_attached :tracks
  has_many :downloaded_tracks, dependent: :destroy

  validates :name, presence: true
end
