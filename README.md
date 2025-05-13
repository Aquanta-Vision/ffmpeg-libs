# ffmpeg-libs

FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. This repository provides pre-compiled FFmpeg libraries, making it easier to integrate FFmpeg into your projects for various target platforms.

## Available Platforms and Branches

This repository contains pre-compiled FFmpeg libraries for various platforms. Each platform has its own dedicated branch. To use the libraries for a specific platform, please clone or check out the corresponding branch:

*   **main**: Linux
*   **windows**: Windows
*   **ios**: iOS
*   **macos**: macOS
*   **android**: Android

## Usage

1.  **Clone the repository and switch to the desired branch:**
    ```bash
    git clone https://your-repository-url/ffmpeg-libs.git
    cd ffmpeg-libs
    git checkout <branch-name> 
    ```
    Replace `<branch-name>` with the target platform's branch (e.g., `android`, `windows`).

2.  **Locate the libraries:**
    The pre-compiled libraries (e.g., `.so`, `.dll`, `.dylib`, `.a`) and header files will be available in the branch, typically organized by architecture (e.g., `x86_64`, `armeabi-v7a`).

3.  **Integrate with your project:**
    *   Include the FFmpeg header files in your project.
    *   Link against the compiled FFmpeg libraries in your build system (e.g., CMake, Makefile, Gradle). The exact steps will depend on your specific development environment and build tools.

## Examples

For examples on how to use FFmpeg, please refer to the official FFmpeg documentation and community resources. Specific examples tailored to these pre-compiled libraries might be added to individual branches in the future.