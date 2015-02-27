class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :data
      t.string :sha
      t.string :parent_sha
      t.string :patch_id
      t.string :message
      t.integer :author_github_user_id
      t.datetime :author_date
      t.integer :committer_github_user_id
      t.datetime :committer_date
      t.integer :push_id

      t.timestamps null: false
    end
  end
end
