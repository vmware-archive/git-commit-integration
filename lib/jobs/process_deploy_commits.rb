class ProcessDeployCommits
  def process
    return if ENV['DISABLE_PROCESS_DEPLOY_COMMITS'] == 'true'
    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork ProcessDeployCommits Started Running"
    deploys = Deploy.all
    deploy_commit_count = 0
    deploys.each do |deploy|
      sha = DeployedShaScraper.new.scrape(deploy)
      if sha
        DeployCommit.create_with(sha: sha).find_or_create_by!(deploy_id: deploy.id)
        deploy_commit_count += 1
      end
    end

    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork ProcessDeployCommits Finished Running, " \
      "processed #{deploys.size} deploys and #{deploy_commit_count} commits."
  end
end
