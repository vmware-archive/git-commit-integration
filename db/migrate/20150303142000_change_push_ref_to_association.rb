class ChangePushRefToAssociation < ActiveRecord::Migration
  def change
    add_column :pushes, :ref_id, :integer, null: false
    remove_column :pushes, :ref
  end
end
