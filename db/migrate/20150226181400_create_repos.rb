class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.text :url, null: false
      t.text :hook

      t.timestamps null: false
    end
  end
end
