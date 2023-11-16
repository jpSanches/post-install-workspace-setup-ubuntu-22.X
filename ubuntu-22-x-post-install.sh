#!/usr/bin/env bash
# ----------------------------- VARIABLES ----------------------------- #
PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DOWNLOADS_DIRECTORY="$HOME/Downloads/programs"

PROGRAMS_TO_INSTALL=(
  snapd
  virtualbox
  libvulkan1
  libvulkan1:i386
  libgnutls30:i386
  libldap-2.4-2:i386
  libgpg-error0:i386
  libxml2:i386
  libasound2-plugins:i386
  libsdl2-2.0-0:i386
  libfreetype6:i386
  libdbus-1-3:i386
  libsqlite3-0:i386
)
# ---------------------------------------------------------------------- #

# ----------------------------- REQUIREMENTS ----------------------------- #
## Removing any potential apt locks ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adding/confirming 32-bit architecture ##
sudo dpkg --add-architecture i386

## Updating the repository ##
sudo apt update -y

## Adding third-party repositories and Snap support (Logitech Driver, Lutris, Nvidia Drivers)##
sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
# ---------------------------------------------------------------------- #

# ----------------------------- EXECUTION ----------------------------- #
## Updating the repository after adding new repositories ##
sudo apt update -y

## Downloading and installing external programs ##
mkdir "$DOWNLOADS_DIRECTORY"
wget -c "$URL_GOOGLE_CHROME"       -P "$DOWNLOADS_DIRECTORY"

## Installing downloaded .deb packages from the previous session ##
sudo dpkg -i $DOWNLOADS_DIRECTORY/*.deb

# Installing programs from apt
for program_name in ${PROGRAMS_TO_INSTALL[@]}; do
  if ! dpkg -l | grep -q $program_name; then # Install only if not already installed
    apt install "$program_name" -y
  else
    echo "[INSTALLED] - $program_name"
  fi
done

## Installing Snap packages ##
sudo snap install spotify
sudo snap install slack --classic
# ---------------------------------------------------------------------- #

# ----------------------------- POST-INSTALLATION ----------------------------- #
## Finalization, update, and cleanup ##
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #

