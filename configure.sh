#!/usr/bin/bash

echo "\n=== IN THE CONFIGURE SCRIPT ===\n"

extract_path=$1
build_path=$2
install_path=$3
gcc_version=$4
gmp_version=$5
mpfr_version=$6
mpc_version=$7
isl_version=$8
cloog_version=$9
rez_repo_path=$REZ_REPO_PAYLOAD_DIR

# We print the arguments passed to the Bash script
echo -e "\n=================="
echo -e "=== BUILD ARGS ==="
echo -e "==================\n"

echo -e "EXTRACT PATH: ${extract_path}"
echo -e "BUILD PATH: ${build_path}"
echo -e "INSTALL PATH: ${install_path}"
echo -e "GCC VERSION: ${gcc_version}"
echo -e "GMP VERSION: ${gmp_version}"
echo -e "MPFR VERSION: ${mpfr_version}"
echo -e "MPC VERSION: ${mpc_version}"
echo -e "ISL VERSION: ${isl_version}"
echo -e "CLOOG VERSION: ${cloog_version}"
echo -e "REZ REPO PATH: ${rez_repo_path}"

cd ${extract_path}

# We setup the paths of each archive we have to extract
gcc_archive_path=${rez_repo_path}/gcc/gcc-${gcc_version}.tar.bz2
gmp_archive_path=${rez_repo_path}/gmp/gmp-${gmp_version}.tar.bz2
mpfr_archive_path=${rez_repo_path}/mpfr/mpfr-${mpfr_version}.tar.bz2
mpc_archive_path=${rez_repo_path}/mpc/mpc-${mpc_version}.tar.gz
isl_archive_path=${rez_repo_path}/isl/isl-${isl_version}.tar.bz2
cloog_archive_path=${rez_repo_path}/cloog/cloog-${cloog_version}.tar.gz

echo -e "\n======================"
echo -e "=== ARCHIVES PATHS ==="
echo -e "======================\n"

echo -e "GCC-${gcc_version}: ${gcc_archive_path}"
echo -e "GMP-${gmp_version}: ${gmp_archive_path}"
echo -e "MPFR-${mpfr_version}: ${mpfr_archive_path}"
echo -e "MPC-${mpc_version}: ${mpc_archive_path}"
echo -e "ISL-${isl_version}: ${isl_archive_path}"
echo -e "CLOOG-${cloog_version}: ${cloog_archive_path}"

echo -e "\n==========================="
echo -e "=== ARCHIVES EXTRACTION ==="
echo -e "===========================\n"

# GMP
if [ ! -L gmp ]; then
    echo -e "Extracting GMP-${gmp_version} from ${gmp_archive_path}..."

    tar xjf ${gmp_archive_path}
    ln -s gmp-${gmp_version} gmp
    sed -e 's/M4=m4-not-needed/: # &/' -i gmp/configure
fi
# MPFR
if [ ! -L mpfr ]; then
    echo -e "Extracting MPFR-${mpfr_version} from ${mpfr_archive_path}..."

    tar xjf ${mpfr_archive_path}
    ln -s mpfr-${mpfr_version} mpfr
fi
# MPC
if [ ! -L mpc ]; then
    echo -e "Extracting MPC-${mpc_version} from ${mpc_archive_path}..."

    tar xzf ${mpc_archive_path}
    ln -s mpc-${mpc_version} mpc
fi
# ISL
if [ ! -L isl ]; then
    echo -e "Extracting ISL-${isl_version} from ${isl_archive_path}..."

    tar xjf ${isl_archive_path}
    ln -s isl-${isl_version} isl
fi
# CLooG
if [ ! -L cloog ]; then
    echo -e "Extracting CLooG-${cloog_version} from ${cloog_archive_path}..."

    tar xzf ${cloog_archive_path}
    ln -s cloog-${cloog_version} cloog
fi

echo -e "\n====================="
echo -e "=== CONFIGURATION ==="
echo -e "=====================\n"

# We run the configuration script of GCC
echo -e "Running the configuration script from GCC-${gcc_version}...\n"

if [ -d objdir ]; then
    cd objdir
else
    mkdir objdir
    cd objdir
    ../configure --prefix=${install_path} --enable-languages=c,c++ --with-pic --disable-shared --enable-static --enable-threads=posix --enable-__cxa_atexit --enable-clocale=gnu --with-libelf=/usr/include --disable-multilib --disable-bootstrap --disable-install-libiberty --with-system-zlib
fi

echo -e "\nFinished configuring GCC-${gcc_version}!\n"
