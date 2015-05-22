class ParentCommit < ActiveRecord::Base
  belongs_to :commit
  belongs_to :child_commit, :class_name => 'Commit', :foreign_key => 'child_commit_id'

  validates_presence_of :sha
  validates_presence_of :commit_id
  validates_presence_of :child_commit_id
  validates_uniqueness_of :sha, scope: :child_commit_id
  validates_uniqueness_of :commit_id, scope: :child_commit_id, allow_nil: true
end
