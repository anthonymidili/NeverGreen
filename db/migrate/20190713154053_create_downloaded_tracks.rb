class CreateDownloadedTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :downloaded_tracks do |t|
      t.references :user, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false
      t.bigint :track_id, null: false

      t.timestamps
    end
  end
end
