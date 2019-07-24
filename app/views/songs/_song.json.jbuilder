json.extract! song, :id, :name, :audio_file, :created_at, :updated_at
json.url song_url(song, format: :json)
