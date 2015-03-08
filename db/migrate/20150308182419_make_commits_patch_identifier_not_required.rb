class MakeCommitsPatchIdentifierNotRequired < ActiveRecord::Migration
  def change
    change_column :commits, :patch_identifier, :string, null: true
  end
end
