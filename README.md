# gitkraken-standalone

Keeps the AUR package [`gitkraken-standalone`](https://aur.archlinux.org/packages/gitkraken-standalone)
current through the shared [aur-ci](https://github.com/0cool-f/aur-ci) workflow. The package itself
lives only on the AUR and is built for `x86_64` and `aarch64`.

`ci/latest.sh` reads the newest version from the
[release notes](https://help.gitkraken.com/gitkraken-desktop/current/), falling back to the
[download page](https://www.gitkraken.com/download-on-premise-serverless), and prints it once both
on-premise serverless tarballs, x64 and arm64, can be downloaded.

The `update` workflow runs on `workflow_dispatch` from
[aur-scheduler](https://github.com/0cool-f/aur-scheduler); a push to `main` runs it as a dry run.

Released under the AGPL-3.0-or-later license.
