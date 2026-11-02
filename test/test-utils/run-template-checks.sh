#!/bin/bash
set -e

cd "$(dirname "$0")"
source test-utils.sh

LABEL="$1"
shift

check "$LABEL" "$@"
if [ -n "${EXPECTED_RUNTIME_VERSION:-}" ]; then
    actual_version=$("$@" 2>&1)
    expected_version="${EXPECTED_RUNTIME_VERSION}"
    if [ "${LABEL}" = "java" ] && [ "${expected_version}" = "8" ]; then
        expected_version=1.8
    fi
    case "${LABEL}" in
        dotnet) prefix='^' ;;
        go) prefix='go' ;;
        java) prefix='version "' ;;
        node) prefix='^v' ;;
        powershell) prefix='PowerShell ' ;;
        python) prefix='Python ' ;;
    esac
    check "selected runtime ${EXPECTED_RUNTIME_VERSION}" \
        grep -E "${prefix}${expected_version//./\\.}([.\"[:space:]]|$)" <<< "${actual_version}"
fi
check "func" func --version
check "Functions HTTP trigger" bash functions-http-test.sh "$LABEL"

reportResults
