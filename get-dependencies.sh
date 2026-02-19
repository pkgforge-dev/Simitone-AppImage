#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor    \
    xmlstarlet  \
    mono        \
    openal      \
    sdl2        \
    unzip

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package dotnet-core-bin
make-aur-package mono-msbuild-git

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Simitone..."
echo "---------------------------------------------------------------"
REPO="https://github.com/riperiperi/Simitone"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./Simitone
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./Simitone
find . -name "*.csproj" -exec sed -i 's/Version=v9.0/Version=v4.7.2/g' {} +
find . -name "*.csproj" -exec sed -i 's/<TargetFrameworkVersion>v9.0<\/TargetFrameworkVersion>/<TargetFrameworkVersion>v4.7.2<\/TargetFrameworkVersion>/g' {} +
cd Client/Simitone
msbuild Simitone.sln /p:Configuration=Release
mv -v bin/Release/* ../../../AppDir/bin

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
