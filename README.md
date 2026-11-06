<!--
# SPDX-FileCopyrightText: Copyright 2025 Eden Emulator Project
# SPDX-License-Identifier: GPL-3.0-or-later

# SPDX-FileCopyrightText: 2018 yuzu Emulator Project
# SPDX-License-Identifier: GPL-2.0-or-later
-->

> **Archived predecessor:** active development has moved to [Aven](https://github.com/rigoroso-tyler/Aven), a standalone Android emulator project. Download the [Aven test release](https://github.com/rigoroso-tyler/Aven/releases) and submit new test reports in [Aven Issues](https://github.com/rigoroso-tyler/Aven/issues). This repository and its original APK remain available as a historical snapshot.

<p align="center">
  <img src="dist/branding/lichii_icon_with_logo.png" alt="Lichii" width="600">
</p>

# Lichii Thor

An experimental Android ARM64 build of [Frizti's Lichii](https://github.com/Frizti/Lichii/releases/tag/frizti-v2), prepared for testing on the AYN Thor. The first target is The Legend of Zelda: Ocarina of Time for Switch 2, with the Thor Max's 16 GB RAM configuration as the initial hardware target.

This is an independent emulator fork, not a native port of the game. It builds on Lichii, Eglantine, Eden, yuzu and Sudachi and is not affiliated with Nintendo or endorsed by those projects.

## Downloads and setup

Download the `.apk` from this fork's [test releases](https://github.com/rigoroso-tyler/Lichii-Thor/releases). The first build is `lichii-thor-relWithDebInfo-arm64.apk`, about 51 MiB.

Requirements: ARM64 Android 13 or newer. The app installs as **Lichii Thor Debug Release**, package `dev.lichii.thor.relWithDebInfo`. Games, keys and firmware are not included.

**Current status: the APK builds and its signature and ARM64 libraries have been verified. Installation, game startup, graphics, controls and performance have not been tested on a Thor.**

Follow the [Thor testing guide](docs/testing/Thor.md). This build has its own Android package and data directory, allowing it to be installed alongside Eden and other emulator builds.

## Compatibility and issue reports

Compatibility and performance vary by game, hardware and driver. Rendering errors, stutters and crashes remain possible. Passing automated tests does not establish that a game renders correctly, and this project makes no universal frame-rate guarantee.

When [reporting a test result](https://github.com/rigoroso-tyler/Lichii-Thor/issues/new?template=thor_test.yml), include:

- The APK version, Thor model and RAM, Android version and GPU driver.
- The game version, CPU backend, settings and the furthest stage reached.
- A screenshot and the log from the affected session, after checking it for personal information.

Do not upload game files, keys, firmware or private account information.

## Building and contributing

See the [Thor build notes](docs/build/Thor.md) for source provenance, changes, toolchain versions and known gaps. On Windows with the Android SDK and required tools installed:

```powershell
.\tools\android\build-thor.ps1
```

The output is written to `artifacts/`. The inherited [build guide](docs/Build.md), [user documentation](docs/user/README.md) and [coding guidelines](docs/Coding.md) remain available. Some internal names still use upstream project names.

Keep changes focused and distinguish code-level checks from actual gameplay testing.

## Artwork
Art created by YOB (yobslab)
The supplied Lichii logo, icon and library artwork are in [dist/branding](dist/branding). Windows, Linux and macOS icon resources are generated from that artwork by [Generate-LichiiIcons.ps1](tools/Generate-LichiiIcons.ps1).

## Credits and license

This fork starts from Frizti's Lichii v2 and adapts Android compatibility fixes from pavelgajdo's Lichii-Android. Lichii inherits the work of zortos293, Eglantine, Eden, yuzu and Sudachi and their contributors, including Eglantine's original developer Camille LaVey. Original copyright notices and third-party licenses are retained.

See [LICENSE.txt](LICENSE.txt) and the source files for applicable license terms.
