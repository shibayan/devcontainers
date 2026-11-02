## Core Tools on Linux ARM64

This template defaults to Azure Functions Core Tools **4.13.0** on both architectures. Core Tools 4.14.0 through 4.16.0 ship incomplete Python workers on Linux ARM64, causing `func start` to fail with `ImportError` before functions can be indexed. Version 4.13.0 is the last known working release in that range.

Keep the default pinned until [Azure/azure-functions-core-tools#5772](https://github.com/Azure/azure-functions-core-tools/issues/5772) is resolved and the fixed release passes the Python HTTP smoke tests on both AMD64 and ARM64. Selecting `latest` or `4.16.0` currently exposes ARM64 users to this upstream defect.
