<!-- Title: Testing a PR, Last updated: 2026-07-11 -->
<!-- SPDX: CC0 (ↄ) 2026, Joshua "TomIO" Kahn -->
<sup>(This is a pre-written, saved reply.)</sup>
If you want to test this PR please download the appropriate DEB package(s)
from the build artifacts of the [associated PR's latest CI run](./30528/checks) <!-- Enter PR number manually here -->
in the Checks tab of the PR.

GitHub documentation for downloading workflow artifacts.
*https://docs.github.com/en/actions/how-tos/manage-workflow-runs/download-workflow-artifacts?tool=webui*

After downloading the build artifact, make sure to `unzip` and un-`tar` it.
You can then install the package(s) via `pkg i path/to/pkgname.deb`.

<details><summary>Detailed instructions, if needed.</summary>
<p>

```bash
# To find out what architecture you need you can
# use the `termux-info` script provided by Termux.
#
# architecture is just above your list of repositories
termux-info

# e.g.
# [...]
# Packages CPU architecture:
# aarch64
# Subscribed repositories:
# # sources.list
# deb https://packages-cf.termux.dev/apt/termux-main stable main
# [...]

# =======================

# make sure `unzip` and `tar` are installed using
pkg install unzip tar

# unzip the artifact (if you have a different architecture this might be arm, i686 or x86_64 instead)
unzip debs-aarch64-*.zip

# untar the artifact
tar xf debs-aarch64-*.tar

# You should now have a debs/ directory in your current working directory
# Install the packages from the local source using
pkg install -- ./debs/*.deb

# to clean up, you can remove the debs/ directory, .tar file and .zip file
rm -rfi debs debs-aarch64-*.zip debs-aarch64-*.tar
```

</p>
</details>
