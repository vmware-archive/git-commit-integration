class CommitFactory
  include GithubApiFactory

  def find_or_create(sha, repo, child_commit)
    find_or_create_commit(sha, repo, child_commit)
  end

  private

  def find_or_create_commit(sha, repo, child_commit)
    commit = Commit.find_by_sha(sha)

    is_latest_commit_on_ref = child_commit.blank?

    github_user, github_repo = repo.user_and_repo
    github = create_github_api_from_oauth_token(repo)
    github.repos.commits(github_user, github_repo)
    commit_api_response = github.repos.commits.find(github_user, github_repo, sha)
    commit_api_object = commit_api_response.commit

    ActiveRecord::Base.transaction do
      unless commit
        # set attributes which found in full commit hash obtained directly via github api
        commit = Commit.new
        commit.data = commit_api_object.to_hash.to_json
        commit.message = commit_api_object.message
        commit.sha= sha
        commit.repo = repo

        # create associated objects
        author = GithubUser.find_or_create_by!(
          {
            username: commit_api_object.author.name,
            email: commit_api_object.author.email,
          }
        )
        commit.author_github_user = author
        commit.author_date = DateTime.parse(commit_api_object.author.date)

        committer = GithubUser.find_or_create_by!(
          {
            username: commit_api_object.committer.name,
            email: commit_api_object.committer.email,
          }
        )
        commit.committer_github_user = committer
        commit.committer_date = DateTime.parse(commit_api_object.committer.date)

        commit.save!
      end

      # update child commit's ParentCommit relationship to point to this commit
      unless is_latest_commit_on_ref
        matching_parent_commit = child_commit.parent_commits.where(sha: commit.sha).first
        unless matching_parent_commit
          raise "[gci] #{DateTime.now.utc.iso8601} Unable to find parent commit for child commit id " \
              "#{child_commit.id} (SHA #{child_commit.sha}). The SHA #{commit.sha} needs " \
              "to have a parent_commit record created and associated with parent commit_id #{commit.id} " \
              "and child_commit_id #{child_commit.id}"
        end
        matching_parent_commit.update_attributes!(commit_id: commit.id)
      end

      # create parent commits (association)
      commit_api_response.parents.each do |parent_hash|
        attrs = {
          commit_id: nil
        }
        if parent = Commit.find_by_sha(parent_hash.sha)
          attrs[:commit_id] = parent.id
        end
        # handle proper sorting of commits which have the same committer_date...
        if !is_latest_commit_on_ref && child_commit.committer_date == commit.committer_date
          attrs[:child_secondary_sort_order] = matching_parent_commit.child_secondary_sort_order + 1
        end
        commit.parent_commits.create_with(attrs).
          find_or_create_by!(sha: parent_hash.sha)
      end

      if commit.parent_commits.size <= 1 # only generate patch_identifier for non-merge commits
        # obtain patch_identifier attribute
        patch_identifier = PatchIdGenerator.new.generate(
          github_user, github_repo, sha, repo.user.github_app_token
        )
        commit.update_attributes!(patch_identifier: patch_identifier)
      else
        puts "[gci] #{DateTime.now.utc.iso8601} Skipping patch-id generation for commit #{commit.id} " \
              "on repo #{repo.id} with SHA #{commit.sha}, because it has" \
              "more than one parent and is therefore a merge commit."
      end
    end

    puts "[gci] #{DateTime.now.utc.iso8601} CommitFactory created new commit SHA #{sha} for repo #{repo.url}."
    commit
  end
end
