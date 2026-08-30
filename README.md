# Telegram Bot API — Prebuilt Binaries

[![Telegram Bot API](https://img.shields.io/badge/Telegram%20Bot%20API-10.3-26A5E4?style=for-the-badge&logo=telegram&logoColor=white)](https://core.telegram.org/bots/api)

Unofficial prebuilt binaries of the **Telegram Bot API server**, compiled from the official upstream source code.

This repository exists to make it easier to run the Telegram Bot API server without having to compile it yourself.

## Disclaimer

**This project is not affiliated with, endorsed by, sponsored by, or otherwise associated with Telegram or Telegram Messenger LLP.**

The binaries distributed here are compiled from the upstream Telegram Bot API source code using GitHub Actions.

The official Telegram Bot API server source code is maintained by Telegram and is available at:

https://github.com/tdlib/telegram-bot-api

Please refer to the upstream repository for the source code, official documentation, licensing information, and build instructions.

## Supported Platforms

Each release provides prebuilt binaries for:

| Platform | Architecture            |
| -------- | ----------------------- |
| Linux    | AMD64 (`x86_64`)        |
| Linux    | ARM64 (`aarch64`)       |
| Windows  | AMD64 (`x86_64`)        |
| macOS    | Intel (`x86_64`)        |
| macOS    | Apple Silicon (`arm64`) |

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

For example, on Linux:

```bash
sha256sum telegram-bot-api-v10.3-linux-amd64.tar.gz
```

On macOS:

```bash
shasum -a 256 telegram-bot-api-v10.3-macos-arm64.tar.gz
```

Compare the result with `SHA256SUMS.txt` included in the release.

## Source Provenance

Each binary package contains a `source-commit.txt` file identifying the exact upstream Telegram Bot API source commit used to build the binary.

This allows every binary to be traced back to the source revision from which it was built.

## Building From Source

If you prefer to build the server yourself, use the official Telegram Bot API source repository:

https://github.com/tdlib/telegram-bot-api

This repository does not modify the Telegram Bot API source code.

## Automated Builds

The binaries are built automatically using GitHub Actions.

The build process:

1. Obtains the upstream Telegram Bot API source code.
2. Builds the server for each supported platform.
3. Packages the resulting executable.
4. Records the upstream source commit.
5. Generates SHA-256 checksums.
6. Publishes the binaries as GitHub Release assets.

## Licensing

The Telegram Bot API source code and associated components are subject to the licenses specified by their respective upstream projects.

See the upstream repository for authoritative licensing information:

https://github.com/tdlib/telegram-bot-api

License and copyright notices included with the upstream project are retained in the distributed packages where applicable.

## Contributing

Issues and pull requests related to the build system, packaging, and release automation are welcome.

For bugs or feature requests concerning the Telegram Bot API itself, please refer to the official upstream project.

---

**Unofficial project. Not affiliated with or endorsed by Telegram.**
