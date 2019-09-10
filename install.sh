#!/usr/bin/bash

build_path=$1
gcc_version=$2

# We print the arguments passed to the Bash script
echo -e "\n==============="
echo -e "=== INSTALL ==="
echo -e "===============\n"

echo -e "BUILD PATH: ${build_path}\n"
echo -e "GCC VERSION: ${gcc_version}"

cd $build_path

# We finally install GCC
echo -e "Installing GCC-${gcc_version}...\n"

make install

echo -e "\nFinished installing GCC-${gcc_version}!\n"
