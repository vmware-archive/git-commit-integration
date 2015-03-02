class AddCommitsProcessedToPush < ActiveRecord::Migration
  def change
    add_column :pushes, :commits_processed, :boolean, null: false, default: false
  end
end
