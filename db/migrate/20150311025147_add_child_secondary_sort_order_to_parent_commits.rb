class AddChildSecondarySortOrderToParentCommits < ActiveRecord::Migration
  def change
    add_column :parent_commits, :child_secondary_sort_order, :integer, null: false, default: 1
  end
end
