class AddRepoIdToPushes < ActiveRecord::Migration
  def change
    add_column :pushes, :repo_id, :integer, null: false
  end
end
