class CommitFactory
  include GithubApiFactory

  def create(sha, repo, reference, exists, push = nil)
    ActiveRecord::Base.transaction do
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

      # obtain patch_identifier attribute
      commit.patch_identifier = PatchIdGenerator.new.generate(github_user, github_repo, sha)

      commit.save!

      # create parent commits
      commit_api_response.parents.each do |parent|
        commit.parent_commits.create!(sha: parent.sha)
      end

      # create ref and association if they don't yet exist
      ref = Ref.create_with(repo: repo).find_or_create_by(reference: reference)
      commit.ref_commits.create!(ref: ref, exists: exists)

      # associate with push if specified
      commit.pushes << push if push

      commit
    end
  end
end
