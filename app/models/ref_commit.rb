class RefCommit < ActiveRecord::Base
  belongs_to :ref
  belongs_to :commit
end
