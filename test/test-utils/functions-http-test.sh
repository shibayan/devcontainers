#!/bin/bash
set -euo pipefail

LANGUAGE="$1"
PROJECT_DIR=$(mktemp -d)
HOST_PID=""

cleanup() {
    status=$?
    trap - EXIT
    if [ -n "${HOST_PID}" ]; then
        kill -- "-${HOST_PID}" 2>/dev/null || true
        wait "${HOST_PID}" 2>/dev/null || true
    fi
    if [ "${status}" -ne 0 ] && [ -f "${PROJECT_DIR}/host.log" ]; then
        cat "${PROJECT_DIR}/host.log"
    fi
    rm -rf "${PROJECT_DIR}"
    exit "${status}"
}
trap cleanup EXIT

cd "${PROJECT_DIR}"
START_COMMAND=(func start --port 7071)
FUNCTION_NAME=HttpExample

case "${LANGUAGE}" in
    dotnet)
        framework="net$(dotnet --version | cut -d. -f1).0"
        func init --worker-runtime dotnet-isolated --target-framework "${framework}"
        ;;
    node)
        func init --worker-runtime node --language javascript
        ;;
    python)
        python -m venv .venv
        source .venv/bin/activate
        func init --worker-runtime python
        ;;
    powershell)
        func init --worker-runtime powershell
        pwsh -NoProfile -Command '
            $settings = Get-Content local.settings.json -Raw | ConvertFrom-Json -AsHashtable
            $settings.Values.FUNCTIONS_WORKER_RUNTIME_VERSION = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
            $settings | ConvertTo-Json -Depth 10 | Set-Content local.settings.json
        '
        ;;
    java)
        java_version=$(java -version 2>&1 | head -n1 | cut -d '"' -f2 | cut -d. -f1)
        if [ "${java_version}" = "1" ]; then java_version=8; fi
        mvn -B archetype:generate \
            -DarchetypeGroupId=com.microsoft.azure \
            -DarchetypeArtifactId=azure-functions-archetype \
            -DgroupId=devcontainers.smoke -DartifactId=smoke \
            -Dversion=1.0-SNAPSHOT -Dpackage=devcontainers.smoke \
            -DappName=devcontainers-smoke -DjavaVersion="${java_version}" \
            -DinteractiveMode=false
        cd smoke
        mvn -B package -DskipTests
        START_COMMAND=(mvn -B azure-functions:run)
        ;;
    go)
        func init --worker-runtime go
        # Go uses code-first registration; func new is not supported.
        cat > main.go <<'GO'
package main

import (
    "fmt"
    "net/http"

    "github.com/azure/azure-functions-golang-worker/sdk"
    "github.com/azure/azure-functions-golang-worker/worker"
)

func main() {
    app := sdk.FunctionApp()
    app.HTTP("HttpExample", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "devcontainers-smoke")
    }, sdk.WithMethods("GET"), sdk.WithAuth("anonymous"))
    worker.Start(app)
}
GO
        go mod tidy
        ;;
    *)
        echo "Unsupported language: ${LANGUAGE}" >&2
        exit 1
        ;;
esac

case "${LANGUAGE}" in
    java|go) ;;
    *) func new --name "${FUNCTION_NAME}" --template "HTTP trigger" --authlevel anonymous ;;
esac

case "${LANGUAGE}" in
    node) npm install ;;
    python) python -m pip install -r requirements.txt ;;
    # Avoid downloading Azure modules for a simple HTTP trigger.
    powershell) printf '@{}\n' > requirements.psd1 ;;
esac

# Use only the Azurite sidecar; no Azure account or cloud credentials are needed.
export AzureWebJobsStorage=UseDevelopmentStorage=true
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

# Bound host startup (including builds), and stop the entire process group on exit.
setsid timeout --kill-after=10s 300s "${START_COMMAND[@]}" > "${PROJECT_DIR}/host.log" 2>&1 &
HOST_PID=$!
for ((attempt=0; attempt<150; attempt++)); do
    if ! kill -0 "${HOST_PID}" 2>/dev/null; then
        echo "Functions host exited before the HTTP trigger became ready." >&2
        exit 1
    fi
    if curl --fail --silent --show-error --max-time 2 \
        "http://localhost:7071/api/${FUNCTION_NAME}?name=devcontainers-smoke" \
        > "${PROJECT_DIR}/response.txt" 2>/dev/null \
        && [ -s "${PROJECT_DIR}/response.txt" ]; then
        echo "Functions host invoked the ${LANGUAGE} HTTP trigger successfully."
        exit 0
    fi
    sleep 2
done

echo "Timed out waiting for the ${LANGUAGE} HTTP trigger." >&2
exit 1
