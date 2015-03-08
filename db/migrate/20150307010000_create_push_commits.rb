class CreatePushCommits < ActiveRecord::Migration
  def change
    create_table :push_commits do |t|
      t.integer :push_id, null: false
      t.integer :commit_id, null: false

      t.timestamps null: false
    end
    remove_column :commits, :push_id
  end
end
