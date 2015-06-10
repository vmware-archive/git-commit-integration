class CreateDeployCommits < ActiveRecord::Migration
  def change
    create_table :deploy_commits do |t|
      t.string :deployed_sha

      t.timestamps null: false
    end
  end
end
