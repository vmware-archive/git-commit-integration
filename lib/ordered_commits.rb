module OrderedCommits
  def commits
    unordered_commits.
      joins(:parent_commits).
      reorder('committer_date ASC, child_secondary_sort_order DESC')
  end
end
