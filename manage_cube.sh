#!/bin/bash

HOSTNAME="localhost"
PORT="48000"
USERNAME="root"
HOMEDIR="/home/debian/"
PROJECTNAME="BBBCube"
APPNAME="${PROJECTNAME}_app"
BUILD_DIR_DEBUG="debug"
BUILD_DIR_RELEASE="release"
BUILD_DIR_NATIVE="build_native"
BUILD_DIR_BBB="build_BBB"

RELEASE_PATH_NATIVE="$BUILD_DIR_NATIVE/$BUILD_DIR_RELEASE/$APPNAME"
DEBUG_PATH_NATIVE="$BUILD_DIR_NATIVE/$BUILD_DIR_DEBUG/$APPNAME"
RELEASE_PATH_BBB="$BUILD_DIR_BBB/$BUILD_DIR_RELEASE/$APPNAME"
DEBUG_PATH_BBB="$BUILD_DIR_BBB/$BUILD_DIR_DEBUG/$APPNAME"

file2BBB() {
    if [ $# -ne 1 ]; then
        echo "copy file to BBB needs 1 argument"
        exit 1
    fi
    local file=$1
    echo "Copying file $file to BBB"
    scp -P "${PORT}" "$file" "$USERNAME"@"$HOSTNAME":"$HOMEDIR"
    return $?
}

build_debug_native() {
    echo "Building debug native"
    make BUILD=Debug TARGET_PLATFORM=native
    return $?
}

build_debug_bbb() {
    echo "Building debug bbb"
    make BUILD=Debug TARGET_PLATFORM=bbb
    return $?
}

build_release_native() {
    echo "Building release native"
    make BUILD=Release TARGET_PLATFORM=native
    return $?
}

build_release_bbb() {
    echo "Building release bbb"
    make BUILD=Release TARGET_PLATFORM=bbb
    return $?
}

run_debug_native() {
    echo "Running debug native"
    if ! build_debug_native; then
        echo "Failed to build debug native"
        exit 1
    fi
    ./"$DEBUG_PATH_NATIVE"
}

run_debug_bbb() {
    echo "Running debug on bbb"
    if ! build_debug_bbb; then
        echo "Failed to build debug bbb"
        exit 1
    fi
    if ! file2BBB "$DEBUG_PATH_BBB"; then
        echo "Failed to copy file to BBB"
        exit 1
    fi
    # shellcheck disable=SC2029
    ssh -p "${PORT}" "$USERNAME"@"$HOSTNAME" "sudo -n ${HOMEDIR}${APPNAME}"
}

run_release_native() {
    echo "Running release native"
    if ! build_release_native ; then
        echo "Failed to build release native"
        exit 1
    fi
    ./"$RELEASE_PATH_NATIVE"
}

run_release_bbb() {
    echo "Running release on bbb"
    if ! build_release_bbb ; then
        echo "Failed to build release bbb"
        exit 1
    fi
    if ! file2BBB "$RELEASE_PATH_BBB"; then
        echo "Failed to copy file to BBB"
        exit 1
    fi
    # shellcheck disable=SC2029
    ssh -p "${PORT}" "$USERNAME"@"$HOSTNAME" "sudo -n ${HOMEDIR}${APPNAME}"
}

clean() {
    echo "Cleaning project"
    make clean
}

start_debugger_native() {
    echo "Starting native debugger"
    if ! build_debug_native; then
        echo "Failed to build debug native"
        exit 1
    fi
}

start_debugger_bbb() {
    echo "Starting gdb"
    if ! build_debug_bbb; then
        echo "Failed to build debug bbb"
        exit 1
    fi
    if ! file2BBB "$DEBUG_PATH_BBB"; then
        echo "Failed to copy file to BBB"
        exit 1
    fi
    # shellcheck disable=SC2029
    ssh -p "${PORT}" "$USERNAME"@"$HOSTNAME" "gdbserver :2345 ${HOMEDIR}${APPNAME}"
}

sshkey2BBB() {
    echo "Copy ssh-Key to BBB"
    ssh-copy-id -p "$PORT" "$USERNAME"@"$HOSTNAME"
}

if [ "$(basename "$(pwd)")" != "${PROJECTNAME}" ]; then
    echo "Please run this script from the ${PROJECTNAME} directory"
    exit 1
fi

while [ $# -gt 0 ]; do
    case "$1" in
        -bdn|--build-debug-native)
            build_debug_native
            ;;
        -bdbbb|--build-debug-bbb)
            build_debug_bbb
            ;;
        -brn|--build-release-native)
            build_release_native
            ;;
        -brbbb|--build-release-bbb)
            build_release_bbb
            ;;
        -rdn|--run-debug-native)
            run_debug_native
            ;;
        -rdbbb|--run-debug-bbb)
            run_debug_bbb
            ;;
        -rrn|--run-release-native)
            run_release_native
            ;;
        -rrbbb|--run-release-bbb)
            run_release_bbb
            ;;
        -c|--clean)
            clean
            ;;
        -sdn|--start-debugger-native)
            start_debugger_native
            ;;
        -sdbbb|--start-debugger-bbb)
            start_debugger_bbb
            ;;
        -sshkey|--copy-sshkey)
            sshkey2BBB
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *) 
            echo "Uknown argument: $1"
            ;;
    esac
    shift
done

echo "done"