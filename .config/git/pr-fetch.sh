#!/usr/bin/env bash

(( $# )) || { # did we get any args?
    printf 'Usage: %s\n' "git pr-fetch int [...]"
    exit 1
}

function fetch-pr() {
    local pr="$1" merged state origin_url origin_branch

    read -rd' ' merged state origin_url origin_branch < <(curl -sL \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/termux/termux-packages/pulls/${pr}" \
        | jq -r '.merged, .state, .head.repo.ssh_url, .head.ref'
    )

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
    if [[ "$origin_url" != "$(git config --get "remote.pr${pr}.url")" ]]; then
        printf '%b\n' "Setting up remote: '\e[32mpr${pr}\e[m'"
        # Add the "pr${pr}" remote, tracking the PR branch
        git remote add -t "${origin_branch}" "pr${pr}" "${origin_url}"
    else
        printf '%b\n' "Remote alread exists: '\e[32mpr${pr}\e[m'"
    fi
    printf '%b\n' \
        "Fork URL : \e[33m${origin_url}\e[m" \
        "PR branch: \e[34m${origin_branch}\e[m"

    # Is the PR fetched to a local branch yet?
    git show-ref --quiet "refs/heads/${origin_branch}" || {
        git fetch "pr${pr}" "refs/heads/${origin_branch}:${origin_branch}"
        git branch "${origin_branch}" --set-upstream-to="pr${pr}/${origin_branch}"
    }

    printf '%b' "Tracking : "
    git for-each-ref "refs/heads/${origin_branch}" \
    --format="%1b[32m${origin_branch}%1b[m...%1b[31m%(upstream:short)%1b[m%0a"
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
    printf '%s\n' "error: No such remote 'upstream'"
    exit 2
}

# check API rate limits.
gh_api_limits "$#"

for num in "$@"; do
    fetch-pr "$num"
done
