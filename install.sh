#!/usr/bin/env bash
set -euo pipefail

REPO="SwissCore92/telegram-bot-api-binaries"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="telegram-bot-api"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --install-dir)
            if [[ $# -lt 2 ]]; then
                echo "Error: --install-dir requires a path." >&2
                exit 1
            fi
            INSTALL_DIR="$2"
            shift 2
            ;;
        --help|-h)
            cat <<EOF
Usage: $0 [--install-dir PATH]

Options:
  --install-dir PATH   Install the binary into PATH.
                       Default: /usr/local/bin
  --help, -h           Show this help message.
EOF
            exit 0
            ;;
        *)
            echo "Error: Unknown option: $1" >&2
            echo "Use --help for usage information." >&2
            exit 1
            ;;
    esac
done

die() {
    echo "Error: $*" >&2
    exit 1
}

info() {
    echo "==> $*"
}

command -v curl >/dev/null 2>&1 || die "curl is required."
command -v tar >/dev/null 2>&1 || die "tar is required."
command -v python3 >/dev/null 2>&1 || die "python3 is required."

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
    Linux)
        case "$ARCH" in
            x86_64|amd64)
                PLATFORM="linux-amd64"
                ;;
            aarch64|arm64)
                PLATFORM="linux-arm64"
                ;;
            *)
                die "Unsupported Linux architecture: $ARCH"
                ;;
        esac
        ;;
    Darwin)
        case "$ARCH" in
            x86_64|amd64)
                PLATFORM="macos-amd64"
                ;;
            arm64|aarch64)
                PLATFORM="macos-arm64"
                ;;
            *)
                die "Unsupported macOS architecture: $ARCH"
                ;;
        esac
        ;;
    *)
        die "Unsupported operating system: $OS"
        ;;
esac

API_URL="https://api.github.com/repos/${REPO}/releases/latest"

info "Detected platform: $PLATFORM"
info "Fetching latest release..."

TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

RELEASE_JSON="$TMP_DIR/release.json"

curl -fsSL \
    -H "Accept: application/vnd.github+json" \
    "$API_URL" \
    -o "$RELEASE_JSON" ||
    die "Unable to fetch the latest release."

TAG="$(python3 - "$RELEASE_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], "r", encoding="utf-8") as f:
    data = json.load(f)

tag = data.get("tag_name")

if not tag:
    raise SystemExit("No release tag found.")

print(tag)
PY
)"

ARCHIVE="telegram-bot-api-${TAG}-${PLATFORM}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${TAG}/${ARCHIVE}"
CHECKSUM_URL="https://github.com/${REPO}/releases/download/${TAG}/SHA256SUMS.txt"

info "Latest release: $TAG"
info "Downloading $ARCHIVE..."

curl -fL \
    "$DOWNLOAD_URL" \
    -o "$TMP_DIR/$ARCHIVE" ||
    die "Unable to download $ARCHIVE."

info "Downloading checksums..."

curl -fL \
    "$CHECKSUM_URL" \
    -o "$TMP_DIR/SHA256SUMS.txt" ||
    die "Unable to download SHA256SUMS.txt."

info "Verifying SHA-256 checksum..."

EXPECTED_HASH="$(
    awk -v file="$ARCHIVE" '
        $NF == file {
            print $1
            exit
        }
    ' "$TMP_DIR/SHA256SUMS.txt"
)"

[ -n "$EXPECTED_HASH" ] ||
    die "No checksum found for $ARCHIVE."

if command -v sha256sum >/dev/null 2>&1; then
    ACTUAL_HASH="$(
        sha256sum "$TMP_DIR/$ARCHIVE" |
        awk '{print $1}'
    )"
elif command -v shasum >/dev/null 2>&1; then
    ACTUAL_HASH="$(
        shasum -a 256 "$TMP_DIR/$ARCHIVE" |
        awk '{print $1}'
    )"
else
    die "Neither sha256sum nor shasum is available."
fi

if [ "${EXPECTED_HASH,,}" != "${ACTUAL_HASH,,}" ]; then
    die "SHA-256 checksum verification failed.
Expected:
$EXPECTED_HASH
Actual:
$ACTUAL_HASH"
fi

info "Checksum verified."
info "Extracting..."

mkdir -p "$TMP_DIR/extracted"

tar \
    -xzf "$TMP_DIR/$ARCHIVE" \
    -C "$TMP_DIR/extracted"

SOURCE_DIR="$TMP_DIR/extracted/telegram-bot-api-${TAG}-${PLATFORM}"

[ -f "$SOURCE_DIR/$BINARY_NAME" ] ||
    die "Binary was not found in the downloaded archive."

info "Installing to $INSTALL_DIR..."

if [ -w "$(dirname "$INSTALL_DIR")" ] ||
   { [ -d "$INSTALL_DIR" ] && [ -w "$INSTALL_DIR" ]; }; then
    mkdir -p "$INSTALL_DIR"
    install -m 755 \
        "$SOURCE_DIR/$BINARY_NAME" \
        "$INSTALL_DIR/$BINARY_NAME"
else
    sudo mkdir -p "$INSTALL_DIR"
    sudo install -m 755 \
        "$SOURCE_DIR/$BINARY_NAME" \
        "$INSTALL_DIR/$BINARY_NAME"
fi

echo
info "Installation complete."
echo
echo "  Version:  $TAG"
echo "  Platform: $PLATFORM"
echo "  Binary:   $INSTALL_DIR/$BINARY_NAME"
echo
echo "Run:"
echo
echo "  $BINARY_NAME --help"
