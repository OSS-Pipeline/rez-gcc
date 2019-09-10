#!/usr/bin/bash

build_path=$1
gcc_version=$2

# We print the arguments passed to the Bash script
echo -e "\n============="
echo -e "=== BUILD ==="
echo -e "=============\n"

echo -e "BUILD PATH: ${build_path}\n"
echo -e "GCC VERSION: ${gcc_version}"

cd $build_path

# We build GCC
echo -e "Building GCC-${gcc_version}...\n"

make -j${REZ_BUILD_THREAD_COUNT}

echo -e "\nFinished building GCC-${gcc_version}!\n"
