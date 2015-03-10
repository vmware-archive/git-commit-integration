class CreateExternalLinks < ActiveRecord::Migration
  def change
    create_table :external_links do |t|
      t.string :description, null: false
      t.string :extract_pattern, null: false
      t.string :uri_template, null: false
      t.string :replace_pattern, null: false

      t.timestamps null: false
    end
  end
end
