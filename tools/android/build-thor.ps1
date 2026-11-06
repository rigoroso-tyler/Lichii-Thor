# SPDX-License-Identifier: GPL-3.0-or-later

[CmdletBinding()]
param(
    [ValidateSet('RelWithDebInfo', 'Release', 'Debug')]
    [string]$Configuration = 'RelWithDebInfo',
    [string]$SdkPath,
    [string]$JavaPath,
    [string]$GradleCache,
    [ValidateRange(1, 64)]
    [int]$Jobs = 8,
    [switch]$CheckEnvironment
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

if (-not $SdkPath) { $SdkPath = $env:ANDROID_HOME }
if (-not $SdkPath) { $SdkPath = $env:ANDROID_SDK_ROOT }
if (-not $SdkPath) { $SdkPath = Join-Path $env:LOCALAPPDATA 'Android\Sdk' }
if (-not (Test-Path -LiteralPath $SdkPath -PathType Container)) {
    throw 'Android SDK not found. Install it with Android Studio or pass -SdkPath.'
}
$SdkPath = (Resolve-Path -LiteralPath $SdkPath).Path

if (-not $JavaPath -and $env:JAVA_HOME -and
    (Test-Path -LiteralPath (Join-Path $env:JAVA_HOME 'bin\java.exe') -PathType Leaf)) {
    $JavaPath = $env:JAVA_HOME
}
if (-not $JavaPath) { $JavaPath = Join-Path $env:ProgramFiles 'Android\Android Studio\jbr' }
if (-not (Test-Path -LiteralPath (Join-Path $JavaPath 'bin\java.exe') -PathType Leaf)) {
    throw 'Java not found. Pass -JavaPath with a JDK 17 or newer installation.'
}
$JavaPath = (Resolve-Path -LiteralPath $JavaPath).Path
if (-not $GradleCache) { $GradleCache = $env:GRADLE_USER_HOME }
if (-not $GradleCache) { $GradleCache = Join-Path $repoRoot '.cache\gradle' }

Write-Host "Java: $JavaPath"
Write-Host "Android SDK: $SdkPath"
Write-Host "Gradle cache: $GradleCache"
foreach ($package in @('platforms\android-36', 'ndk\28.2.13676358', 'cmake\3.31.5')) {
    $state = if (Test-Path -LiteralPath (Join-Path $SdkPath $package)) { 'installed' } else { 'needed' }
    Write-Host "${package}: $state"
}
if ($CheckEnvironment) { return }

$previousEnvironment = @{}
foreach ($name in @('JAVA_HOME', 'ANDROID_HOME', 'ANDROID_SDK_ROOT', 'GRADLE_USER_HOME', 'CMAKE_BUILD_PARALLEL_LEVEL', 'PATH')) {
    $previousEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
}

Push-Location (Join-Path $repoRoot 'src\android')
try {
    $env:JAVA_HOME = $JavaPath
    $env:ANDROID_HOME = $SdkPath
    $env:ANDROID_SDK_ROOT = $SdkPath
    $env:GRADLE_USER_HOME = $GradleCache
    $env:CMAKE_BUILD_PARALLEL_LEVEL = $Jobs.ToString()
    $shaderTools = Join-Path $repoRoot '.cache\host-tools\glslang\bin'
    if (Test-Path -LiteralPath $shaderTools -PathType Container) {
        $env:PATH = "$shaderTools;$env:PATH"
    }
    & .\gradlew.bat ":app:assembleMainline$Configuration" --no-daemon --console=plain "--max-workers=$Jobs"
    if ($LASTEXITCODE -ne 0) { throw "Android build failed with exit code $LASTEXITCODE." }

    $buildType = $Configuration.Substring(0, 1).ToLowerInvariant() + $Configuration.Substring(1)
    $apk = Join-Path $repoRoot "src\android\app\build\outputs\apk\mainline\$buildType\app-mainline-$buildType.apk"
    if (-not (Test-Path -LiteralPath $apk -PathType Leaf)) {
        throw "Gradle completed, but the expected APK was not found: $apk"
    }
    $artifacts = Join-Path $repoRoot 'artifacts'
    New-Item -ItemType Directory -Path $artifacts -Force | Out-Null
    $destination = Join-Path $artifacts "lichii-thor-$buildType-arm64.apk"
    Copy-Item -LiteralPath $apk -Destination $destination
    Write-Host "APK: $destination"
} finally {
    Pop-Location
    foreach ($name in $previousEnvironment.Keys) {
        [Environment]::SetEnvironmentVariable($name, $previousEnvironment[$name], 'Process')
    }
}
