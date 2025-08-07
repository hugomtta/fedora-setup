#!/bin/bash

set -eo pipefail

# Load OS release information
source /etc/os-release

# Check OS compatibility
MINIMUM_VERSION='41'

if [[ "${ID}" != 'fedora' || "${VARIANT_ID}" != 'workstation' || "${VERSION_ID}" -lt "${MINIMUM_VERSION}" ]]; then
  echo "This script is intended for Fedora Workstation ${MINIMUM_VERSION} or later."
  exit 1
fi

# Disable sudo timeout
echo 'Defaults timestamp_timeout = -1' | sudo tee /etc/sudoers.d/timeout >/dev/null
