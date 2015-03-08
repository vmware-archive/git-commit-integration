class PushCommit < ActiveRecord::Base
  belongs_to :push
  belongs_to :commit
end
