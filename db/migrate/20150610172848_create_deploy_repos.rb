class CreateDeployRepos < ActiveRecord::Migration
  def change
    create_table :deploy_repos do |t|
      t.integer :deploy_id
      t.integer :repo_id

      t.timestamps null: false
    end
  end
end
