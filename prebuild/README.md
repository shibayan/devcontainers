# Prebuilt Runtime Images

This directory contains the Dev Container definitions used to build the Ubuntu 24.04 runtime images referenced by the templates in `src`.

Each language is published to a separate GHCR package whose name ends in `-base`. Images are published for AMD64 and ARM64 with rolling, dated, and revision tags.

GitHub Container Registry creates new packages as private. After the first successful image push for a language, change the corresponding `*-base` package visibility to public and rerun the workflow. The final workflow job verifies that every image can be pulled anonymously.

Previously published runtime tags without the `-base` package suffix must remain available because template versions published before this separation reference those tags.
