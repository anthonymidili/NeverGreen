class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.bigint :created_by_id, foreign_key: true, null: false
      t.bigint :recipient_id, foreign_key: true, null: false
      t.references :notifiable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :notifications, [:recipient_id, :notifiable_id, :notifiable_type],
    unique: true, name: 'index_notifications_on_recipient_id_and_notifiable_id_type'
  end
end
