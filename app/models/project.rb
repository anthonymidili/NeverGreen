class Project < ApplicationRecord
  has_many_attached :tracks
  
  validates :name, presence: true
end
