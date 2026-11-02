ARG RUNTIME_VERSION

FROM mcr.microsoft.com/devcontainers/dotnet:8.0-noble AS powershell-7.4
FROM mcr.microsoft.com/devcontainers/dotnet:10.0-noble AS powershell-7.6

FROM powershell-${RUNTIME_VERSION}
