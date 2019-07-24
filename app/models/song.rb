class Song < ApplicationRecord
  has_one_attached :audio_file

  validates :name, presence: true
end
