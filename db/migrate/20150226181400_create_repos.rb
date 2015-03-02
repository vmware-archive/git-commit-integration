class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.integer :user_id, null: false
      t.text :url, null: false
      t.text :hook

      t.timestamps null: false
    end
  end
end
