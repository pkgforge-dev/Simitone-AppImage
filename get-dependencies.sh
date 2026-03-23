#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    dotnet-runtime-9.0  \
    libgdiplus          \
    xmlstarlet          \
    openal              \
    pipewire-audio      \
    pipewire-jack       \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Getting app..."
echo "---------------------------------------------------------------"
ZIP_LINK=$(wget https://api.github.com/repos/alexjyong/Simitone/releases -O - \
      | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*Linux-x64-Release.zip")
echo "$ZIP_LINK" | awk -F'/' '{tag=$(NF-1); gsub(/^v/, "", tag); print tag; exit}' > ~/version
if ! wget --retry-connrefused --tries=30 "$ZIP_LINK" -O /tmp/app.zip 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

mkdir -p ./AppDir/bin/lib/Content/MeshReplace
bsdtar -xvf /tmp/app.zip -C ./AppDir/bin
mv -v ./AppDir/bin/Simitone ./AppDir/bin/Simlauncher
rm -f ./AppDir/bin/simitone.desktop
rm -f ./AppDir/bin/lib/*.pdb
