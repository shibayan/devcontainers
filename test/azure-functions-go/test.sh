#!/bin/bash
set -e

cd "$(dirname "$0")"
bash run-template-checks.sh "go" go version
