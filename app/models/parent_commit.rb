class ParentCommit < ActiveRecord::Base
  belongs_to :commit
  belongs_to :child_commit, :class_name => 'Commit', :foreign_key => 'child_commit_id'

  validates_presence_of :sha
  validates_presence_of :child_commit_id
  validates_uniqueness_of :sha, scope: :child_commit_id
  validates_uniqueness_of :commit_id, scope: :child_commit_id, allow_nil: true

  # Note we do NOT validate presence of commit_id (the ID of associated parent commit)
  # as this may not yet be present in the database when this record is created
  # (upon demand, in order to be proactively associated with a child commit)
end
