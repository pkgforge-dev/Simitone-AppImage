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
VERSION=0.8.20-forked
echo "$VERSION" > ~/version
wget https://github.com/alexjyong/Simitone/releases/download/v$VERSION/Simitone-Linux-x64-Release.zip

mkdir -p ./AppDir/bin
bsdtar -xvf Simitone-Linux-x64-Release.zip -C ./AppDir/bin
mv -v ./AppDir/bin/Simitone ./AppDir/bin/Simlauncher
rm -rf ./AppDir/bin/simitone.desktop
