#!/bin/bash -e

function build {
  TARGET=$1
  PARAM=$2

  pushd $TARGET > /dev/null
  ./build.sh $PARAM
  popd > /dev/null
}

if [[ "$1" == "--rebuild-image" ]]; then
  IMAGE_PATH=$(build image)
else
  IMAGE_PATH=$(realpath $(ls -1t image/images/*.iso | head -1))
fi

build infrastructure $IMAGE_PATH
