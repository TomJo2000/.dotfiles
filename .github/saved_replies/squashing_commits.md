<!-- Title: Squashing commits, Last updated: 2026-03-30 -->
<!-- SPDX: CC0 (ↄ) 2026, Joshua "TomIO" Kahn -->
<sup>(This is a pre-written, saved reply.)</sup>
Please make sure to keep your commits squashed.
For adding to a single commit you can use `git commit --amend`.
Since you already have multiple commits on your branch though,
you'll need to squash those with `git rebase -i --fork-point master` first.
<a href="https://www.baeldung.com/ops/git-squash-commits#1-squash-the-last-x-commits">https://www.baeldung.com/ops/git-squash-commits#1-squash-the-last-x-commits</a>
<h6>Or alternatively use <code>git rebase -i HEAD~&ltn&gt</code> if you can't rebase against the <code>master</code> branch,<br>
e.g if you used <code>master</code> as your PR branch.<br>
Where <code>&ltn&gt</code> is the number of commits you want to modify.<br>
Please make sure to only modify <b><i>your</b></i> commits.)</h6>

<h1><em></em></h1> <!-- thin separator -->

Since rebasing, squashing or amending commits changes the git history you will need to force push any such changes.
e.g. `git push --force`,
or preferably `git push --force-with-lease --force-if-includes`
to make sure you aren't clobbering any refs you haven't fetched locally yet.
