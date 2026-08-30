# Telegram Bot API - Prebuilt Binaries

Unofficial prebuilt binaries of the **Telegram Bot API server**, compiled from the official upstream source code.

This repository exists to make it easier to run the Telegram Bot API server without having to compile it yourself.

## Important

> **This project is not affiliated with, endorsed by, sponsored by, or otherwise associated with Telegram or Telegram Messenger LLP.**

The binaries distributed here are compiled from the upstream Telegram Bot API source code using GitHub Actions.

The official Telegram Bot API server source code is maintained by Telegram and is available at:

https://github.com/tdlib/telegram-bot-api

Please refer to the upstream repository for the source code, official documentation, licensing information, and build instructions.

## Table of Contents

* [Supported Platforms](#supported-platforms)
* [Quick Install](#quick-install)

  * [Linux](#linux)
  * [macOS](#macos)
  * [Windows](#windows)
* [Manual Installation](#manual-installation)
* [Releases](#releases)
* [SHA-256 Checksums](#sha-256-checksums)
* [Source Provenance](#source-provenance)
* [Building From Source](#building-from-source)
* [Automated Builds](#automated-builds)
* [Licensing](#licensing)
* [Contributing](#contributing)

## Supported Platforms

Each release provides prebuilt binaries for:

| Platform | Architecture            |
| -------- | ----------------------- |
| Linux    | AMD64 (`x86_64`)        |
| Linux    | ARM64 (`aarch64`)       |
| Windows  | AMD64 (`x86_64`)        |
| macOS    | Intel (`x86_64`)        |
| macOS    | Apple Silicon (`arm64`) |

## Quick Install

The easiest way to install the latest release is to use the appropriate installer for your operating system.

The installers automatically determine the latest GitHub Release and download the correct binary for the current platform and architecture.

### Linux

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/SwissCore92/telegram-bot-api-binaries/main/install.sh | bash
```

By default, the installer installs the `telegram-bot-api` executable to a user-local directory.

After installation, verify it with:

```bash
telegram-bot-api --help
```

If the command is not found, make sure the install directory is included in your `PATH`.

### macOS

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/SwissCore92/telegram-bot-api-binaries/main/install.sh | bash
```

The installer automatically detects whether the Mac is Intel or Apple Silicon and downloads the corresponding binary.

After installation, verify it with:

```bash
telegram-bot-api --help
```

### Windows

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/SwissCore92/telegram-bot-api-binaries/main/install.ps1 | iex
```

The installer automatically downloads the Windows AMD64 release.

After installation, open a new PowerShell window and verify it with:

```powershell
telegram-bot-api.exe --help
```

> **Security note:** If you prefer not to pipe a remote script directly into your shell, use [Manual Installation](#manual-installation) instead.

## Manual Installation

Prebuilt binaries can also be downloaded directly from the [Releases](../../releases) page.

Choose the archive matching your operating system and architecture.

### Linux AMD64

Download:

```text
telegram-bot-api-v10.3-linux-amd64.tar.gz
```

Extract it:

```bash
tar -xzf telegram-bot-api-v10.3-linux-amd64.tar.gz
```

The extracted directory contains:

```text
telegram-bot-api
LICENSE_1_0.txt
source-commit.txt
```

### Linux ARM64

Download:

```text
telegram-bot-api-v10.3-linux-arm64.tar.gz
```

Extract it:

```bash
tar -xzf telegram-bot-api-v10.3-linux-arm64.tar.gz
```

### macOS Intel

Download:

```text
telegram-bot-api-v10.3-macos-amd64.tar.gz
```

Extract it:

```bash
tar -xzf telegram-bot-api-v10.3-macos-amd64.tar.gz
```

### macOS Apple Silicon

Download:

```text
telegram-bot-api-v10.3-macos-arm64.tar.gz
```

Extract it:

```bash
tar -xzf telegram-bot-api-v10.3-macos-arm64.tar.gz
```

### Windows AMD64

Download:

```text
telegram-bot-api-v10.3-windows-amd64.zip
```

Extract the ZIP archive using File Explorer or PowerShell.

For example:

```powershell
Expand-Archive telegram-bot-api-v10.3-windows-amd64.zip .
```

The Windows archive contains the executable and any required DLL files.

## Releases

Releases use the **Telegram Bot API version number**.

For example, for Telegram Bot API `10.3`:

```text
v10.3
```

The corresponding release assets are:

```text
telegram-bot-api-v10.3-linux-amd64.tar.gz
telegram-bot-api-v10.3-linux-arm64.tar.gz
telegram-bot-api-v10.3-windows-amd64.zip
telegram-bot-api-v10.3-macos-amd64.tar.gz
telegram-bot-api-v10.3-macos-arm64.tar.gz
```

There is no additional version number specific to this repository.

Prebuilt binaries are available on the [Releases](../../releases) page.

## SHA-256 Checksums

Every release includes SHA-256 checksums.

A combined `SHA256SUMS.txt` file is provided with each release.

For example, on Linux:

```bash
sha256sum telegram-bot-api-v10.3-linux-amd64.tar.gz
```

On macOS:

```bash
shasum -a 256 telegram-bot-api-v10.3-macos-arm64.tar.gz
```

Compare the resulting hash with the corresponding entry in `SHA256SUMS.txt`.

On Windows PowerShell:

```powershell
Get-FileHash telegram-bot-api-v10.3-windows-amd64.zip -Algorithm SHA256
```

The hash should match the corresponding entry in `SHA256SUMS.txt`.

## Source Provenance

Each binary package contains a `source-commit.txt` file identifying the exact upstream Telegram Bot API source commit used to build the binary.

This allows every binary to be traced back to the source revision from which it was built.

The GitHub Release notes also identify the upstream commit used for the release.

The release workflow verifies that the Telegram Bot API version declared by the upstream `CMakeLists.txt` matches the GitHub Release tag.

This prevents accidentally publishing a release under the wrong Telegram Bot API version.

## Building From Source

If you prefer to build the server yourself, use the official Telegram Bot API source repository:

https://github.com/tdlib/telegram-bot-api

This repository does not modify the Telegram Bot API source code.

## Automated Builds

The binaries are built automatically using GitHub Actions.

The build process:

1. Obtains the upstream Telegram Bot API source code.
2. Resolves the exact upstream source commit.
3. Verifies the Telegram Bot API version.
4. Builds the server for each supported platform.
5. Packages the resulting executable.
6. Includes the applicable upstream license.
7. Records the upstream source commit.
8. Generates SHA-256 checksums.
9. Publishes the binaries as GitHub Release assets.

## Licensing

The Telegram Bot API source code and associated components are subject to the licenses specified by their respective upstream projects.

See the upstream repository for authoritative licensing information:

https://github.com/tdlib/telegram-bot-api

License and copyright notices included with the upstream project are retained in the distributed packages where applicable.

The distributed packages include the upstream **Boost Software License 1.0** as `LICENSE_1_0.txt`.

This repository does not claim ownership of the Telegram Bot API source code or the upstream components included in the builds.

## Contributing

Issues and pull requests related to the build system, packaging, installation scripts, and release automation are welcome.

For bugs or feature requests concerning the Telegram Bot API itself, please refer to the official upstream project.

---

**Unofficial project. Not affiliated with or endorsed by Telegram.**
