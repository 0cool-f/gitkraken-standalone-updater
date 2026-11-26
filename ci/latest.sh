#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-or-later
# Prints the latest GitKraken Desktop version whose x64 and arm64 serverless tarballs can be downloaded,
# or nothing. The release notes page is primary; the download page is used when it shows no version.
set -eu

ua='Mozilla/5.0 (X11; Linux x86_64)'
ver=$(curl -fsSL --retry 3 -A "$ua" https://help.gitkraken.com/gitkraken-desktop/current/ \
    | grep -oE 'Version [0-9]+\.[0-9]+\.[0-9]+' | head -n 1 | cut -d' ' -f2) || true
if [ -z "$ver" ]; then
    echo "release notes page shows no version, using the download page" >&2
    ver=$(curl -fsSL --retry 3 -A "$ua" https://www.gitkraken.com/download-on-premise-serverless \
        | grep -oE 'Latest release: *[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 | grep -oE '[0-9.]+$') || true
fi
echo "$ver" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' || { echo "no upstream version found" >&2; exit 1; }

# Release notes can appear before the tarballs; HEAD requests are unreliable on this endpoint.
base=https://api.gitkraken.dev/releases/standalone/production/linux
downloadable() {
    for _ in 1 2 3 4 5; do
        curl -fsSL -r 0-0 -o /dev/null "$1" && return 0
        sleep 10
    done
    echo "version $ver has no downloadable tarball yet at $1" >&2
    return 1
}
downloadable "$base/x64/$ver/gitkraken-amd64.tar.gz" || exit 0
downloadable "$base/arm64/$ver/gitkraken-aarch64.tar.gz" || exit 0
echo "$ver"
