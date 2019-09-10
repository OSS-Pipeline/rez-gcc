#!/usr/bin/bash

echo "\n=== IN THE INSTALL SCRIPT ===\n"

build_path=$1
gcc_version=$2

echo -e "\n==============="
echo -e "=== INSTALL ==="
echo -e "===============\n"

cd $build_path

# We finally install GCC
echo -e "Installing GCC-${gcc_version}...\n"

make install

echo -e "\nFinished installing GCC-${gcc_version}!\n"
