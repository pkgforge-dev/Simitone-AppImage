#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor    \
    libgdiplus  \
    xmlstarlet  \
    openal      \
    sdl2        \
    unzip
    #mono        \

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package dotnet-core-bin
#make-aur-package mono-msbuild-git

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Simitone..."
echo "---------------------------------------------------------------"
#REPO="https://github.com/riperiperi/Simitone"
REPO="https://github.com/alexjyong/Simitone"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./Simitone
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./Simitone
#find . -name "*.csproj" -exec sed -i '/<\/PropertyGroup>/i \    <PackageReference Include="System.Drawing.Common" Version="9.0.0" />\n    <GenerateRuntimeConfigurationFiles>true</GenerateRuntimeConfigurationFiles>' {} +
#find . -name "*.csproj" -exec sed -i '/<\/PropertyGroup>/i \    <RuntimeHostConfigurationOption Include="System.Drawing.EnableUnixSupport" Value="true" />' {} +
#find . -name "*.csproj" -exec sed -i 's/Microsoft.NET.Sdk.WindowsDesktop/Microsoft.NET.Sdk/g' {} +
#find . -name "*.csproj" -exec sed -i 's/<OutputType>WinExe<\/OutputType>/<OutputType>Library<\/OutputType>/g' {} +
cd Client/Simitone
#sed -i '/FSO.IDE/d' Simitone.sln
#sed -i '/Simitone.Windows/d' Simitone.sln
#sed -i '/FSO.Windows/d' Simitone.sln
#dotnet restore Simitone.sln
#dotnet build Simitone.sln -c Release --no-restore
dotnet build Simitone.sln -c Release
mv -v bin/Release/* ../../../AppDir/bin

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
