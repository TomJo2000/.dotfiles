<!-- Title: Squashing commits, Last updated: 2026-03-10 -->
<!-- SPDX: CC0 (ↄ) 2026, Joshua "TomIO" Kahn -->
<sup>(This is a pre-written, saved reply.)</sup>
Please make sure to keep your commits squashed by the way.
For adding to a single commit you can use `git commit --amend`.
Since you already have multiple commits on your branch though,
you'll need to squash those with `git rebase -i --fork-point master` (or `git rebase -i HEAD~<n>`) first.
<sup>(Where <code>\<n\></code> is the number of commits you want to modify. Please make sure to only modify ***your*** commits.)</sup>
<a href="https://www.baeldung.com/ops/git-squash-commits#1-squash-the-last-x-commits">https://www.baeldung.com/ops/git-squash-commits#1-squash-the-last-x-commits</a>

<h1><em></em></h1> <!-- thin separator -->

Since rebasing, squashing or amending commits changes the git history you will need to force push any such changes.
e.g. `git push --force`,
or preferably `git push --force-with-lease --force-if-includes`
to make sure you aren't clobbering any refs you haven't fetched locally yet.
