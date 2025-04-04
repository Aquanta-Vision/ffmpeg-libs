#!/bin/bash

set -e

# Get the directory containing this script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# --- Configuration ---
# !!! SET THIS TO THE DIRECTORY CONTAINING YOUR PREBUILT LIBS !!!
PREBUILT_LIB_DIR=$SCRIPT_DIR

# Suffix to add to the renamed libraries
SUFFIX="_my"

# Path to the patchelf command (usually just 'patchelf' if it's in your PATH)
PATCHELF_CMD="patchelf"
# ---------------------

# List of base FFmpeg library names to process (without 'lib' prefix or '.so' suffix)
FFMPEG_LIBS=(
    "avcodec"
    "avdevice"
    "avfilter"
    "avformat"
    "avutil"
    "postproc"
    "swresample"
    "swscale"
)

# --- Helper function for error messages ---
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# --- Sanity Checks ---
echo "--- Checking Prerequisites ---"
if ! command -v "$PATCHELF_CMD" &> /dev/null; then
    error_exit "'$PATCHELF_CMD' command not found. Please install patchelf or update PATCHELF_CMD path."
fi
echo "Found '$PATCHELF_CMD'."

if [ ! -d "$PREBUILT_LIB_DIR" ]; then
    error_exit "Prebuilt library directory not found: '$PREBUILT_LIB_DIR'"
fi
echo "Using library directory: '$PREBUILT_LIB_DIR'"
echo "----------------------------"
echo ""

# --- Renaming Phase ---
echo "--- Renaming Libraries (Adding suffix: ${SUFFIX}) ---"
for lib_base_name in "${FFMPEG_LIBS[@]}"; do
    original_file="${PREBUILT_LIB_DIR}/lib${lib_base_name}.so"
    renamed_file="${PREBUILT_LIB_DIR}/lib${lib_base_name}${SUFFIX}.so"

    if [ -f "$original_file" ]; then
        echo "Renaming '$original_file' to '$renamed_file'..."
        cp "$original_file" "$renamed_file" || error_exit "Failed to rename '$original_file'"
    elif [ -f "$renamed_file" ]; then
        echo "Already renamed: '$renamed_file' exists."
    else
        echo "Warning: Original file not found, skipping rename: '$original_file'"
    fi
done
echo "----------------------------"
echo ""

# --- Patching Phase ---
# TODO: Add specific patchelf --replace-needed commands here based on ldd output
# You will need to determine these based on the dependencies shown by ldd for EACH renamed library.
echo "--- Patching Internal Dependencies (Placeholders) ---"

# Example structure for patching libavcodec_my.so (replace ... with actual paths/names)
TARGET_LIB_FILE="${PREBUILT_LIB_DIR}/libavdevice${SUFFIX}.so"
echo "Patching $TARGET_LIB_FILE ..."
"$PATCHELF_CMD" --replace-needed libswresample.so "libswresample${SUFFIX}.so" $TARGET_LIB_FILE

"$PATCHELF_CMD" --replace-needed libavutil.so "libavutil${SUFFIX}.so" "${PREBUILT_LIB_DIR}/libavdevice${SUFFIX}.so"
echo "Done patching $TARGET_LIB_FILE."
echo "----------------------------"

# --- Patching libavdevice${SUFFIX}.so ---
TARGET_LIB_FILE="${PREBUILT_LIB_DIR}/libavdevice${SUFFIX}.so"
if [ -f "$TARGET_LIB_FILE" ]; then
    echo "Patching '$TARGET_LIB_FILE'..."

    # Replace needed 'libavfilter.so' with 'libavfilter_my.so'
    echo "  Replacing needed libavfilter.so -> libavfilter${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libavfilter.so "libavfilter${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libavfilter.so dependency in $TARGET_LIB_FILE"

    # Replace needed 'libavformat.so' with 'libavformat_my.so'
    echo "  Replacing needed libavformat.so -> libavformat${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libavformat.so "libavformat${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libavformat.so dependency in $TARGET_LIB_FILE"

    # Replace needed 'libavcodec.so' with 'libavcodec_my.so'
    echo "  Replacing needed libavcodec.so -> libavcodec${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libavcodec.so "libavcodec${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libavcodec.so dependency in $TARGET_LIB_FILE"

    # Replace needed 'libavutil.so' with 'libavutil_my.so'
    echo "  Replacing needed libavutil.so -> libavutil${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libavutil.so "libavutil${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libavutil.so dependency in $TARGET_LIB_FILE"

    # Replace needed 'libswscale.so' with 'libswscale_my.so'
    echo "  Replacing needed libswscale.so -> libswscale${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libswscale.so "libswscale${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libswscale.so dependency in $TARGET_LIB_FILE"

    # Replace needed 'libswresample.so' with 'libswresample_my.so'
    echo "  Replacing needed libswresample.so -> libswresample${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libswresample.so "libswresample${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libswresample.so dependency in $TARGET_LIB_FILE"

    echo "Done patching '$TARGET_LIB_FILE'."
else
    echo "Skipping patch for '$TARGET_LIB_FILE' (File not found)."
fi
echo "----------------------------"

# --- Patching libavfilter${SUFFIX}.so ---
TARGET_LIB_FILE="${PREBUILT_LIB_DIR}/libavfilter${SUFFIX}.so"
if [ -f "$TARGET_LIB_FILE" ]; then
    echo "Patching '$TARGET_LIB_FILE'..."

    # Replace needed 'libpostproc.so' with 'libpostproc_my.so' (Based on assumption/ldd error)
    echo "  Replacing needed libpostproc.so -> libpostproc${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libpostproc.so "libpostproc${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libpostproc.so dependency in $TARGET_LIB_FILE"

    # !!! WARNING: libavfilter likely has OTHER dependencies (e.g., libavutil, libswscale) !!!
    # !!! You STILL need to get the full ldd output for libavfilter_my.so     !!!
    # !!! (using the temporary rename workaround) and add --replace-needed    !!!
    # !!! commands for those other dependencies here later.                   !!!
    # Example placeholder:
    # echo "  Replacing needed libavutil.so -> libavutil${SUFFIX}.so"
    # "$PATCHELF_CMD" --replace-needed libavutil.so "libavutil${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed..."

    echo "Done patching '$TARGET_LIB_FILE' (potentially incomplete)."
else
    echo "Skipping patch for '$TARGET_LIB_FILE' (File not found)."
fi
echo "----------------------------"

# --- Patching libpostproc${SUFFIX}.so ---
TARGET_LIB_FILE="${PREBUILT_LIB_DIR}/libpostproc${SUFFIX}.so"
if [ -f "$TARGET_LIB_FILE" ]; then
    echo "Patching '$TARGET_LIB_FILE'..."

    # Replace needed 'libavutil.so' with 'libavutil_my.so'
    echo "  Replacing needed libavutil.so -> libavutil${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libavutil.so "libavutil${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libavutil.so dependency in $TARGET_LIB_FILE"

    echo "Done patching '$TARGET_LIB_FILE'."
else
    echo "Skipping patch for '$TARGET_LIB_FILE' (File not found)."
fi
echo "----------------------------"

# --- Patching libswresample${SUFFIX}.so ---
TARGET_LIB_FILE="${PREBUILT_LIB_DIR}/libswresample${SUFFIX}.so"
if [ -f "$TARGET_LIB_FILE" ]; then
    echo "Patching '$TARGET_LIB_FILE'..."

    # Replace needed 'libavutil.so' with 'libavutil_my.so'
    echo "  Replacing needed libavutil.so -> libavutil${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libavutil.so "libavutil${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libavutil.so dependency in $TARGET_LIB_FILE"

    echo "Done patching '$TARGET_LIB_FILE'."
else
    echo "Skipping patch for '$TARGET_LIB_FILE' (File not found)."
fi
echo ""

# --- Patching libswscale${SUFFIX}.so ---
TARGET_LIB_FILE="${PREBUILT_LIB_DIR}/libswscale${SUFFIX}.so"
if [ -f "$TARGET_LIB_FILE" ]; then
    echo "Patching '$TARGET_LIB_FILE'..."

    # Replace needed 'libavutil.so' with 'libavutil_my.so'
    echo "  Replacing needed libavutil.so -> libavutil${SUFFIX}.so"
    "$PATCHELF_CMD" --replace-needed libavutil.so "libavutil${SUFFIX}.so" "$TARGET_LIB_FILE" || echo "  WARNING: Failed to replace libavutil.so dependency in $TARGET_LIB_FILE"

    echo "Done patching '$TARGET_LIB_FILE'."
else
    echo "Skipping patch for '$TARGET_LIB_FILE' (File not found)."
fi
echo ""

# --- Add similar blocks for ALL other renamed libraries that need patching ---
# (e.g., libavdevice_my.so, libavfilter_my.so, libpostproc_my.so, libswresample_my.so, libswscale_my.so)
# Remember that libavutil_my.so likely won't need internal FFmpeg dependencies replaced.

echo "----------------------------"
echo ""
echo "--- Script Finished ---"

exit 0
