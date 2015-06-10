class DeployedShaScraper
  include ProcessHelper

  def scrape(deploy)
    deploy_uri_body = process("curl -s #{deploy.uri}", out: :error)

    match = /#{deploy.extract_pattern}/.match(deploy_uri_body)

    match.present? ? match[1] : nil
  end
end
