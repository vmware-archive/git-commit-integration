class CreateDeploys < ActiveRecord::Migration
  def change
    create_table :deploys do |t|
      t.string :name
      t.string :uri
      t.string :extract_pattern

      t.timestamps null: false
    end
  end
end
