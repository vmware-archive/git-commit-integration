class Commit < ActiveRecord::Base
  belongs_to :push
  belongs_to :author_github_user, :class_name => 'GithubUser', :foreign_key => 'author_github_user_id'
  belongs_to :committer_github_user, :class_name => 'GithubUser', :foreign_key => 'committer_github_user_id'
  has_many :parent_commits, dependent: :destroy

  delegate :repo, :to => :push

  validates_presence_of :author_date, :author_github_user_id, :committer_date, :committer_github_user_id, :data,
    :message, :patch_identifier, :push_id, :sha
end
