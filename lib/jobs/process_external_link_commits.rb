class ProcessExternalLinkCommits
  def process
    return if ENV['DISABLE_PROCESS_EXTERNAL_LINK_COMMITS'] == 'true'
    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork ProcessExternalLinkCommits Started Running"
    external_links = ExternalLink.all
    commit_count = 0
    external_links.each do |external_link|
      commits_processed_thru = external_link.commits_processed_thru
      if commits_processed_thru.blank?
        commits_processed_thru = DateTime.parse("1970-1-1")
        external_link.update_attributes!(commits_processed_thru: commits_processed_thru)
      end
      commits = Commit.where('committer_date >= ?', commits_processed_thru).all
      if commits.present?
        ActiveRecord::Base.transaction do
          commits.each do |commit|
            next if commit.external_links.include?(external_link) # to avoid reprocessing latest commit(s)
            external_link_uri_generator = ExternalLinkUriGenerator.new(external_link, commit)
            if external_link_uri_generator.has_match?
              generated_external_id_and_uri = external_link_uri_generator.generate
              ExternalLinkCommit.create!(
                commit_id: commit.id,
                external_link_id: external_link.id,
                external_id: generated_external_id_and_uri.fetch(:external_id),
                external_uri: generated_external_id_and_uri.fetch(:external_uri),
              )
              commit_count += 1
            end
          end
          external_link.update_attributes!(commits_processed_thru: commits.last.committer_date)
        end
      end
    end

    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork ProcessExternalLinkCommits Finished Running, " \
      "processed #{external_links.size} external_links and #{commit_count} commits."
  end
end
