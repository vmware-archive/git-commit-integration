class ExternalLink < ActiveRecord::Base
  include OrderedCommits

  has_many :external_link_repos
  has_many :repos, through: :external_link_repos
  has_many :external_link_commits
  has_many :unordered_commits, source: :commit, through: :external_link_commits
end
