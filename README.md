# Ruby Tickets API Sample

This is a sample [Sinatra](https://sinatrarb.com/intro.html) application that demonstrates how to use the [Intercom Tickets API](https://developers.intercom.com/intercom-api-reference/reference/post_tickets) to generate GitHub issues whenever a ticket is created in Intercom.

## Prerequisites
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/) and [RubyGems](https://rubygems.org/pages/download) installed.
- You'll need an Intercom developer workspace and an Intercom app. If you don't, follow this [guide](https://developers.intercom.com/building-apps/docs/welcome#step-1-create-an-intercom-workspace).
- You'll need access to the Tickets feature. If you don’t, follow this [guide](https://www.intercom.com/help/en/articles/6604593-how-to-access-tickets-features).
- You'll need a [token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with access to a GitHub repo where you'd like to create your new issues.

## Installing
- Clone this repo
- Run `bundle install` to install dependencies
- Update the `server.rb` file with your Intercom and GitHub credentials
- Replace `REPO_NAME_WITH_OWNER` in `server.rb` with details of the GitHub repo you'd like to create issues in 
- Run `ruby server.rb` to start the server
