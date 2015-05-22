class Commit < ActiveRecord::Base
  has_many :push_commits
  has_many :pushes, through: :push_commits
  has_many :ref_commits
  has_many :refs, through: :ref_commits
  belongs_to :author_github_user, class_name: 'GithubUser', foreign_key: 'author_github_user_id'
  belongs_to :committer_github_user, class_name: 'GithubUser', foreign_key: 'committer_github_user_id'
  belongs_to :repo
  has_many :parent_commits, foreign_key: 'child_commit_id', dependent: :destroy #:restrict_with_exception
  has_many :child_commits, class_name: 'ParentCommit', foreign_key: 'commit_id', dependent: :destroy #:restrict_with_exception
  has_many :parents, through: :parent_commits, source: :commit, dependent: :restrict_with_exception
  has_many :children, through: :child_commits, source: :child_commit, dependent: :restrict_with_exception
  has_many :external_link_commits
  has_many :external_links, through: :external_link_commits

  # TODO: patch_identifier currently not populated for merge commits.
  #       See https://www.pivotaltracker.com/story/show/89873776
  #       and https://www.pivotaltracker.com/story/show/89873908
  # validates_presence_of :patch_identifier

  validates_presence_of :author_date, :author_github_user_id, :committer_date, :committer_github_user_id, :data,
    :message, :sha
  validates_uniqueness_of :sha, scope: :repo, allow_blank: false

  def exists_on_ref?(ref)
    ref_commit = self.ref_commits.where(ref: ref).first
    return false unless ref_commit
    ref_commit.exists?
  end
end
