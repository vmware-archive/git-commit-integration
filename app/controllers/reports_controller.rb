class ReportsController < ApplicationController
  def external_links
    @external_links = ExternalLink.all
  end

  def external_link_ref_commits
    @external_link = ExternalLink.find(params.fetch(:external_link_id))
  end
end
