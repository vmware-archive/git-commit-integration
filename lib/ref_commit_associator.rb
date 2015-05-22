class RefCommitAssociator
  include GithubApiFactory

  def associate_if_necessary(repo, reference, commit)
    ActiveRecord::Base.transaction do
      ref = find_or_create_ref(repo, reference)
      associate_commit_with_ref(commit, ref)
    end
  end

  private

  def find_or_create_ref(repo, reference)
    ref_attrs = {reference: reference, repo: repo}
    ref = Ref.where(ref_attrs).first
    unless ref
      ref_attrs[:repo] = repo
      ref = Ref.create!(ref_attrs)
      puts "[gci] #{DateTime.now.utc.iso8601} RefCommitAssociator created new ref #{reference} for repo #{repo.url}."
    end
    ref
  end

  def associate_commit_with_ref(commit, ref)
    ref_commit = commit.ref_commits.create_with(exists: true).find_or_create_by!(ref: ref)
    if ref_commit.exists? == false
      ref_commit.update_attributes!(exists: true)
      puts "[gci] #{DateTime.now.utc.iso8601} RefCommitAssociator associated commit SHA #{commit.sha} with reference #{ref.reference} for repo #{ref.repo.url}."
    else
      puts "[gci] #{DateTime.now.utc.iso8601} RefCommitAssociator did NOT associate commit SHA #{commit.sha} " \
        "with reference #{ref.reference}, because is already associated via (possibly newly created) ref_commit #{ref_commit.id}."
      # TODO: Split find and create out so that this error message can be less ambiguous
    end
  end

end
