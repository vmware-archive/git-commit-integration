class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.string :username, null: false
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
