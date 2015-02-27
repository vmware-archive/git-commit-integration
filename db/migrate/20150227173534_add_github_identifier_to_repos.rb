class AddGithubIdentifierToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :github_identifier, :integer, null: false
  end
end
