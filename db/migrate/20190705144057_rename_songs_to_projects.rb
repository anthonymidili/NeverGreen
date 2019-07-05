class RenameprojectsToProjects < ActiveRecord::Migration[5.2]
  def change
    rename_table :songs, :projects
  end
end
