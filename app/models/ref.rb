class Ref < ActiveRecord::Base
  has_many :pushes, dependent: :restrict_with_exception
  has_many :commits, through: :pushes, dependent: :restrict_with_exception
  belongs_to :repo
end
