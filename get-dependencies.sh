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
wget https://productionresultssa17.blob.core.windows.net/actions-results/4e973bba-5d38-4156-a714-a5e3392df647/workflow-job-run-a2834d66-ce54-5951-89e6-ddba6ef2167f/artifacts/e2251bb28ab8f11e16562170ce1d34163c1023fb534bf494195fd57da87e189b.zip?rscd=attachment%3B+filename%3D%22Simitone-Linux-x64-Release.zip%22&rsct=application%2Fzip&se=2026-03-27T00%3A39%3A35Z&sig=oBGmdTjsL%2BJ6Ycn3efKbqRxaGYx6OTe3%2FOPt1Kolijs%3D&ske=2026-03-27T03%3A23%3A32Z&skoid=ca7593d4-ee42-46cd-af88-8b886a2f84eb&sks=b&skt=2026-03-26T23%3A23%3A32Z&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skv=2025-11-05&sp=r&spr=https&sr=b&st=2026-03-27T00%3A29%3A30Z&sv=2025-11-05
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
