class Project < ApplicationRecord
  has_many_attached :tracks
  has_many :downloaded_tracks

  validates :name, presence: true
end
