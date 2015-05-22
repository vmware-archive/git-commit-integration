class BackfillRefCommits
  include GithubApiFactory

  def process
    return if ENV['DISABLE_BACKFILL_REF_COMMITS'] == 'true'
    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork BackfillRefCommits Started Running"

    if Push.where(commits_processed: false).present?
      puts "[gci] #{DateTime.now.utc.iso8601} BackfillRefCommits - Pushes with unprocessed commits exist, not backfilling ref commits."
      return
    end

    commit_count = 0
    refs = Ref.all
    refs.each do |ref|
      puts "[gci] #{DateTime.now.utc.iso8601} BackfillRefCommits - Backfilling commits for ref #{ref.id} - '#{ref.reference}' (repo #{ref.repo.url})"
      repo = ref.repo
      github_user, github_repo = repo.user_and_repo
      github = create_github_api_from_oauth_token(repo)

      reference = ref.reference.gsub(/^refs\//, '') # remove 'ref/', e.g. 'heads/dummybranch'
      latest_sha_on_ref_github = github.git.references.get(github_user, github_repo, reference).object.sha

      commit_hashes_on_ref_github = github.repos.commits.list(github_user, github_repo, sha: latest_sha_on_ref_github)

      # nothing to do if shas on ref match between github and database
      shas_on_ref_github = commit_hashes_on_ref_github.map { |commit_hash| commit_hash.fetch('sha') }
      shas_on_ref_db = ref.commits.reverse_order.all.map { |commit| commit.sha }

      shas_missing_from_db = shas_on_ref_github - shas_on_ref_db
      shas_missing_from_github = shas_on_ref_db - shas_on_ref_github # commits that were deleted / rebased away...
      if shas_missing_from_db.blank? && shas_missing_from_github.blank?
        puts "[gci] #{DateTime.now.utc.iso8601} BackfillRefCommits - ref #{ref.id} - '#{ref.reference}' is up-to-date, skipping (repo #{ref.repo.url})"

        unless shas_on_ref_db == shas_on_ref_github
          fail "[gci] #{DateTime.now.utc.iso8601} BackfillRefCommits - Unexpected error, ordering of " \
            "db vs. github commits differs for ref #{ref.reference} on repo #{ref.repo.url}. " \
            "\nshas_on_ref_db:     #{shas_on_ref_db}" \
            "\nshas_on_ref_github: #{shas_on_ref_github}"
        end

        next
      end

      puts "[gci] #{DateTime.now.utc.iso8601} BackfillRefCommits - ref #{ref.id} - '#{ref.reference}' is out of date, backfilling " \
        "(SHAs on Github but not in DB: #{shas_missing_from_db.join(',')}) (repo #{ref.repo.url})"

      associated_commits = []
      child_commit = nil
      commit_hashes_on_ref_github.each do |commit_hash|
        sha_from_github = commit_hash.fetch('sha')

        commit = nil
        ActiveRecord::Base.transaction do
          # create or associate all existing commits on the ref
          commit = CommitFactory.new.find_or_create(sha_from_github, repo, child_commit)

          # create ref and association if they don't yet exist
          RefCommitAssociator.new.associate_if_necessary(repo, ref.reference, commit)
        end

        child_commit = commit
        associated_commits << commit
        commit_count += 1

        backfill_sleep = ENV.fetch('BACKFILL_SLEEP', 0.5)
        puts "[gci] #{DateTime.now.utc.iso8601} BackfillRefCommits - sleeping #{backfill_sleep} seconds " \
            "between backfilling commits (repo #{ref.repo.url})"
        sleep backfill_sleep
      end

      # flag any no-longer-existing commits as nonexistent
      associated_commit_ids = associated_commits.map { |commit| commit.id }
      ref.reload.ref_commits.each do |existing_ref_commit|
        unless associated_commit_ids.include?(existing_ref_commit.commit_id)
          existing_ref_commit.update_attributes!(exists: false)
        end
      end
    end

    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork BackfillRefCommits Finished Running, processed #{refs.size} refs and #{commit_count} commits."
  end
end
