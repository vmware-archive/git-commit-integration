class DeployCommit < ActiveRecord::Base
  belongs_to :deploy
  belongs_to :commit, foreign_key: :sha, primary_key: :sha
end
