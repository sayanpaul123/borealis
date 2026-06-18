#!/usr/bin/env bash
set -euo pipefail

# Get the KWin version currently in the image
KWIN_VER=$(rpm -q kwin-common --qf '%{version}')

# Install the matching version from COPR
dnf copr enable -y matinlotfali/KDE-Rounded-Corners
dnf install -y --setopt=install_weak_deps=False \
    "kwin-effect-roundcorners-*-${KWIN_VER}.*"
dnf copr disable -y matinlotfali/KDE-Rounded-Corners