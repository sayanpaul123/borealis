#!/usr/bin/env bash
set -euo pipefail

dnf install -y --setopt=install_weak_deps=False \
    git cmake gcc-c++ extra-cmake-modules \
    kwin-devel \
    kf6-kconfigwidgets-devel \
    kf6-kcmutils-devel \
    kf6-ki18n-devel \
    qt6-qtbase-private-devel \
    libepoxy-devel \
    wayland-devel \
    libdrm-devel

git clone --depth 1 https://github.com/matinlotfali/KDE-Rounded-Corners /tmp/krc

cmake -S /tmp/krc -B /tmp/krc/build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DKDE_INSTALL_LIBDIR=lib64

cmake --build /tmp/krc/build -j"$(nproc)"
cmake --install /tmp/krc/build

# clean up build deps and source
dnf remove -y \
    git cmake gcc-c++ extra-cmake-modules \
    kwin-devel \
    kf6-kconfigwidgets-devel \
    kf6-kcmutils-devel \
    kf6-ki18n-devel \
    qt6-qtbase-private-devel \
    libepoxy-devel \
    wayland-devel \
    libdrm-devel

rm -rf /tmp/krc