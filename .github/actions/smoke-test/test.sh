#!/bin/bash
TEMPLATE_ID="$1"
set -e

SRC_DIR="/tmp/${TEMPLATE_ID}"
echo "Running Smoke Test"

ID_LABEL="test-container=${TEMPLATE_ID}"
cleanup() {
    status=$?
    trap - EXIT
    container=$(docker ps -aq --filter "label=${ID_LABEL}" | head -n1) || true
    if [ -n "${container}" ]; then
        project=$(docker inspect --format '{{ index .Config.Labels "com.docker.compose.project" }}' "${container}") || true
        if [ -n "${project}" ]; then
            docker compose --project-name "${project}" -f "${SRC_DIR}/.devcontainer/docker-compose.yml" down --volumes || true
        fi
    fi
    rm -rf "${SRC_DIR}"
    exit "${status}"
}
trap cleanup EXIT

devcontainer exec --workspace-folder "${SRC_DIR}" --id-label "${ID_LABEL}" \
    --remote-env "EXPECTED_RUNTIME_VERSION=${RUNTIME_VERSION:-}" \
    /bin/bash -c 'set -e; cd test-project; bash test.sh'
