class CreateExternalLinkRepos < ActiveRecord::Migration
  def change
    create_table :external_link_repos do |t|
      t.integer :external_link_id, null: false
      t.integer :repo_id, null: false

      t.timestamps null: false
    end
  end
end
