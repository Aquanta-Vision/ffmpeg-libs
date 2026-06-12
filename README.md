# ffmpeg-libs — ios-simulator-4.x

FFmpeg 4.3.1 built as static **arm64 iOS Simulator** libraries, the simulator
counterpart of the `ios-4.x` branch (device fat libs from
[FFmpeg-iOS-build-script](https://github.com/kewlbear/FFmpeg-iOS-build-script)).
A device slice cannot link into a simulator binary, and GitHub macOS runners
only offer simulators, so netxten-aquantavision's CI integration tests consume
this branch (`PLATFORM=SIMULATORARM64` in `make_iOS.sh` / `Dependencies.cmake`).

Unlike the device branch these libs are already thin (single-arch), so
`make_iOS.sh` copies them instead of `lipo -thin arm64`.

Built with `--disable-asm` to stay SDK-version-proof — the artifact is for
integration tests only, where C-path decode speed on the host CPU is plenty.

Build (run in CI by netxten-aquantavision's `build_ios_sim_deps.yml` on
macos-26 / Xcode 26.2; exact SDK versions in `toolchain.txt`):

```sh
curl -L -o ffmpeg.tar.bz2 https://ffmpeg.org/releases/ffmpeg-4.3.1.tar.bz2
tar xjf ffmpeg.tar.bz2
cd ffmpeg-4.3.1
./configure \
  --prefix=../FFmpeg-iOS \
  --enable-cross-compile \
  --target-os=darwin \
  --arch=arm64 \
  --cc="xcrun -sdk iphonesimulator clang" \
  --extra-cflags="-arch arm64 -mios-simulator-version-min=13.0" \
  --extra-ldflags="-arch arm64 -mios-simulator-version-min=13.0" \
  --enable-static --disable-shared --enable-pic \
  --disable-debug --disable-programs --disable-doc \
  --disable-asm
make -j"$(sysctl -n hw.ncpu)"
make install
```
