class ProcessCommits
  def process
    return if ENV['DISABLE_PROCESS_COMMITS'] == 'true'
    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork ProcessCommits Started Running"
    pushes = Push.where(commits_processed: false)
    commit_count = 0
    pushes.each do |push|
      ActiveRecord::Base.transaction do
        child_commit = nil
        push.commits_hashes_from_payload.reverse.each do |push_commit_hash|
          commit = CommitFactory.new.find_or_create(push_commit_hash.fetch('id'), push.repo, child_commit)

          # create ref and association if they don't yet exist
          RefCommitAssociator.new.associate_if_necessary(push.repo, push.ref.reference, commit)

          # associate with push if push is specified and is not already associated
          commit.pushes << push if push && !commit.pushes.include?(push)

          child_commit = commit
          commit_count += 1
        end
        push.update_attributes!(commits_processed: true)
      end
    end

    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork ProcessCommits Finished Running, " \
      "processed #{pushes.size} pushes and #{commit_count} commits."
  end
end
