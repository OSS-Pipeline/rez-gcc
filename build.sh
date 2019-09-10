#!/usr/bin/bash

echo "\n=== IN THE BUILD SCRIPT ===\n"

build_path=$1
gcc_version=$2

echo -e "\n============="
echo -e "=== BUILD ==="
echo -e "=============\n"

cd $build_path

# We build GCC
echo -e "Building GCC-${gcc_version}...\n"

make -j${REZ_BUILD_THREAD_COUNT}

echo -e "\nFinished building GCC-${gcc_version}!\n"
