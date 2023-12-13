#!/usr/bin/env zsh
# shellcheck shell=bash # ?? Shellcheck doesn't officially support Zsh linting, Bash is a close enough analog in most cases.

# Comment styling
# ** Highlight
# ?? Informational
# <> annotations for whole code blocks, i.e purpose of a function, bracegroup, loop, etc.
# !! Important
# ~~ Invalidated
# (TODO) Todo comments
# (WIP) Work in Progress
# (ACK) acknowledgment
# (RegEx) additional explanations for RegEx

kill "${SSH_AGENT_PID}" # clean up dangling `ssh-agent`'s on logout

# <> Loading order for Zsh startup files.
# +----------------+-----------+-----------+------+ +----------------------------+
# |                |Interactive|Interactive|Script| |                            |
# |     Login      |login      |non-login  |      | |     Logout                 |
# +----------------+-----------+-----------+------+ +----------------+-----------+
# | /etc/zshenv    |     A     |     A     |   A  | | ~/.zlogout     |     I     |
# +----------------+-----------+-----------+------+ +----------------+-----------+
# | ~/.zshenv      |     B     |     B     |   B  | | /etc/zlogout   |     J     |
# +----------------+-----------+-----------+------+ +----------------+-----------+
# | /etc/zprofile  |     C     |           |      |
# +----------------+-----------+-----------+------+
# | ~/.zprofile    |     D     |           |      |
# +----------------+-----------+-----------+------+
# | /etc/zshrc     |     E     |     C     |      |
# +----------------+-----------+-----------+------+
# | ~/.zshrc       |     F     |     D     |      |
# +----------------+-----------+-----------+------+
# | /etc/zlogin    |     G     |           |      |
# +----------------+-----------+-----------+------+
# | ~/.zlogin      |     H     |           |      |
# +----------------+-----------+-----------+------+
