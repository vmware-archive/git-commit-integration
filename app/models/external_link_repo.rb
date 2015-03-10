class ExternalLinkRepo < ActiveRecord::Base
  belongs_to :repo
  belongs_to :external_link
end
