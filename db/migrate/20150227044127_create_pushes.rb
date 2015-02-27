class CreatePushes < ActiveRecord::Migration
  def change
    create_table :pushes do |t|
      t.string :payload
      t.string :ref
      t.string :head_commit

      t.timestamps null: false
    end
  end
end
