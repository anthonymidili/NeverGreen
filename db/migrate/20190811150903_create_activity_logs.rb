class CreateActivityLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_logs do |t|
      t.string :action, null: false
      t.integer :tracks_count
      t.text :track_names, array: true, default: []
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true, null: false

      t.timestamps
    end
  end
end
