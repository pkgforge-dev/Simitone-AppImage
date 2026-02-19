#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor     \
    mono         \
    mono-msbuild \
    openal       \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Simitone..."
echo "---------------------------------------------------------------"
REPO="https://github.com/riperiperi/Simitone"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./Simitone
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./Simitone/Client/Simitone
msbuild Simitone.sln /p:Configuration=Release
mv -v bin/Release/Simitone.Windows.exe ../../../AppDir/bin

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
