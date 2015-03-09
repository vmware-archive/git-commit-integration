class AddChildCommitIdToParentCommits < ActiveRecord::Migration
  def change
    add_column :parent_commits, :child_commit_id, :integer, null: false
    change_column :parent_commits, :commit_id, :integer, null: true
  end
end
