class ParentCommit < ActiveRecord::Base
  belongs_to :commit

  validates_presence_of :sha
end
