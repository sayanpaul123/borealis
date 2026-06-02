#!/usr/bin/env bash
set -euo pipefail

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q "${KERNEL_NAME:-kernel}" --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

echo "=== Building kvmfr for kernel ${KERNEL} on Fedora ${RELEASE} ==="

# Fedora 41+ uses the rawhide COPR build
# if [[ "${RELEASE}" -ge 41 ]]; then
#     COPR_RELEASE="rawhide"
# else
#     COPR_RELEASE="${RELEASE}"
# fi

# Add hikariknight COPR temporarily
wget \
    "https://copr.fedorainfracloud.org/coprs/hikariknight/looking-glass-kvmfr/repo/fedora-${RELEASE}/hikariknight-looking-glass-kvmfr-fedora-${RELEASE}.repo" \
    -O /etc/yum.repos.d/_copr_hikariknight-looking-glass-kvmfr.repo

# Install the akmod source package
rpm-ostree install akmod-kvmfr

# Build the kmod for the current kernel
akmods --force --kernels "${KERNEL}" --kmod kvmfr

# Verify the module was actually built
modinfo "/usr/lib/modules/${KERNEL}/extra/kvmfr/kvmfr.ko.xz" > /dev/null \
    || (find /var/cache/akmods/kvmfr/ -name \*.log -print -exec cat {} \; && exit 1)

# Remove the temporary COPR repo
rm -f /etc/yum.repos.d/_copr_hikariknight-looking-glass-kvmfr.repo

echo "=== kvmfr built successfully ==="