#!/usr/bin/env bash
set -euo pipefail

get_json_array PACKAGES 'try .["packages"][]' "${1}"
get_json_array KMODS    'try .["kmods"][]'    "${1}"

echo "=== Verifying base image packages ==="

for pkg in "${PACKAGES[@]}"; do
    rpm -q "$pkg" \
        && echo "✓ $pkg" \
        || { echo "✗ ERROR: $pkg missing from base image"; exit 1; }
done

for kmod in "${KMODS[@]}"; do
    find /usr/lib/modules -name "*${kmod}*" | grep -q . \
        && echo "✓ kmod: $kmod" \
        || { echo "✗ ERROR: kmod $kmod missing from base image"; exit 1; }
done

echo "=== All verified ==="