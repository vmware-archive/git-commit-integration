class CreateRefCommits < ActiveRecord::Migration
  def change
    create_table :ref_commits do |t|
      t.integer :ref_id, null: false
      t.integer :commit_id, null: false
      t.boolean :exists, null: false

      t.timestamps null: false
    end
  end
end
