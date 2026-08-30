#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DEPLOY_DOTNET=1
export USE_HOST_DRIVERS_EXPERIMENTAL=1
export DEPLOY_PIPEWIRE=1

# Deploy dependencies
quick-sharun ./AppDir/bin/Simlauncher ./AppDir/bin/lib/Simitone
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# attempts to write to a read only location
ln -s /tmp/simitone_debug.log ./AppDir/bin/lib/simitone_debug.log

# Turn AppDir into AppImage
quick-sharun --make-appimage
