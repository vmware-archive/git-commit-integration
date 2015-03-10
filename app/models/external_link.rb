class ExternalLink < ActiveRecord::Base
  has_many :external_link_repos
  has_many :repos, through: :external_link_repos
  has_many :external_link_commits
  has_many :commits, through: :external_link_commits
end
