# Dev Container Templates

A collection of [Dev Container Templates](https://containers.dev/implementors/templates/) for Azure Functions development. Each template provides a ready-to-use, multi-container environment with language-specific tooling and an [Azurite](https://github.com/Azure/Azurite) storage emulator.

## Available Templates

| Template | Languages / Runtimes | Supported Versions |
| --- | --- | --- |
| [Azure Functions (.NET)](./src/azure-functions-dotnet) | C#, .NET | 8.0 / 9.0 / 10.0 |
| [Azure Functions (Go)](./src/azure-functions-go) | Go | 1.26 / 1.27 |
| [Azure Functions (Java)](./src/azure-functions-java) | Java | 8 / 11 / 17 / 21 / 25 |
| [Azure Functions (Node.js)](./src/azure-functions-node) | JavaScript, TypeScript | 22 / 24 |
| [Azure Functions (PowerShell)](./src/azure-functions-powershell) | PowerShell | 7.4 / 7.6 |
| [Azure Functions (Python)](./src/azure-functions-python) | Python | 3.11 / 3.12 / 3.13 / 3.14 |

> All templates include the Azure Functions Core Tools (version selectable, default: `latest`, except Python which defaults to `4.13.0`).

All language runtimes are provided through separate `*-base` prebuilt Ubuntu 24.04 images for both AMD64 and ARM64. The templates add the selected Azure Functions Core Tools version when the development container is created.

## Runtime support and hosting plans

The default runtimes are .NET 10, Go 1.27, Java 21, Node.js 24, PowerShell 7.6, and Python 3.13. Core Tools 4.16.0 is also available as an explicit version option.

The Python template temporarily pins Core Tools to **4.13.0** on both architectures. Core Tools 4.14.0 through 4.16.0 ship incomplete Python workers on Linux ARM64 and fail during startup. See [upstream issue #5772](https://github.com/Azure/azure-functions-core-tools/issues/5772). Restore `latest` only after a fixed release passes the Python HTTP smoke tests on both architectures.

As of November 3, 2026, .NET 8, .NET 9, and PowerShell 7.4 remain available for existing projects, but their support ends on **November 10, 2026**. Plan to move to .NET 10 (isolated worker) or PowerShell 7.6 before that date. Azure Functions in-process model support also ends on November 10, 2026. Node.js 20, Python 3.10, and Go 1.24/1.25 are no longer offered for new containers because upstream support has ended. Previously published image tags remain available for existing users.

Local runtime availability does not imply support on every Azure hosting plan:

| Runtime | Azure hosting restriction |
| --- | --- |
| .NET 10 | Not supported on Linux Consumption; .NET 9 is the last supported version on that plan. |
| Java 25 | Not supported on Linux Consumption; Java 21 is the last supported version on that plan. |
| Node.js 24 | Not supported on Linux Consumption; Node.js 22 is the last supported version on that plan. |
| PowerShell 7.6 | Not supported on Linux Consumption; migrate to Flex Consumption before upgrading from 7.4. |
| Python 3.13 / 3.14 | Not supported on Linux Consumption; Python 3.12 is the last supported version on that plan. |
| Go | Generally available on Flex Consumption. |

Check the [Azure Functions language support table](https://learn.microsoft.com/azure/azure-functions/functions-versions#languages), [.NET support policy](https://dotnet.microsoft.com/platform/support/policy/dotnet-core), and [Go release policy](https://go.dev/doc/devel/release#policy) before choosing a deployment target. Core Tools 5 remains a preview and is not an explicit template option.

## Validation

Pull request CI builds each proposed runtime version for changed templates on both AMD64 and ARM64. It checks the installed tools, generates a language-specific HTTP function, starts the Functions host against the Azurite sidecar, and verifies the HTTP response. The tests use local emulated storage and do not deploy Azure resources.

## Usage

1. Open the Command Palette in VS Code and select **Dev Containers: Add Dev Container Configuration Files...**
2. Choose **Show All Definitions...**, then search for `Azure Functions`
3. Select the template that matches your language and configure the version options

Alternatively, you can use the [Dev Container CLI](https://github.com/devcontainers/cli):

```sh
devcontainer templates apply -t ghcr.io/shibayan/devcontainers/azure-functions-node
```

## License

This project is licensed under the [MIT License](https://github.com/shibayan/devcontainers/blob/master/LICENSE)
