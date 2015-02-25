# Git Commit Integration

Exploring features described in https://github.com/pivotaltracker/git-commit-ux/blob/master/README.md

## Features

### Supporting Features
* Signup/signin with GitHub Oauth2, with authorizations to
  create a webhook for a repo and read diff/patch commit data for the repo
  (https://developer.github.com/guides/getting-started/#oauth)
* I should be able to enter a Github Repo URL which will automatically have a
  Github webhook created which will be listened to for pushes to that repository
  (https://developer.github.com/v3/repos/hooks/#create-a-hook)
* Configure an External Link which has a pattern to extract an external ID
  from a git commit message and a replacement pattern to construct an external URI from the ID
* Associate one or more External Links with a Repo
* Display one or all pushes for a repo
* Display one or all commits for a repo
* Display all branches for a repo (i.e. head refs: `curl -s https://api.github.com/repos/:owner/:repo/git/refs/heads`)
* Display one or all commits for a given ref (branch)

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
* Display all commits which are currently or were previously on a given branch

## Models

### Repo

Attributes:

* **`repo`**: URI of Github repo
* **`hook`**: JSON for github webhook listening for push events: https://developer.github.com/v3/repos/hooks/#create-a-hook

Associations:

* `has_many :pushes`
* `has_many :commits`
* `has_many :refs` (auto-updated on every push)
* `has_many :external_links, through: :repo_external_link`

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
* **`ref`**: The full Git ref that was pushed. Example: “refs/heads/master”
* **`head_commit`**: SHA (id) of HEAD commit from push

Associations:

* `has_many :commits`
* `belongs_to :repo

### Commit

Attributes:

* **`data`**: Github commit object json
* **`sha`**: SHA of commit
* **`parent_sha`**: SHA of commit's parent
* **`patch_id`**: patch-id of commit
  * http://git-scm.com/docs/git-patch-id
  * http://git-scm.com/book/en/v2/Git-Branching-Rebasing#Rebase-When-You-Rebase
  * `curl -H "Accept: application/vnd.github.v3.patch" -s https://api.github.com/repos/:user/:repo/commits/:sha | git patch-id --stable`
* **`message`**: Message of the commit (which may contain an external ID pattern from which an external ID
  can be extracted by an ExternalLink)
* **`author_github_user_id`**: github username of author
* **`author_date`**: date when this commit was originally made (http://stackoverflow.com/questions/11856983/why-git-authordate-is-different-from-commitdate)
* **`committer_github_user_id`**: github username of committer
* **`committer_date`**: date when this commit was last modified

Associations:

* `belongs_to :push`
* `belongs_to :repo`
* `belongs_to :author_github_user, :class_name => 'GithubUser', :foreign_key => 'author_github_user_id'`
* `belongs_to :committer_github_user, :class_name => 'GithubUser', :foreign_key => 'committer_github_user_id'`

### Ref

Git ref.  just head refs, i.e. branches, to start with.  May add tags later.

Attributes:

* **`reference`**: The name of the fully qualified reference (i.e. `refs/heads/master`)
* **`repo_id`**: ID of repo

Associations:

* `belongs_to :repo`

### RefCommits

Association table between refs and commits.  `exists` flag is automatically updated after each push, by listing all
currently-existing commits on the ref, and marking previous ones as existing or not.

* **`ref_id`**: ID of ref
* **`commit_id`**: ID of commit
* **`exists`**: boolean, indicating whether commit currently exists in ref.

### ExternalLink

Attributes:

* **`description`**: Description of external system and link type, e.g. "Pivotal Tracker Story"
* **`extract_pattern`**: Regex to extract an ID from a commit.  E.g. `[#(\d+)\]` or `{#(\d+)}`
* **`uri_template`**: template for URI, e.g.: `http://external-system.example.com/objects/:id` or `http://external-system.example.com/objects/:id?param=1`
* **`replace_pattern`**: Regex to replace commit ID into uri_template, e.g.: `:id$` or `:id`

Associations:

* `has_many :commits`
* `has_many :repos, through: :repo_external_link`

Regex ID extraction examples:

```
2.1.5 :009 > /\[#(\d+)\]/.match('[#123] {#456}')[1]
 => "123"
2.1.5 :010 > /{#(\d+)}/.match('[#123] {#456}')[1]
 => "456"
```

Regex ID replacement examples:

```
2.1.5 :022 > 'http://external-system.example.com/objects/:id'.gsub(/:id$/,'123')
 => "http://external-system.example.com/objects/123"
2.1.5 :023 > 'http://external-system.example.com/objects/:id\?param=1'.gsub(/:id/,'123')
 => "http://external-system.example.com/objects/123?param=1"
```

### RepoExternalLink

Join table associating external links with repos

Attributes:

* **`repo_id`**: id of Repo
* **`external_link_id`**: id of ExternalLink

Associations:

* `belongs_to :repo`
* `belongs_to :external_link`

## Implementation Details

* Pushes will be created real-time by listening for webhooks
* Background job will run for each push, and create/update
  Refs, Commits, RefCommits, and update all RefCommit `exists` flags
  accordingly.

