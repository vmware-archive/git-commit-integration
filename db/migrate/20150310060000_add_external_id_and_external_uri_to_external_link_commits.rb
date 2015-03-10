class AddExternalIdAndExternalUriToExternalLinkCommits < ActiveRecord::Migration
  def change
    add_column :external_link_commits, :external_id, :string, null: false
    add_column :external_link_commits, :external_uri, :string, null: false
  end
end
