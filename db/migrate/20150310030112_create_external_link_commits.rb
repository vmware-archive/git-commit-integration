class CreateExternalLinkCommits < ActiveRecord::Migration
  def change
    create_table :external_link_commits do |t|
      t.integer :external_link_id, null: false
      t.integer :commit_id, null: false

      t.timestamps null: false
    end
  end
end
