require 'rails_helper'

RSpec.describe DeployedShaScraper do
  attr_reader :scraper, :deploy, :expected_sha, :uri

  before do
    @scraper = DeployedShaScraper.new
    @deploy = double('Deploy')
    @uri = 'http://example.com/version_info'
    @expected_sha = 'abcde'
    expect(deploy).to receive(:uri).and_return(uri)
    expect(deploy).to receive(:extract_pattern).and_return('<span id="sha">([0123456789abcdef]+)<\/span>')
  end

  it 'returns the sha if the extract pattern matches the uri body' do
    response_body = "<span id=\"sha\">#{expected_sha}</span>"
    expect(scraper).to receive(:process).with("curl -s #{uri}", out: :error).and_return(response_body)

    sha = scraper.scrape(deploy)

    expect(sha).to eq(expected_sha)
  end

  it 'returns nil if the extract pattern does not match the uri body' do
    response_body = "<span id=\"sha\">!!!!!somethingelse</span>"
    expect(scraper).to receive(:process).with("curl -s #{uri}", out: :error).and_return(response_body)

    sha = scraper.scrape(deploy)

    expect(sha).to be_nil
  end

end
