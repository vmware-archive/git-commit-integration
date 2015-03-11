class BackfillRefCommits
  include GithubApiFactory

  def process
    return if ENV['DISABLE_BACKFILL_REF_COMMITS'] == 'true'
    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork BackfillRefCommits Started Running"

    if Push.where(commits_processed: false).present?
      puts "[gci] #{DateTime.now.utc.iso8601} Pushes with unprocessed commits exist, not backfilling ref commits."
      return
    end

    commit_count = 0
    refs = Ref.all
    refs.each do |ref|
      puts "[gci] #{DateTime.now.utc.iso8601} Backfilling commits for ref #{ref.id} - '#{ref.reference}'"
      repo = ref.repo
      github_user, github_repo = repo.user_and_repo
      github = create_github_api_from_oauth_token(repo)

      reference = ref.reference.gsub(/^refs\//, '') # remove 'ref/', e.g. 'heads/dummybranch'
      latest_sha_on_ref_github = github.git.references.get(github_user, github_repo, reference).object.sha

      commit_hashes_on_ref = github.repos.commits.list(github_user, github_repo, sha: latest_sha_on_ref_github)

      # nothing to do if shas on ref match between github and database
      shas_on_ref_github = commit_hashes_on_ref.map{ |commit_hash| commit_hash.fetch('sha')}
      shas_on_ref_db = ref.commits.reorder(committer_date: :desc).all.map{|commit| commit.sha}
      next if shas_on_ref_db == shas_on_ref_github
      puts "[gci] #{DateTime.now.utc.iso8601} ref #{ref.id} - '#{ref.reference}' is out of date, backfilling"

      ActiveRecord::Base.transaction do
        associated_commits = []
        child_commit = nil
        commit_hashes_on_ref.each do |commit_hash|
          # create or associate all existing commits on the ref
          commit = CommitFactory.new.create(commit_hash.fetch('sha'), repo, ref.reference, true, child_commit)
          child_commit = commit
          associated_commits << commit
          commit_count += 1
        end

        # flag any no-longer-existing commits as nonexistent
        associated_commit_ids = associated_commits.map { |commit| commit.id }
        ref.ref_commits.each do |existing_ref_commit|
          unless associated_commit_ids.include?(existing_ref_commit.commit_id)
            existing_ref_commit.update_attributes!(exists: false)
          end
        end
      end
    end

    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork BackfillRefCommits Finished Running, processed #{refs.size} refs and #{commit_count} commits."
  end
end
