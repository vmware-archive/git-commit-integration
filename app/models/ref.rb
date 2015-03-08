class Ref < ActiveRecord::Base
  has_many :ref_commits, dependent: :restrict_with_exception
  has_many :commits, through: :ref_commits, dependent: :restrict_with_exception
  belongs_to :repo
end
