class Ref < ActiveRecord::Base
  has_many :pushes
  belongs_to :repo
end
