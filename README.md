# ffmpeg-libs

MacOS libraries obtained from [Ffmpeg-macos](https://github.com/ColorsWind/FFmpeg-macOS)

```
    add_custom_target(
      fix_ffmpeg_install_names ALL
      COMMAND install_name_tool -id "@rpath/libavcodec.dylib" "${FFMPEG_LIBRARY_DIRS}/libavcodec.dylib"
      COMMAND install_name_tool -id "@rpath/libavformat.dylib" "${FFMPEG_LIBRARY_DIRS}/libavformat.dylib"
      COMMAND install_name_tool -id "@rpath/libavfilter.dylib" "${FFMPEG_LIBRARY_DIRS}/libavfilter.dylib"
      COMMAND install_name_tool -id "@rpath/libavdevice.dylib" "${FFMPEG_LIBRARY_DIRS}/libavdevice.dylib"
      COMMAND install_name_tool -id "@rpath/libavutil.dylib" "${FFMPEG_LIBRARY_DIRS}/libavutil.dylib"
      COMMAND install_name_tool -id "@rpath/libswresample.dylib" "${FFMPEG_LIBRARY_DIRS}/libswresample.dylib"
      COMMAND install_name_tool -id "@rpath/libswscale.dylib" "${FFMPEG_LIBRARY_DIRS}/libswscale.dylib"
      
      # Now change the dependent references inside libraries:
    # For libavcodec.dylib: update its reference to libswresample.4.dylib
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libswresample.4.dylib" "@rpath/libswresample.dylib" "${FFMPEG_LIBRARY_DIRS}/libavcodec.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavutil.57.dylib" "@rpath/libavutil.dylib" "${FFMPEG_LIBRARY_DIRS}/libavcodec.dylib"

    # For libavformat.dylib: update its reference to libavcodec.59.dylib (if present)
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavcodec.59.dylib" "@rpath/libavcodec.dylib" "${FFMPEG_LIBRARY_DIRS}/libavformat.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libswresample.4.dylib" "@rpath/libswresample.dylib" "${FFMPEG_LIBRARY_DIRS}/libavformat.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavutil.57.dylib" "@rpath/libavutil.dylib" "${FFMPEG_LIBRARY_DIRS}/libavformat.dylib"

    # For libavfilter.dylib: update its reference to libswscale.6.dylib, if present
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libswscale.6.dylib" "@rpath/libswscale.dylib" "${FFMPEG_LIBRARY_DIRS}/libavfilter.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavformat.59.dylib" "@rpath/libavformat.dylib" "${FFMPEG_LIBRARY_DIRS}/libavfilter.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavcodec.59.dylib" "@rpath/libavcodec.dylib" "${FFMPEG_LIBRARY_DIRS}/libavfilter.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libswresample.4.dylib" "@rpath/libswresample.dylib" "${FFMPEG_LIBRARY_DIRS}/libavfilter.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavutil.57.dylib" "@rpath/libavutil.dylib" "${FFMPEG_LIBRARY_DIRS}/libavfilter.dylib"
    
    # For libavdevice.dylib: update its reference to libavfilter.8.dylib, if present
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavfilter.8.dylib" "@rpath/libavfilter.dylib" "${FFMPEG_LIBRARY_DIRS}/libavdevice.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libswscale.6.dylib" "@rpath/libswscale.dylib" "${FFMPEG_LIBRARY_DIRS}/libavdevice.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavformat.59.dylib" "@rpath/libavformat.dylib" "${FFMPEG_LIBRARY_DIRS}/libavdevice.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavcodec.59.dylib" "@rpath/libavcodec.dylib" "${FFMPEG_LIBRARY_DIRS}/libavdevice.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libswresample.4.dylib" "@rpath/libswresample.dylib" "${FFMPEG_LIBRARY_DIRS}/libavdevice.dylib"
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavutil.57.dylib" "@rpath/libavutil.dylib" "${FFMPEG_LIBRARY_DIRS}/libavdevice.dylib"
    
    # For libswresample.dylib: update its reference to libavutil.57.dylib, if present
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavutil.57.dylib" "@rpath/libavutil.dylib" "${FFMPEG_LIBRARY_DIRS}/libswresample.dylib"
    
    # For libswscale.dylib: update its reference to libavutil.57.dylib, if present
    COMMAND install_name_tool -change "/Users/runner/work/FFmpeg-macOS/FFmpeg-macOS/ffmpeg/install_universal/lib/libavutil.57.dylib" "@rpath/libavutil.dylib" "${FFMPEG_LIBRARY_DIRS}/libswscale.dylib"
    
      COMMENT "Fixing FFmpeg install names")
```
