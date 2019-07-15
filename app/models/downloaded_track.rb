class DownloadedTrack < ApplicationRecord
  belongs_to :user
  belongs_to :project

  scope :destroy_associated, -> track { where(track_id: track.id).destroy_all }
end
