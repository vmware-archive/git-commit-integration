class Ref < ActiveRecord::Base
  has_many :ref_commits_including_nonexistent, class_name: 'RefCommit', dependent: :restrict_with_exception
  has_many :ref_commits, -> { where exists: true }, dependent: :restrict_with_exception
  has_many :commits, -> { order :committer_date }, through: :ref_commits, dependent: :restrict_with_exception
  belongs_to :repo
end
