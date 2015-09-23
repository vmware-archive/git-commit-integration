class ReportsController < ApplicationController
  def external_link_ref_commits
    @external_link = ExternalLink.find(params.fetch(:external_link_id))
  end

  def deploy_external_link_ref_commits
    @deploy = Deploy.find(params.fetch(:deploy_id))
    @external_link = ExternalLink.find(params.fetch(:external_link_id))
  end
end
