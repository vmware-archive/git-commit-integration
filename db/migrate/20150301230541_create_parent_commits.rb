class CreateParentCommits < ActiveRecord::Migration
  def change
    create_table :parent_commits do |t|
      t.integer :commit_id, null: false
      t.string :sha, null: false

      t.timestamps null: false
    end
  end
end
