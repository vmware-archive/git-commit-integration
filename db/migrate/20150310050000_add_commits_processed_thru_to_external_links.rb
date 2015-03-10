class AddCommitsProcessedThruToExternalLinks < ActiveRecord::Migration
  def change
    add_column :external_links, :commits_processed_thru, :datetime, null: true
  end
end
