class Commit < ActiveRecord::Base
  has_many :push_commits
  has_many :pushes, through: :push_commits
  has_many :ref_commits
  has_many :refs, through: :ref_commits
  belongs_to :author_github_user, :class_name => 'GithubUser', :foreign_key => 'author_github_user_id'
  belongs_to :committer_github_user, :class_name => 'GithubUser', :foreign_key => 'committer_github_user_id'
  belongs_to :repo
  has_many :parent_commits, dependent: :destroy

  validates_presence_of :author_date, :author_github_user_id, :committer_date, :committer_github_user_id, :data,
    :message, :patch_identifier, :sha

  def exists_on_ref?(ref)
    ref_commit = self.ref_commits.where(ref: ref)
    return false unless ref_commit
    ref_commit.exists?
  end
end
