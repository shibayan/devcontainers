#!/bin/bash
set -e

cd "$(dirname "$0")"
source test-utils.sh

LABEL="$1"
shift

check "$LABEL" "$@"
check "func" func --version

reportResults
