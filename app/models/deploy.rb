class Deploy < ActiveRecord::Base
  has_many :commits, through: :deploy_commits
  has_many :deploy_commits
  has_many :repos, through: :deploy_repos
  has_many :deploy_repos
end
