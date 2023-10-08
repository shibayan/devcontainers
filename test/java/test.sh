#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "java" java -version
check "func" func --version

# Report result
reportResults
