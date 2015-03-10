class ExternalLinkCommit < ActiveRecord::Base
  belongs_to :commit
  belongs_to :external_link
end
