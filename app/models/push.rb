class Push < ActiveRecord::Base
  belongs_to :repo

  validates_presence_of(:repo_id)

  def self.from_webhook(payload)
    repo_github_identifier = payload.fetch('repository').fetch('id')
    repo_id = Repo.find_by(github_identifier: repo_github_identifier).id
    self.new(
      {
        repo_id: repo_id,
        payload: payload.to_json,
        ref: payload.fetch('ref'),
        head_commit: payload.fetch('head_commit').fetch('id')
      }
    )
  end
end
