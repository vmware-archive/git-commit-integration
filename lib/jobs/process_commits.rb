class ProcessCommits
  def process
    return if ENV['DISABLE_PROCESS_COMMITS'] == 'true'
    puts "#{DateTime.now.utc.iso8601} [Clockwork ProcessCommits] Started Running"
    puts "#{DateTime.now.utc.iso8601} [Clockwork ProcessCommits] processing..."
    puts "#{DateTime.now.utc.iso8601} [Clockwork ProcessCommits] Finished Running"
  end
end

ProcessCommits.new.process
