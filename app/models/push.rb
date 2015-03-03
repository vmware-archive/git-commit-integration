class Push < ActiveRecord::Base
  has_many :commits, dependent: :restrict_with_exception
  belongs_to :repo

  validates_presence_of(:repo_id)

  def self.from_webhook(payload)
    self.new(
      {
        payload: payload.to_json,
        ref: payload.fetch('ref'),
        head_commit: payload.fetch('head_commit').fetch('id')
      }
    )
  end

  def commits_hashes_from_payload
    payload_hash = JSON.parse(payload)
    commit_hashes = payload_hash.fetch('commits')
    commit_hashes
  end
end
