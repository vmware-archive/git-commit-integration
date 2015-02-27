require 'clockwork'

if ENV['RAILS_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load('.env.local')
end

module Clockwork
  handler do |job|
    system('bin/rails r lib/jobs/process_commits.rb') or raise "Clockwork job #{job} failed"
  end

  interval = ENV['PROCESS_COMMITS_INTERVAL'] ? ENV['PROCESS_COMMITS_INTERVAL'].to_i : 15
  every(interval.seconds, 'process_commits')
end
