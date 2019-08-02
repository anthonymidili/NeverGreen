class AddTimeZoneToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :timezone, :string, default: 'Eastern Time (US & Canada)'
  end
end
