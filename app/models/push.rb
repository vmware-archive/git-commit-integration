class Push < ActiveRecord::Base
  def self.from_webhook(payload)
    self.new(
      {
        payload: payload.to_json,
        ref: payload.fetch('ref'),
        head_commit: payload.fetch('head_commit').fetch('id')
      }
    )
  end
end
