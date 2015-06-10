class ProcessDeployCommits
  def process
    return if ENV['DISABLE_PROCESS_DEPLOY_COMMITS'] == 'true'
    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork ProcessDeployCommits Started Running"
    deploys = Deploy.all
    deploy_commit_count = 0
    deploys.each do |deploy|
      deployed_sha = DeployedShaScraper.new.scrape(deploy)
      if deployed_sha
        DeployCommit.create_with(deployed_sha: deployed_sha).find_or_create_by!(deploy_id: deploy.id)
        deploy_commit_count += 1
      end
    end

    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork ProcessDeployCommits Finished Running, " \
      "processed #{deploys.size} deploys and #{deploy_commit_count} commits."
  end
end
