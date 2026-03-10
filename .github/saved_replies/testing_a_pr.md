<!-- Title: Testing a PR, Last updated: 2026-03-10 -->
<!-- SPDX: CC0 (ↄ) 2026, Joshua "TomIO" Kahn -->
<sup>(This is a pre-written, saved reply.)</sup>
If you want to test this PR please download the appropriate DEB package(s)
from the build artifacts of the [associated PR's latest CI run](https://github.com/termux/termux-packages/actions/runs/22800899053?pr=28840).

<img width="1029" height="1665" alt="image" src="https://github.com/user-attachments/assets/2d9c9820-b089-489e-9c45-9c65e036ef61" />

After downloading the build artifact, make sure to `unzip` and un-`tar` it.
<details><summary>Detailed instructions, if needed.</summary>
<p>

```bash
# finding out what architecture you need
# architecture is just below the TERMUX_VERSION
termux-info

# e.g.
# [...]
# TERMUX__UID=10228
# TERMUX__USER_ID=0
# Packages CPU architecture:
# aarch64
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
