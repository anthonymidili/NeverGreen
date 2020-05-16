class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.bigint :created_by_id, index: true, null: false
      t.text :body

      t.timestamps
    end

    add_foreign_key :comments, :users, column: :created_by_id
  end
end
