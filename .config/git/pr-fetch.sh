#!/usr/bin/env bash

(( $# )) || { # did we get any args?
    printf 'Usage: %s\n' "git pr-fetch <int> [...]"
    exit 1
}

function fetch-pr() {
    local pr="$1" merged state pr_origin_url pr_branch local_branch branch

    read -rd' ' merged state pr_origin_url pr_branch < <(curl -sL \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/${upstream}/pulls/${pr}" \
        | jq -r '.merged, .state, .head.repo.ssh_url, .head.ref')

    # Is the PR already merged?
    [[ "$merged" == 'true' ]] && {
        printf '%b\n' "\e[35mPR ${pr}\e[m: already merged."
        return 1
    }

    # Is the PR closed?
    [[ "$state" == 'closed' ]] && {
        printf '%b\n' "\e[31mPR ${pr}\e[m: is closed."
        return 128
    }

    printf '%b\n\n' \
        "\e[32mPR ${pr}\e[m: unmerged and open."

    # Is the PR's origin remote set up?
    if [[ "$pr_origin_url" != "$(git remote get-url "pr${pr}" 2> /dev/null)" ]]; then
        printf '%b\n' "Setting up remote: '\e[32mpr${pr}\e[m'"
        # Add the "pr${pr}" remote, tracking the PR branch
        git remote add -t "${pr_branch}" "pr${pr}" "${pr_origin_url}"
    else
        printf '%b\n' "Remote alread exists: '\e[32mpr${pr}\e[m'"
    fi
    printf '%b\n' \
        "Fork URL : \e[33m${pr_origin_url}\e[m" \
        "PR branch: \e[34m${pr_branch}\e[m"

    # Check for branch name conflicts
    local_branch="${pr_branch}"
    for branch in "$(git rev-parse --git-dir)/refs/heads/"*; do
        [[ "${branch##*/}" == "${pr_branch}" ]] && {
            printf '%b\n' \
                "\e[1;31mBranch name collision detected.\e[m" \
                "Renaming : \e[34m${pr_branch}\e[m -> \e[32m${pr}-${pr_branch}\e[m"
            local_branch="${pr}-${pr_branch}"
            break
        }
    done

    # Is the PR fetched to a local branch yet?
    git show-ref --quiet "refs/heads/${local_branch}" || {
        git fetch "pr${pr}" "refs/heads/${pr_branch}:${local_branch}" -q
        git branch "${local_branch}" --set-upstream-to="pr${pr}/${pr_branch}"
    }

    printf '%b' "Tracking : "
    git for-each-ref "refs/heads/${local_branch}" \
    --format="%1b[32m${local_branch}%1b[m...%1b[31m%(upstream:short)%1b[m%0a"
}

function gh_api_limits() {
    local used limit reset reset_m reset_s

    read -rd' ' used limit reset < <( curl -sL \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -H "Accept: application/vnd.github+json" \
        https://api.github.com/rate_limit \
        | jq -r '.rate.used, .rate.limit, .rate.reset')

    (( reset  -= EPOCHSECONDS ))
    (( reset_m = reset / 60   ))
    (( reset_s = reset % 60   ))

    printf '%b' \
        "GitHub API usage: " \
        "\e[33m$((used + $1))\e[m/\e[33m${limit}\e[m " \
        "(resets in: \e[34m${reset_m}m${reset_s}s\e[m)\n"
}

# do we have an upstream remote?
git remote get-url upstream &> /dev/null || {
    printf '%b\n' \
        "error: No such remote 'upstream'" \
        "\e[33mgit remote add upstream <URL>\e[m"
    exit 2
}

# check API rate limits.
gh_api_limits "$#"

: "$(git remote get-url upstream)"
: "${_#*.com[:/]}"
upstream="${_%.git}"

for num in "$@"; do
    fetch-pr "$num"
done

unset upstream
