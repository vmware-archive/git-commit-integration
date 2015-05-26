# Git Commit Integration

Exploring features described in https://github.com/pivotaltracker/git-commit-ux/blob/master/README.md

## Features

### Supporting Features
* Signup/signin with GitHub Oauth2, with authorizations to
  create a webhook for a repo and read diff/patch commit data for the repo
  (https://developer.github.com/guides/getting-started/#oauth)
* Enter a Github Repo URL which will automatically have a
  Github webhook created which will be listened to for pushes to that repository
  (https://developer.github.com/v3/repos/hooks/#create-a-hook)
* Configure an External Link which has a pattern to extract an external ID
  from a git commit message and a replacement pattern to construct an external URI from the ID
* Associate one or more External Links with a Repo
* Display pushes for a specific repo
* Display commits for a specific push
* Display all commits for a repo
* Display branches for a repo (i.e. head refs)
  * initially just for pushed refs, eventually all can be pulled via: `curl -s https://api.github.com/repos/:owner/:repo/git/refs/heads`)
* populate patch-id onto all created Commits
* Display all commits which are currently or were previously on a given branch (ref)

### Killer Features
* Display all commits which are associated with a given external link,
  grouped by which branches they exist on
* Display all commits which are associated with a given external ID
* Display differently (strikethrough) all commits which no longer currently
  exist on a branch
  * Obtained by listing all commits (https://developer.github.com/v3/repos/commits/) for each existing
    branch (i.e. head ref)
* Display differently (Grouping or Collapsing based on `patch-id`) all different commits which have different
  SHAs but are actually the same commit based on the `patch-id`

## Models

### User

Created via Github Oauth authentication.

Attributes:

* **`email`**: User's github email
* **`github_app_token`**: Token from authorizing app to access github

Associations:

* `has_many :repos`

### Repo

Attributes:

* **`url`**: URL of Github repo
* **`github_identifier`**: Internal ID of repo in github API
* **`hook`**: JSON for github webhook listening for push events: https://developer.github.com/v3/repos/hooks/#create-a-hook

Associations:

* `has_many :pushes`
* `has_many :commits, through: :pushes`
* `has_many :commits`
* `has_many :refs` (auto-updated on every push)
* `has_many :external_links, through: :repo_external_link`
* `belongs_to :user`

### GithubUser

Attributes:

* **`username`**: github username
* **`email`**: github email

Associations:

* `has_many :authored_commits, :class_name => 'Commit', :foreign_key => 'author_github_user_id'`
* `has_many :committed_commits, :class_name => 'Commit', :foreign_key => 'committer_github_user_id'`

### Push

Attributes:

* **`payload`**: Github push event raw payload json object: https://developer.github.com/v3/activity/events/types/#pushevent
* **`head_commit`**: SHA (id) of HEAD commit from push

Associations:

* `has_many :commits, through: :push_commits`
* `belongs_to :ref` (points to the full Git ref that was pushed. Example: "refs/heads/master")
* `belongs_to :repo`

### Commit

Attributes:

* **`data`**: Github commit object json
* **`sha`**: SHA of commit
* **`patch_identifier`**: patch-id of commit
  * http://git-scm.com/docs/git-patch-id
  * http://git-scm.com/book/en/v2/Git-Branching-Rebasing#Rebase-When-You-Rebase
  * `curl -H "Accept: application/vnd.github.v3.patch" -s https://api.github.com/repos/:user/:repo/commits/:sha | git patch-id --stable`
* **`message`**: Message of the commit (which may contain an external ID pattern from which an external ID
  can be extracted by an ExternalLink)
* **`author_github_user_id`**: id of author github_user
* **`author_date`**: date when this commit was originally made (http://stackoverflow.com/questions/11856983/why-git-authordate-is-different-from-commitdate)
* **`committer_github_user_id`**: id of committer github_user
* **`committer_date`**: date when this commit was last modified

Associations:

* `has_many :pushes, through: :push_commits`
* `has_many :refs, through: :ref_commits`
* `delegate :repo, :to => :push`
* `belongs_to :author_github_user, :class_name => 'GithubUser', :foreign_key => 'author_github_user_id'`
* `belongs_to :committer_github_user, :class_name => 'GithubUser', :foreign_key => 'committer_github_user_id'`
* `has_many :parent_commits`

### ParentCommit

These are parent commits of a commit.  These may or may not correspond to an existing Commit which was
created as part of a push webhook event payload.

Attributes:

* **`commit_id`**: id of child Commit
* **`sha`**: SHA of this parent commit

Associations:

* `belongs_to :commit`

### Ref

The full Git ref.  Just head refs, i.e. branches, to start with.  May add tags later.

Attributes:

* **`reference`**: The name of the fully qualified reference (i.e. `refs/heads/master`)

Associations:

* `has_many :pushes`
* `has_many :commits, through: :ref_commits`
* `belongs_to :repo`

### RefCommits

Association table between refs and commits.  `exists` flag is automatically updated after each push, by listing all
currently-existing commits on the ref, and marking previous ones as existing or not.

Attributes:

* **`exists`**: boolean, indicating whether commit currently exists in ref.

Associations:

* `belongs_to :ref`
* `belongs_to :commit`

### PushCommits

Association table between pushes and commits.

Associations:

* `belongs_to :push`
* `belongs_to :commit`

### ExternalLink

Attributes:

* **`description`**: Description of external system and link type, e.g. "Pivotal Tracker Story"
* **`extract_pattern`**: Regex to extract an ID from a commit.  E.g. `\[#(\d+)\]` or `{#(\d+)}`
* **`uri_template`**: template for URI, e.g.: `https://www.pivotaltracker.com/story/show/:id` or
   `http://external-system.example.com/objects/:id` or `http://external-system.example.com/objects/:id?param=1`
* **`replace_pattern`**: Regex to replace commit ID into uri_template, e.g.: `:id$` or `:id`

Associations:

* `has_many :commits, through: :external_link_commit`
* `has_many :repos, through: :external_link_repo`

Regex ID extraction examples:

```
2.1.5 :009 > /\[#(\d+)\]/.match('[#123] {#456}')[1]
 => "123"
2.1.5 :010 > /{#(\d+)}/.match('[#123] {#456}')[1]
 => "456"
```

Regex ID replacement examples:

```
2.1.5 :022 > 'https://www.pivotaltracker.com/story/show/:id'.gsub(/:id$/,'123')
 => "http://external-system.example.com/objects/123"
2.1.5 :022 > 'http://external-system.example.com/objects/:id'.gsub(/:id$/,'123')
 => "http://external-system.example.com/objects/123"
2.1.5 :023 > 'http://external-system.example.com/objects/:id\?param=1'.gsub(/:id/,'123')
 => "http://external-system.example.com/objects/123?param=1"
```

### ExternalLinkRepo

Join table associating external links with repos

Associations:

* `belongs_to :external_link`
* `belongs_to :repo`

### ExternalLinkCommit

Join table associating external links with commits

Attributes:

* **`external_id`**: External ID extracted from Commit based on ExternalLink
* **`external_uri`**: External ID generated from Commit based on ExternalLink

Associations:

* `belongs_to :external_link`
* `belongs_to :commit`

## Implementation Details

* Pushes will be created real-time by listening for webhooks
* Background job will run for each push, and create/update
  Refs, Commits, RefCommits, and update all RefCommit `exists` flags
  accordingly.

## Setup

### Installing/fixing postgres on OSX

```
brew update

brew install postgresql
# or
brew upgrade postgresql

brew info postgresql # follow instructions to run on boot

# DANGEROUS!
rm -rf /usr/local/var/postgres

initdb /usr/local/var/postgres -E utf8
```

### Setting up Github app and google oauth2

* (examples below are for dev env, use appropriate URL if running on PWS)
* Make a github dev application: https://github.com/settings/applications
  * application name: `git-commit-integration-dev`
  * Homepage URL: `http://localhost:3000`
  * Application Description: `dev`
  * Authorization Callback URL: `http://localhost:3000/users/auth/github/callback`
* copy .env.local.example to .env.local
* Copy the app's client id and client secret into .env.local

### Installing ngrok

Install ngrok to tunnel github webhooks to localhost (it will be run via foreman Procfile.local)

```
brew install ngrok
```

Make sure it runs, and grab the NGROK_HOST to put in your .env.local (it shouldn't change often)

```
ngrok 3000
# grab the host (just host, not protocol or path), put in env.local
# Ctrl C to kill it (it'll get run automatically by Foreman)
```

### Create dev env databases

```
bundle
bin/rake db:create:all
```

### Running specs

```
bin/rake
```

### Running dev env server

```
# everything goes to stdout (12-factor app)
bin/foreman start -f Procfile.local | tee /tmp/gci.log

# filter out app logs in another window:
tail -f /tmp/gci.log | grep '\[gci\]'
```

* (Optional) go to localhost:4040 to verify your NGROK_HOST hasn't changed
* Go to http://localhost:3000
* Sign in with Github
* Click to authorize app
* Make a repo (pick one to which you have admin access to create webhooks)
* Click (re)create Webhook on the repo (must be an admin on the repo to create hooks)
* Verify the webhook looks right in github settings
* Make a push to the repo (from a dummy branch if you don't want to clutter master):
  `EXTERNAL_ID=89109694; echo "foo - $(date)." >> foo && git add foo && git commit -m "[#${EXTERNAL_ID}] foo - $(date)" && git push`
* Verify the push record gets created in the app (via webhook going through ngrok).  Check github/ngrok if it fails.

### Running PWS prod env

* Set up cf command line (go cli): http://docs.run.pivotal.io/starting/#install-login - Tools link
* `cf login` - http://docs.run.pivotal.io/devguide/installcf/whats-new-v6.html#login
* Make a github prod application: https://github.com/settings/applications
* create a space on PWS, get cf command line, log in
* `cf push`
* Set GITHUB_KEY and GITHUB_SECRET env vars on PWS console

## Using App

* See Homepage in running app for instructions

## Debugging/Hacking

### Using Github API from rails console

See https://github.com/peter-murach/github

Basic setup:
```
bin/rails c
repo = Repo.first # or find...
```

To get a repo object directly:
```
repo_api_object = repo.github_api_object
```

To access repo object subresources (continuing from basic setup above):
```
require 'github_api_factory'
include GithubApiFactory
github_user, github_repo = repo.user_and_repo
github = create_github_api_from_oauth_token(repo)
github.repos.branches(github_user, github_repo).body.map{|branch| branch.name} # branches
github.repos.commits.all(github_user, github_repo) # all commits on default branch (master)
github.repos.commits.all(github_user, github_repo).first # first commit on default branch
github.repos.commits.all(github_user, github_repo, sha: 'some sha').first.commit.message  # get all commits then message of first
github.repos.commits.find(github_user, github_repo, 'f6afe0c8f3a1f28120a1778d257be11ee24c33d2').sha # find a commit then get its sha
github.repos.commits.find(github_user, github_repo, repo.commits.first.sha).author.login # find a commit then get its author's login
github.repos.commits.find(github_user, github_repo, repo.commits.first.sha).commit.message  # find a commit then get its message
github.git.references.list(github_user, github_repo) # list all refs for a repo
github.git.references.get(github_user, github_repo, 'heads/dummybranch') # get a single ref
github.git.references.get(github_user, github_repo, 'heads/dummybranch').object.sha # get the latest sha (commit) on a ref
github.repos.commits.list(github_user, github_repo, sha: repo.commits.first.sha) # list all commits on a ref or branch starting at sha
```

See https://developer.github.com/v3/repos/commits/ for commits structure

