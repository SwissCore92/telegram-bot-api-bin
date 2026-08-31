$ErrorActionPreference = "Stop"

$Repo = "SwissCore92/telegram-bot-api-binaries"
$BinaryName = "telegram-bot-api.exe"
$InstallDir = Join-Path $env:LOCALAPPDATA "Telegram Bot API"

function Info($Message) {
    Write-Host "==> $Message"
}

function Fail($Message) {
    Write-Error $Message
    exit 1
}

function Show-Help {
    Write-Host @"
Usage: install.ps1 [--install-dir PATH]

Options:
  --install-dir PATH   Install the binary into PATH.
                       Default: $InstallDir
  --help, -h           Show this help message.
"@
}

# ------------------------------------------------------------
# Parse arguments
# ------------------------------------------------------------

for ($i = 0; $i -lt $args.Count; $i++) {
    switch ($args[$i]) {
        "--install-dir" {
            if ($i + 1 -ge $args.Count) {
                Fail "--install-dir requires a path."
            }

            $i++
            $InstallDir = $args[$i]

            if ([string]::IsNullOrWhiteSpace($InstallDir)) {
                Fail "--install-dir requires a non-empty path."
            }
        }

        "--help" {
            Show-Help
            exit 0
        }

        "-h" {
            Show-Help
            exit 0
        }

        default {
            Fail "Unknown option: $($args[$i]). Use --help for usage information."
        }
    }
}

# ------------------------------------------------------------
# Detect architecture
# ------------------------------------------------------------

switch ($env:PROCESSOR_ARCHITECTURE) {
    "AMD64" {
        $Platform = "windows-amd64"
    }

    default {
        Fail "Unsupported Windows architecture: $env:PROCESSOR_ARCHITECTURE"
    }
}

Info "Detected platform: $Platform"

$TempDir = Join-Path $env:TEMP ("telegram-bot-api-" + [guid]::NewGuid())

New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

try {

    # --------------------------------------------------------
    # Get latest release
    # --------------------------------------------------------

    $ApiUrl = "https://api.github.com/repos/$Repo/releases/latest"

    $Headers = @{
        "Accept" = "application/vnd.github+json"
    }

    Info "Fetching latest release..."

    $Release = Invoke-RestMethod `
        -Uri $ApiUrl `
        -Headers $Headers

    $Tag = $Release.tag_name

    if ([string]::IsNullOrWhiteSpace($Tag)) {
        Fail "No release tag was returned by GitHub."
    }

    $Archive = "telegram-bot-api-$Tag-$Platform.zip"

    Info "Latest release: $Tag"
    Info "Downloading $Archive..."

    # --------------------------------------------------------
    # Download binary
    # --------------------------------------------------------

    $DownloadUrl = "https://github.com/$Repo/releases/download/$Tag/$Archive"
    $ArchivePath = Join-Path $TempDir $Archive

    Invoke-WebRequest `
        -Uri $DownloadUrl `
        -OutFile $ArchivePath

    # --------------------------------------------------------
    # Download checksums
    # --------------------------------------------------------

    $ChecksumUrl = "https://github.com/$Repo/releases/download/$Tag/SHA256SUMS.txt"
    $ChecksumPath = Join-Path $TempDir "SHA256SUMS.txt"

    Info "Downloading checksums..."

    Invoke-WebRequest `
        -Uri $ChecksumUrl `
        -OutFile $ChecksumPath

    # --------------------------------------------------------
    # Verify SHA-256
    # --------------------------------------------------------

    Info "Verifying SHA-256 checksum..."

    $ExpectedHash = $null

    foreach ($Line in Get-Content $ChecksumPath) {
        if ($Line -match "^\s*([a-fA-F0-9]{64})\s+(.+)$") {
            $ChecksumFile = $Matches[2].Trim()

            if (
                $ChecksumFile -eq $Archive -or
                $ChecksumFile -eq "dist/$Archive" -or
                $ChecksumFile -eq "*$Archive"
            ) {
                $ExpectedHash = $Matches[1]
                break
            }
        }
    }

    if ([string]::IsNullOrWhiteSpace($ExpectedHash)) {
        Fail "No checksum found for $Archive."
    }

    $ActualHash = (
        Get-FileHash `
            -Path $ArchivePath `
            -Algorithm SHA256
    ).Hash

    if ($ExpectedHash.ToLower() -ne $ActualHash.ToLower()) {
        Fail @"
SHA-256 checksum verification failed.

Expected:
$ExpectedHash

Actual:
$ActualHash
"@
    }

    Info "Checksum verified."

    # --------------------------------------------------------
    # Extract
    # --------------------------------------------------------

    $ExtractDir = Join-Path $TempDir "extracted"

    Info "Extracting..."

    New-Item `
        -ItemType Directory `
        -Path $ExtractDir `
        -Force | Out-Null

    Expand-Archive `
        -Path $ArchivePath `
        -DestinationPath $ExtractDir `
        -Force
    
    Get-ChildItem -Path $ExtractDir -Recurse | ForEach-Object {
        Write-Host $_.FullName
    }

    $SourceDir = Get-ChildItem `
        -Path $ExtractDir `
        -Directory `
        -Filter "telegram-bot-api-$Tag-$Platform" |
        Select-Object -First 1

    if ($null -eq $SourceDir) {
        Fail "Extracted Telegram Bot API directory was not found."
    }

    $BinaryPath = Join-Path $SourceDir.FullName $BinaryName

    if (-not (Test-Path $BinaryPath)) {
        Fail "Binary was not found in the downloaded archive."
    }

    $DllFiles = Get-ChildItem `
        -Path $SourceDir.FullName `
        -Filter "*.dll" `
        -File

    if ($DllFiles.Count -eq 0) {
        Fail "No DLL files were found in the downloaded archive."
    }

    # --------------------------------------------------------
    # Install
    # --------------------------------------------------------

    Info "Installing to $InstallDir..."

    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null

    Copy-Item `
        -Path $BinaryPath `
        -Destination (Join-Path $InstallDir $BinaryName) `
        -Force

    foreach ($Dll in $DllFiles) {
        Copy-Item `
            -Path $Dll.FullName `
            -Destination $InstallDir `
            -Force
    }

    # --------------------------------------------------------
    # Add installation directory to user PATH
    # --------------------------------------------------------

    $UserPath = [Environment]::GetEnvironmentVariable(
        "Path",
        "User"
    )

    $PathEntries = @()

    if (-not [string]::IsNullOrWhiteSpace($UserPath)) {
        $PathEntries = $UserPath -split ";"
    }

    if ($PathEntries -notcontains $InstallDir) {
        $NewPath = if (
            [string]::IsNullOrWhiteSpace($UserPath)
        ) {
            $InstallDir
        }
        else {
            "$UserPath;$InstallDir"
        }

        [Environment]::SetEnvironmentVariable(
            "Path",
            $NewPath,
            "User"
        )

        Info "Added installation directory to user PATH."
    }

    # --------------------------------------------------------
    # Done
    # --------------------------------------------------------

    Write-Host ""
    Info "Installation complete."
    Write-Host ""
    Write-Host "  Version:  $Tag"
    Write-Host "  Platform: $Platform"
    Write-Host "  Binary:   $Destination"
    Write-Host ""
    Write-Host "Open a new PowerShell window, then run:"
    Write-Host ""
    Write-Host "  telegram-bot-api.exe --help"
    Write-Host ""

}
finally {
    if (Test-Path $TempDir) {
        Remove-Item `
            -Path $TempDir `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue
    }
}
