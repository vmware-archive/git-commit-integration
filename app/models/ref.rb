class Ref < ActiveRecord::Base
  has_many :ref_commits, dependent: :restrict_with_exception
  has_many :commits, -> { order :committer_date }, through: :ref_commits, dependent: :restrict_with_exception
  belongs_to :repo
end
