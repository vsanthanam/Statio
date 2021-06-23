#! /bin/sh
set -euo pipefail
swift build --package-path tools/repo --configuration release
cp tools/repo/.build/release/repo bin/repo/repo
