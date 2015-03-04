class CreateRefs < ActiveRecord::Migration
  def change
    create_table :refs do |t|
      t.string :reference
      t.integer :repo_id

      t.timestamps null: false
    end
  end
end
