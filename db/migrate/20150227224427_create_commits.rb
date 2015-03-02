class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :data, null: false
      t.string :sha, null: false
      t.string :patch_id, null: false
      t.string :message, null: false
      t.integer :author_github_user_id, null: false
      t.datetime :author_date, null: false
      t.integer :committer_github_user_id, null: false
      t.datetime :committer_date, null: false
      t.integer :push_id, null: false

      t.timestamps null: false
    end
  end
end
