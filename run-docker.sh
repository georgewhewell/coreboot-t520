#/usr/bin/env bash

set -e

docker run --rm -it -v $(pwd):/mnt t520-build /mnt/build-flash.sh
