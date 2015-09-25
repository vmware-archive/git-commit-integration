class RenameDeployDeployedShaToSha < ActiveRecord::Migration
  def change
    rename_column :deploy_commits, :deployed_sha, :sha
  end
end
