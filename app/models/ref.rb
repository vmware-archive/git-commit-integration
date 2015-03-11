class Ref < ActiveRecord::Base
  include OrderedCommits

  has_many :ref_commits_including_nonexistent, class_name: 'RefCommit', dependent: :restrict_with_exception
  has_many :ref_commits, -> { where exists: true }, dependent: :restrict_with_exception
  has_many :unordered_commits, source: :commit, through: :ref_commits, dependent: :restrict_with_exception
  belongs_to :repo
end
