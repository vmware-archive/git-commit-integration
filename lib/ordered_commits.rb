require 'arel'
module OrderedCommits
  def commits
    # TODO: How to use arel for left join?  What docs say doesn't work:
    # .join(ParentCommit.arel_table, Arel::Nodes::OuterJoin)
    unordered_commits.
      joins('LEFT JOIN parent_commits ON (parent_commits.child_commit_id = commits.id)').
      reorder('committer_date ASC, parent_commits.child_secondary_sort_order DESC').
      select('commits.*, parent_commits.child_secondary_sort_order').
      distinct('commits.id')
  end
end
