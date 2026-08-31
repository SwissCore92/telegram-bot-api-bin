# Telegram Bot API - Prebuilt Binaries

[![Telegram Bot API](https://img.shields.io/github/v/release/SwissCore92/telegram-bot-api-bin?label=Telegram%20Bot%20API&logo=telegram&logoColor=white&style=for-the-badge)](https://github.com/SwissCore92/telegram-bot-api-bin/releases/latest)
[![Installer Tests](https://img.shields.io/github/actions/workflow/status/SwissCore92/telegram-bot-api-bin/test-installer.yml?style=for-the-badge&label=Installer%20Tests&logo=githubactions&logoColor=white)](https://github.com/SwissCore92/telegram-bot-api-bin/actions/workflows/test-installer.yml)

Unofficial prebuilt binaries of the **Telegram Bot API server**, compiled from the [official upstream](https://github.com/tdlib/telegram-bot-api) source code.

This repository exists to make it easier to run the Telegram Bot API server locally without having to compile it yourself. You can simply install/update your local `telegram-bot-api` with [one command](#quick-install).

## Important

> **This project is not affiliated with, endorsed by, sponsored by, or otherwise associated with Telegram or Telegram Messenger LLP.**

The binaries distributed here are compiled from the upstream Telegram Bot API source code using GitHub Actions.

The official Telegram Bot API server source code is maintained by Telegram and is available at:

https://github.com/tdlib/telegram-bot-api

**This repository does not modify the Telegram Bot API source code.**

Please refer to the upstream repository for the source code, official documentation, licensing information, and build instructions.

## Table of Contents

* [Supported Platforms](#supported-platforms)
* [Quick Install](#quick-install)
  * [Linux](#linux)
  * [macOS](#macos)
  * [Windows](#windows)
* [Manual Installation](#manual-installation)
* [Usage](#usage)
* [Releases](#releases)
* [SHA-256 Checksums](#sha-256-checksums)
* [Source Provenance](#source-provenance)
* [Building From Source](#building-from-source)
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

> **Security note:** If you prefer not to pipe a remote script directly into your shell, use [Manual Installation](#manual-installation) instead.

### Linux / macOS

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/SwissCore92/telegram-bot-api-bin/main/install.sh | bash
```

By default, the installer installs the `telegram-bot-api` executable to `/usr/local/bin`.

After installation, verify it with:

```bash
telegram-bot-api --version
```

### Windows

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/SwissCore92/telegram-bot-api-bin/main/install.ps1 | iex
```

By default, the installer installs the `telegram-bot-api.exe` and its required `dll`s to `%LOCALAPPDATA%\Telegram Bot API`.

After installation, open a new PowerShell window and verify it with:

```powershell
telegram-bot-api.exe --version
```

## Manual Installation

Prebuilt binaries can also be downloaded directly from the [Releases](../../releases) page.

Download and extract the archive matching your operating system and architecture.

### Linux / macOS

Recommended installation path is `/usr/local/bin`.

```bash
sudo install -m 755 <path/to/extracted/files/telegram-bot-api> /usr/local/bin
```
If you choose another location, make sure it is in `PATH`.

verify:

```bash
telegram-bot-api --version
```

### Windows

Recommended installation path is `%LOCALAPPDATA%\Telegram Bot API`.

```powershell
New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\Telegram Bot API" -Force

Copy-Item `
    "<path\to\extracted\files>\*" `
    "$env:LOCALAPPDATA\Telegram Bot API" `
    -Recurse `
    -Force
```

The directory should contain `telegram-bot-api.exe` **and its required DLL files**.

If you choose another location, make sure it is in `PATH`.

verify:

```powershell
telegram-bot-api.exe --version
```

## Usage

For details about usage, check the [official documentation](https://github.com/tdlib/telegram-bot-api#usage).

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

## Licensing

The Telegram Bot API source code and associated components are subject to the licenses specified by their respective upstream projects.

See the upstream repository for authoritative licensing information:

https://github.com/tdlib/telegram-bot-api

License and copyright notices included with the upstream project are retained in the distributed packages where applicable.

The distributed packages include the upstream **Boost Software License 1.0** as `LICENSE_1_0.txt`.

This repository does not claim ownership of the Telegram Bot API source code or the upstream components included in the builds.

## Contributing

Issues and pull requests related to the build system, packaging, installation scripts, and release automation are welcome.

For bugs or feature requests concerning the Telegram Bot API itself, please refer to the [official upstream](https://github.com/tdlib/telegram-bot-api) project.

---

**Unofficial project. Not affiliated with or endorsed by Telegram.**
