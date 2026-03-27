#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    dotnet-runtime-9.0  \
    libdecor            \
    libgdiplus          \
    xmlstarlet          \
    openal              \
    sdl2                \
    unzip

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package dotnet-core-9.0-bin

# If the application needs to be manually built that has to be done down here
wget https://github.com/Link4Electronics/Simitone/releases/download/v0.8.21-forked/Simitone-Linux-x64-Release.zip
VERSION=0.8.21-forked
echo "$VERSION" > ~/version
#ZIP_LINK=$(wget https://api.github.com/repos/alexjyong/Simitone/releases -O - \
#      | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*Linux-x64-Release.zip")
#echo "$ZIP_LINK" | awk -F'/' '{tag=$(NF-1); gsub(/^v/, "", tag); print tag; exit}' > ~/version
#if ! wget --retry-connrefused --tries=30 "$ZIP_LINK" -O /tmp/app.zip 2>/tmp/download.log; then
#	cat /tmp/download.log
#	exit 1
#fi

mkdir -p ./AppDir/bin
bsdtar -xvf /tmp/app.zip -C ./AppDir/bin
mv -v ./AppDir/bin/Simitone ./AppDir/bin/Simlauncher
rm -rf ./AppDir/bin/simitone.desktop
