class Push < ActiveRecord::Base
  include OrderedCommits

  has_many :push_commits, dependent: :restrict_with_exception
  has_many :unordered_commits, source: :commit, through: :push_commits, dependent: :restrict_with_exception
  belongs_to :ref
  belongs_to :repo

  validates_presence_of(:repo_id)
  validates_presence_of(:ref_id)

  def self.from_webhook(payload, repo)
    reference = payload.fetch('ref')
    ref = Ref.create_with(repo: repo).find_or_create_by(reference: reference)
    head_commit = payload.fetch('head_commit').fetch('id')
    unless push = Push.find_by(ref_id: ref.id, head_commit: head_commit)
      attrs = {
        payload: payload.to_json,
        ref_id: ref.id,
        repo_id: repo.id,
        head_commit: head_commit
      }

      push = Push.new(
        attrs
      )
      push.save!
    end
    push
  end

  def commits_hashes_from_payload
    payload_hash = JSON.parse(payload)
    commit_hashes = payload_hash.fetch('commits')
    commit_hashes
  end
end
