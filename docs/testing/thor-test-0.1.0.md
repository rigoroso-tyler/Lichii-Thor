# Lichii Thor test 0.1.0

First experimental Android ARM64 build based on Frizti Lichii v2, prepared
for testing on the AYN Thor. The initial hardware target is Thor Max with
16 GB RAM; the first game target is Zelda: Ocarina of Time for Switch 2.

## Download

Install **lichii-thor-relWithDebInfo-arm64.apk** from the assets below.
Android 13 or newer is required. GitHub's automatic source archives contain
source code rather than an installable app.

The app appears as **Lichii Thor Debug Release**, package
`dev.lichii.thor.relWithDebInfo`. It installs alongside Eden and other forks.
Games, keys and firmware are not included.

## Changes

- Android library discovery and validation for Switch 2 `.nup` files.
- Android ARM64 atomic-operation and vsync-duration build fixes adapted from
  pavelgajdo/Lichii-Android.
- Separate Thor app identity and a Windows build helper.
- Support for both current and legacy host GLSL compiler executable names.

## Validation and known limits

The initial local build passed compilation, APK signature verification,
archive integrity and ARM64 library checks. No installation or gameplay on
a Thor has been verified. This prerelease is for collecting device results.

Switch 2 memory use and unsupported GPU features can prevent correct
rendering or startup. NCE pointer-authentication compatibility work from the
comparison Android fork is not included in this initial build. Start with
Dynarmic/JIT, handheld mode, 1x resolution and the system GPU driver.

Follow the [testing guide](https://github.com/rigoroso-tyler/Lichii-Thor/blob/android/thor-max/docs/testing/Thor.md)
and [report results](https://github.com/rigoroso-tyler/Lichii-Thor/issues/new?template=thor_test.yml).
Use the app's **Share debug logs** action after the failing run.

Source credits and license notices are retained. See the repository's
[build notes](https://github.com/rigoroso-tyler/Lichii-Thor/blob/android/thor-max/docs/build/Thor.md)
for provenance and details. The release checksum file identifies the APK.
