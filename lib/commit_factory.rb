class CommitFactory
  include GithubApiFactory

  def create(sha, repo, reference, exists, push = nil)
    ActiveRecord::Base.transaction do
      commit = Commit.find_by_sha(sha)
      unless commit
        commit = Commit.new

        # set attributes which found in full commit hash obtained directly via github api
        github_user, github_repo = repo.user_and_repo
        github = create_github_api_from_oauth_token(repo)
        github.repos.commits(github_user, github_repo)
        commit_api_response = github.repos.commits.find(github_user, github_repo, sha)
        commit_api_object = commit_api_response.commit
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

        # create parent commits (association)
        commit_api_response.parents.each do |parent_hash|
          commit_id = nil
          if parent = Commit.find_by_sha(parent_hash.sha)
            commit_id = parent.id
          end
          commit.parent_commits.create_with(commit_id: commit_id).
            find_or_create_by!(sha: parent_hash.sha)
        end

        if commit.parent_commits.size == 1
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

      # create ref and association if they don't yet exist
      ref = Ref.create_with(repo: repo).find_or_create_by!(reference: reference)
      ref_commit = commit.ref_commits.create_with(exists: exists).find_or_create_by!(ref: ref)
      ref_commit.update_attributes!(exists: exists) unless ref_commit.exists? == exists

      # associate with push if push is specified and is not already associated
      commit.pushes << push if push && !commit.pushes.include?(push)

      commit
    end
  end
end
