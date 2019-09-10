#!/usr/bin/bash

build_path=$1
gcc_version=$2

# We print the arguments passed to the Bash script
echo -e "\n"
echo -e "==============="
echo -e "=== INSTALL ==="
echo -e "==============="
echo -e "\n"

echo -e "[INSTALL][ARGS] BUILD PATH: ${build_path}"
echo -e "[INSTALL][ARGS] GCC VERSION: ${gcc_version}"

cd $build_path

# We finally install GCC
echo -e "\n"
echo -e "[INSTALL] Installing GCC-${gcc_version}..."
echo -e "\n"

make install

echo -e "\n"
echo -e "[INSTALL] Finished installing GCC-${gcc_version}!"
echo -e "\n"
