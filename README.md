# Dev Container Templates

A collection of [Dev Container Templates](https://containers.dev/implementors/templates/) for Azure Functions development. Each template provides a ready-to-use, multi-container environment with language-specific tooling and an [Azurite](https://github.com/Azure/Azurite) storage emulator.

## Available Templates

| Template | Languages / Runtimes | Supported Versions |
| --- | --- | --- |
| [Azure Functions (.NET)](./src/azure-functions-dotnet) | C#, .NET | 8.0 / 9.0 / 10.0 |
| [Azure Functions (Java)](./src/azure-functions-java) | Java | 8 / 11 / 17 / 21 / 25 |
| [Azure Functions (Node.js)](./src/azure-functions-node) | JavaScript, TypeScript | 20 / 22 / 24 |
| [Azure Functions (PowerShell)](./src/azure-functions-powershell) | PowerShell | 7.4 |
| [Azure Functions (Python)](./src/azure-functions-python) | Python | 3.10 / 3.11 / 3.12 / 3.13 / 3.14 |

> All templates include the Azure Functions Core Tools (version selectable, default: `latest`).

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
