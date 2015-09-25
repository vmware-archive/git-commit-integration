class DeployRepo < ActiveRecord::Base
  belongs_to :deploy
  belongs_to :repo
end
