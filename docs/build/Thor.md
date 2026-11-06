# Lichii Thor Android bring-up

Target: AYN Thor Max, 16 GB RAM. First game: The Legend of Zelda: Ocarina of
Time for Switch 2. This is an experimental Android build of the emulator;
this repository does not contain the game's source code.

## Source

- Base: [Frizti v2](https://github.com/Frizti/Lichii/releases/tag/frizti-v2),
  commit `765659af4ccb7201d1145c57f3b45ce84653cea0`.
- Local branch: `android/thor-max`.
- Android `.nup` library discovery, container validation, ARM64 atomic
  compatibility, and vsync duration types follow the fixes
  in [pavelgajdo/Lichii-Android](https://github.com/pavelgajdo/Lichii-Android),
  inspected at `030e11ba280ad04d8799c755b8d4326655e8d17f`.
- Eglantine's `nx2` and `ci/android-release` branches were inspected. The
  Frizti release remains the base so its game-specific changes are retained.

## Local changes

- The mainline flavor installs as `dev.lichii.thor`, named **Lichii Thor**.
  The default development build adds `.relWithDebInfo` to the package ID.
- Android discovers `.nup` files and checks that containers contain a bootable
  game, including Switch 2 NUP containers.
- The Android ARM64 exclusive monitor uses compiler atomic builtins with the
  original memory ordering because NDK 28's libc++ lacks `std::atomic_ref`.
  Other platform paths retain their existing implementation.
- Vsync diagnostics explicitly compare signed 64-bit durations, accommodating
  Android's different `std::chrono::nanoseconds::rep` type.
- Shader compilation accepts both `glslangValidator` and the newer `glslang`
  executable name.
- `tools/android/build-thor.ps1` finds the SDK and Android Studio JDK, builds
  ARM64, restores its environment changes, and copies a successful APK into
  `artifacts/`.

## Windows build

The Gradle project requests Java 17 or newer, Android SDK platform 36,
NDK `28.2.13676358`, and CMake `3.31.5`. Android Studio's bundled JDK works.
Install the SDK packages through Android Studio's SDK Manager. The build
also needs a Windows host GLSL compiler in `PATH`.

From the repository root:

```powershell
.\tools\android\build-thor.ps1 -CheckEnvironment
.\tools\android\build-thor.ps1
```

Use `-SdkPath`, `-JavaPath`, or `-GradleCache` to override discovery. Gradle
defaults to this repository's `.cache/gradle` unless `GRADLE_USER_HOME` is set.
For the cache used during initial bring-up:

```powershell
.\tools\android\build-thor.ps1 -GradleCache E:\Switch2\.gradle-cache
```

Expected output after a successful build:
`artifacts/lichii-thor-relWithDebInfo-arm64.apk`.
The build uses the repository's development signing key.

The initial bring-up downloaded the official Khronos Windows shader compiler
into `.cache/host-tools/glslang/bin`, which the script adds to the build's
`PATH`. Its archive was
`glslang-main-windows-x86_64-release.zip` from the `main-tot` release, verified
against GitHub's SHA-256 asset digest:
`9cb7ae52d8ddd52133959d0348afca719558a3273a96e5a2cc4450369fa191ad`.
The `main-tot` asset is mutable; a later download may have a different hash.

## Verified build

On November 6, 2026, `assembleMainlineRelWithDebInfo` completed successfully
with NDK 28.2 and CMake 3.31.5 on Windows. The resulting APK is 53,360,225 bytes.

- APK v2 signature verification passed with one development signer.
- ZIP integrity passed; all seven packaged native libraries are ELF64 AArch64.
- Package: `dev.lichii.thor.relWithDebInfo`.
- Label: `Lichii Thor Debug Release`; minimum Android API 33.
- SHA-256: `ff46d21896215b10557d9d4e5b3729e907efee6c4871ab9968b1ef86484f7d03`.
- `git diff --check` passed.

These checks verify the build artifact, not installation or gameplay.

## Device validation still required

An APK compiling successfully does not establish that a game boots, renders
correctly, or runs at a useful frame rate. No Thor was attached during the
initial USB check.

1. Install the development APK on the Thor and check library scanning and
   built-in controller input.
2. Record the actual Android version, Vulkan driver and available features.
   Compare the system driver with an appropriate Adreno custom driver only
   after collecting that baseline.
3. Test Zelda in handheld mode at 1x resolution, using Dynarmic/JIT for the
   initial CPU baseline and comparing NCE separately.
   Record title screen, movie playback, first gameplay frame, and a repeatable
   gameplay scene separately. Use the game and system files already supplied
   by the owner on the device.
4. Collect the emulator log and resident memory use before changing graphics
   or memory behavior.

Important limits visible in this source:

- The CPU core already supports Android ARM64 and NCE. This work reuses that
  support rather than rewriting the emulator.
- The comparison fork also adds Switch 2 pointer-authentication instruction
  rewrites to NCE. This first build has not imported that runtime change;
  NCE startup compatibility must be checked before relying on it for Zelda.
- Switch 2 titles force the 12 GiB memory setting and add a 2 GiB graphics
  server region (`core.cpp`, `k_system_control.cpp`). This is a 14 GiB backing
  layout, not a measurement of resident RAM. Actual use, Android's memory
  pressure, and GPU allocations must be measured on the 16 GB Thor.
- The Vulkan backend skips task/mesh pipelines without `VK_EXT_mesh_shader`,
  and native geometry pipelines without geometry shader support. We have
  not measured the Thor driver's capabilities. A driver feature check and
  affected game scenes are needed before designing any graphics fallback.
- The comparison Android fork reports Zelda title-screen and movie playback
  on an Exynos/Xclipse phone, with a hang loading gameplay. Those results do
  not establish Adreno/Thor compatibility.

Do not reduce the guest memory layout or force unsupported Vulkan features
merely to get past initialization: neither would demonstrate a correct port.
