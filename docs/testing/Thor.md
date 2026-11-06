# Testing Lichii Thor

This test checks what the experimental Android build can do on real hardware.
No Thor gameplay has been verified yet. A title screen or working intro movie
does not establish that gameplay works.

## Install

1. Open the [releases page](https://github.com/rigoroso-tyler/Lichii-Thor/releases)
   on the Thor and download `lichii-thor-relWithDebInfo-arm64.apk` from the
   newest Thor test release.
2. Open the APK and install it using Android's normal installation flow.
   The app is named **Lichii Thor Debug Release** and requires Android 13+.
3. Complete setup with your own game and system files, then select the folder
   holding the game. This release includes no game files, keys or firmware.

The package is `dev.lichii.thor.relWithDebInfo`, separate from Eden and the
comparison Android fork. Updates from this project use the same development
signing key so test installations can be updated in place.

## First run

Record the Thor model and RAM, Android version, APK filename, game version,
and GPU driver before testing. Start with the system GPU driver, handheld
mode, 1x resolution and the Dynarmic/JIT CPU backend. Leave other settings at
their defaults. NCE can be compared in a separate run; its Switch 2 startup
compatibility is still under investigation.

For Zelda: Ocarina of Time (Switch 2), report each stage separately:

| Stage | What to record |
| --- | --- |
| App launch | App opens, crashes, or shows an error |
| Library | Game is discovered and its title/icon appear |
| Title screen | Image, sound and controls work |
| Intro movies | Video and audio play; note stalls or corruption |
| First gameplay load | Gameplay appears, hangs, or crashes; wait time |
| Gameplay | A repeatable scene, rendering issues, controls and approximate FPS |

If a stage fails, report the failure before changing settings. For subsequent
comparisons, change one setting at a time and record the driver and CPU
backend for each run. An unsupported driver feature can cause missing
geometry; lowering resolution does not replace that feature.

## Send results

Use [Thor test result](https://github.com/rigoroso-tyler/Lichii-Thor/issues/new?template=thor_test.yml)
to report success, a crash, or a hang. In the app's home settings, **Share debug
logs** exports the emulator log. Capture it immediately after the failing
run, before starting another game. Screenshots are useful for rendering bugs.

The normal log location is:
`Android/data/dev.lichii.thor.relWithDebInfo/files/log/eden_log.txt`.
Android may restrict direct file-manager access; use the app's share action.

Check logs for personal information before attaching them to a public issue.
Do not attach games, keys, firmware or account data.
