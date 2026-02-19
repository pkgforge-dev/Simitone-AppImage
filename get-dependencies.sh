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
#make-aur-package dotnet-core-bin
#make-aur-package dotnet-core-9.0-bin
#make-aur-package mono-msbuild-git

# If the application needs to be manually built that has to be done down here
if [ "$ARCH" = "x86_64" ]; then
    VERSION=0.8.20-forked
    echo "$VERSION" > ~/version
    wget https://github.com/alexjyong/Simitone/releases/download/v$VERSION/Simitone-Linux-x64-Release.zip

    mkdir -p ./AppDir/bin
    bsdtar -xvf Simitone-Linux-x64-Release.zip -C ./AppDir/bin
    rm -rf ./AppDir/bin/simitone.desktop
else
    echo "Making nightly build of Simitone..."
    echo "---------------------------------------------------------------"
    #REPO="https://github.com/riperiperi/Simitone"
    REPO="https://github.com/alexjyong/Simitone"
    VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone --recursive --depth 1 "$REPO" ./Simitone
    echo "$VERSION" > ~/version

    mkdir -p ./AppDir/bin
    cd ./Simitone
    find . -name "*.csproj" -exec sed -i '/<\/PropertyGroup>/i \    <PackageReference Include="System.Drawing.Common" Version="9.0.0" />' {} +
    find . -name "*.csproj" -exec sed -i '/<\/PropertyGroup>/i \    <GenerateRuntimeConfigurationFiles>true</GenerateRuntimeConfigurationFiles>\n    <RuntimeHostConfigurationOption Include="System.Drawing.EnableUnixSupport" Value="true" />' {} +
    find . -name "*.csproj" -exec sed -i '/<\/PropertyGroup>/i \    <EnableWindowsTargeting>true</EnableWindowsTargeting>' {} +
    find . -name "*.csproj" -exec sed -i 's/net[0-9].0-windows/net10.0/g' {} +
    find . -name "*.csproj" -exec sed -i 's/Microsoft.NET.Sdk.WindowsDesktop/Microsoft.NET.Sdk/g' {} +
    find . -name "*.csproj" -exec sed -i 's/<UseWindowsForms>true<\/UseWindowsForms>/<UseWindowsForms>false<\/UseWindowsForms>/g' {} +
    find . -name "*.csproj" -exec sed -i 's/<UseWPF>true<\/UseWPF>/<UseWPF>false<\/UseWPF>/g' {} +
    find . -name "*.csproj" -exec sed -i 's/<OutputType>WinExe<\/OutputType>/<OutputType>Library<\/OutputType>/g' {} +
    cd Client/Simitone
    sed -i '/FSO.IDE/d' Simitone.sln
    sed -i '/FSO.Windows/d' Simitone.sln
    sed -i '/Simitone.Windows/d' Simitone.sln

    dotnet restore Simitone.sln
    dotnet build Simitone.sln -c Release --no-restore
    mv -v bin/Release/* ../../../AppDir/bin
fi
