GITHUB_ACCESS_TOKEN = 'your_github_api_access_token'
INTERCOM_ACCESS_TOKEN = 'your_intercom_api_access_token'
REPO_NAME_WITH_OWNER = 'owner/repo'

# Here is the explanation for the code below:
# 1. Intercom sends a webhook to your app
# 2. We create a GitHub issue from Intercom ticket payload
# 3. We update Intercom ticket with GitHub issue URL
# 4. GitHub issue gets closed - GitHub sends a webhook to your app
# 5. We update Intercom ticket status to "resolved"

post '/tickets' do
  # Create a GitHub issue from Intercom ticket payload:
  notification = JSON.parse(request.body.read)
  ticket_title = notification["data"]["item"]["ticket_attributes"]["_default_title_"]
  ticket_description = notification["data"]["item"]["ticket_attributes"]["_default_description_"]
  ticket_id = notification["data"]["item"]["id"]

  client = Octokit::Client.new(access_token: GITHUB_ACCESS_TOKEN)

  # Note that we store Intercom ticket id within the issue title: in real world scenarios you would probably store this elsewhere.
  github_issue = client.create_issue(REPO_NAME_WITH_OWNER, ticket_title + " [Intercom ticket number: " + ticket_id + "]", ticket_description)

  # Update Intercom ticket with GitHub issue link:
  github_issue_url = github_issue.html_url

  intercom_ticket_endpoint = "https://api.intercom.io/tickets/#{ticket_id}"
  token_string= "Token token = #{INTERCOM_ACCESS_TOKEN}"
  data = { ticket_attributes: { github_issue_url: "#{github_issue_url}" } }
  response = HTTParty.put(intercom_ticket_endpoint, body: data.to_json, headers: { 'Content-Type': 'application/json', 'Authorization': token_string, 'Intercom-Version': '2.9'})
end


post '/issues' do
  notification = JSON.parse(request.body.read)

  if notification["action"] == "closed"
    # Parse the ticket id from the issue title:
    ticket_id = notification["issue"]["title"][/Intercom ticket number:\s*(\d+)\]/, 1]

    intercom_ticket_endpoint = "https://api.intercom.io/tickets/#{ticket_id}"
    token_string= "Token token=#{INTERCOM_ACCESS_TOKEN}"
    data = { state: "resolved" }

    # Update Intercom ticket state to mark it as "resolved":
    response = HTTParty.put(intercom_ticket_endpoint, body: data.to_json, headers: { 'Content-Type': 'application/json', 'Authorization': token_string, 'Intercom-Version': '2.9'})
  end
end






