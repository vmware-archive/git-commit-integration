class AddAppTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :github_app_token, :string
  end
end
