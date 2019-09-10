#!/usr/bin/bash

extract_path=$1
install_path=$2
gcc_version=$3
gmp_version=$4
mpfr_version=$5
mpc_version=$6
isl_version=$7
cloog_version=$8

echo -e "\n"
echo -e "================="
echo -e "=== CONFIGURE ==="
echo -e "================="
echo -e "\n"

# We print the arguments passed to the Bash script
echo -e "[CONFIGURE][ARGS] EXTRACT PATH: ${extract_path}"
echo -e "[CONFIGURE][ARGS] INSTALL PATH: ${install_path}"
echo -e "[CONFIGURE][ARGS] GCC VERSION: ${gcc_version}"
echo -e "[CONFIGURE][ARGS] GMP VERSION: ${gmp_version}"
echo -e "[CONFIGURE][ARGS] MPFR VERSION: ${mpfr_version}"
echo -e "[CONFIGURE][ARGS] MPC VERSION: ${mpc_version}"
echo -e "[CONFIGURE][ARGS] ISL VERSION: ${isl_version}"
echo -e "[CONFIGURE][ARGS] CLOOG VERSION: ${cloog_version}"
echo -e "[CONFIGURE][ARGS] REZ REPO PATH: ${REZ_REPO_PAYLOAD_DIR}"

cd ${extract_path}

# We setup the paths of each archive we have to extract
gcc_archive_path=${REZ_REPO_PAYLOAD_DIR}/gcc/gcc-${gcc_version}.tar.bz2
gmp_archive_path=${REZ_REPO_PAYLOAD_DIR}/gmp/gmp-${gmp_version}.tar.bz2
mpfr_archive_path=${REZ_REPO_PAYLOAD_DIR}/mpfr/mpfr-${mpfr_version}.tar.bz2
mpc_archive_path=${REZ_REPO_PAYLOAD_DIR}/mpc/mpc-${mpc_version}.tar.gz
isl_archive_path=${REZ_REPO_PAYLOAD_DIR}/isl/isl-${isl_version}.tar.bz2
cloog_archive_path=${REZ_REPO_PAYLOAD_DIR}/cloog/cloog-${cloog_version}.tar.gz

# We print the archives paths that we are going to extract next
echo -e "\n"
echo -e "[CONFIGURE][ARCHIVES] GCC-${gcc_version}: ${gcc_archive_path}"
echo -e "[CONFIGURE][ARCHIVES] GMP-${gmp_version}: ${gmp_archive_path}"
echo -e "[CONFIGURE][ARCHIVES] MPFR-${mpfr_version}: ${mpfr_archive_path}"
echo -e "[CONFIGURE][ARCHIVES] MPC-${mpc_version}: ${mpc_archive_path}"
echo -e "[CONFIGURE][ARCHIVES] ISL-${isl_version}: ${isl_archive_path}"
echo -e "[CONFIGURE][ARCHIVES] CLOOG-${cloog_version}: ${cloog_archive_path}"
echo -e "\n"

# GMP
if [ ! -L gmp ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting GMP-${gmp_version} from ${gmp_archive_path}..."

    tar xjf ${gmp_archive_path}
    ln -s gmp-${gmp_version} gmp
    sed -e 's/M4=m4-not-needed/: # &/' -i gmp/configure
fi
# MPFR
if [ ! -L mpfr ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting MPFR-${mpfr_version} from ${mpfr_archive_path}..."

    tar xjf ${mpfr_archive_path}
    ln -s mpfr-${mpfr_version} mpfr
fi
# MPC
if [ ! -L mpc ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting MPC-${mpc_version} from ${mpc_archive_path}..."

    tar xzf ${mpc_archive_path}
    ln -s mpc-${mpc_version} mpc
fi
# ISL
if [ ! -L isl ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting ISL-${isl_version} from ${isl_archive_path}..."

    tar xjf ${isl_archive_path}
    ln -s isl-${isl_version} isl
fi
# CLooG
if [ ! -L cloog ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting CLooG-${cloog_version} from ${cloog_archive_path}..."

    tar xzf ${cloog_archive_path}
    ln -s cloog-${cloog_version} cloog
fi

# We run the configuration script of GCC
echo -e "\n"
echo -e "[CONFIGURE] Running the configuration script from GCC-${gcc_version}..."
echo -e "\n"

if [ -d objdir ]; then
    cd objdir
else
    mkdir objdir
    cd objdir

    ../configure --prefix=${install_path} --enable-languages=c,c++ --with-pic --disable-shared --enable-static --enable-threads=posix --enable-__cxa_atexit --enable-clocale=gnu --with-libelf=/usr/include --disable-multilib --disable-bootstrap --disable-install-libiberty --with-system-zlib
fi

echo -e "\n"
echo -e "[CONFIGURE] Finished configuring GCC-${gcc_version}!"
echo -e "\n"
