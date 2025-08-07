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

# Remove unwanted packages
UNWANTED_PACKAGES=(
  baobab
  firefox*
  gnome-abrt
  gnome-boxes
  gnome-calendar
  gnome-characters
  gnome-clocks
  gnome-color-manager
  gnome-connections
  gnome-contacts
  gnome-disk-utility
  gnome-font-viewer
  gnome-logs
  gnome-maps
  gnome-system-monitor
  gnome-tour
  gnome-weather
  ibus-anthy
  ibus-hangul
  ibus-libpinyin
  ibus-m17n
  ibus-typing-booster
  libreoffice*
  mediawriter
  rhythmbox
  simple-scan
  snapshot
  yelp
)

sudo dnf remove -y "${UNWANTED_PACKAGES[@]}"

# Install RPM Fusion repositories
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"${VERSION_ID}".noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"${VERSION_ID}".noarch.rpm

# Install Flathub repository
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Update the system
sudo dnf update -y --refresh
