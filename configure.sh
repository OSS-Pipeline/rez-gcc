#!/usr/bin/bash

# Will exit the Bash script the moment any command will itself exit with a non-zero status, thus an error.
set -e

EXTRACT_PATH=$1
BUILD_PATH=$2
INSTALL_PATH=${REZ_BUILD_INSTALL_PATH}
GCC_VERSION=${REZ_BUILD_PROJECT_VERSION}
GMP_VERSION=$3
MPFR_VERSION=$4
MPC_VERSION=$5
ISL_VERSION=$6
CLOOG_VERSION=$7

echo -e "\n"
echo -e "================="
echo -e "=== CONFIGURE ==="
echo -e "================="
echo -e "\n"

# We print the arguments passed to the Bash script
echo -e "[CONFIGURE][ARGS] EXTRACT PATH: ${EXTRACT_PATH}"
echo -e "[CONFIGURE][ARGS] BUILD PATH: ${BUILD_PATH}"
echo -e "[CONFIGURE][ARGS] INSTALL PATH: ${INSTALL_PATH}"
echo -e "[CONFIGURE][ARGS] GCC VERSION: ${GCC_VERSION}"
echo -e "[CONFIGURE][ARGS] GMP VERSION: ${GMP_VERSION}"
echo -e "[CONFIGURE][ARGS] MPFR VERSION: ${MPFR_VERSION}"
echo -e "[CONFIGURE][ARGS] MPC VERSION: ${MPC_VERSION}"
echo -e "[CONFIGURE][ARGS] ISL VERSION: ${ISL_VERSION}"
echo -e "[CONFIGURE][ARGS] CLOOG VERSION: ${CLOOG_VERSION}"
echo -e "[CONFIGURE][ARGS] REZ REPO PATH: ${REZ_REPO_PAYLOAD_DIR}"

cd ${EXTRACT_PATH}

# We setup the paths of each archive we have to extract
GMP_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/gmp/gmp-${GMP_VERSION}.tar.bz2
MPFR_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/mpfr/mpfr-${MPFR_VERSION}.tar.bz2
MPC_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/mpc/mpc-${MPC_VERSION}.tar.gz
ISL_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/isl/isl-${ISL_VERSION}.tar.bz2
CLOOG_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/cloog/cloog-${CLOOG_VERSION}.tar.gz

# We print the archives paths that we are going to extract next
echo -e "\n"
echo -e "[CONFIGURE][ARCHIVES] GMP-${GMP_VERSION}: ${GMP_ARCHIVE_PATH}"
echo -e "[CONFIGURE][ARCHIVES] MPFR-${MPFR_VERSION}: ${MPFR_ARCHIVE_PATH}"
echo -e "[CONFIGURE][ARCHIVES] MPC-${MPC_VERSION}: ${MPC_ARCHIVE_PATH}"
echo -e "[CONFIGURE][ARCHIVES] ISL-${ISL_VERSION}: ${ISL_ARCHIVE_PATH}"
echo -e "[CONFIGURE][ARCHIVES] CLOOG-${CLOOG_VERSION}: ${CLOOG_ARCHIVE_PATH}"
echo -e "\n"

# GMP
if [ ! -L gmp ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting GMP-${GMP_VERSION} from ${GMP_ARCHIVE_PATH}..."

    tar xjf ${GMP_ARCHIVE_PATH}
    ln -s gmp-${GMP_VERSION} gmp
    sed -e 's/M4=m4-not-needed/: # &/' -i gmp/configure
fi
# MPFR
if [ ! -L mpfr ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting MPFR-${MPFR_VERSION} from ${MPFR_ARCHIVE_PATH}..."

    tar xjf ${MPFR_ARCHIVE_PATH}
    ln -s mpfr-${MPFR_VERSION} mpfr
fi
# MPC
if [ ! -L mpc ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting MPC-${MPC_VERSION} from ${MPC_ARCHIVE_PATH}..."

    tar xzf ${MPC_ARCHIVE_PATH}
    ln -s mpc-${MPC_VERSION} mpc
fi
# ISL
if [ ! -L isl ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting ISL-${ISL_VERSION} from ${ISL_ARCHIVE_PATH}..."

    tar xjf ${ISL_ARCHIVE_PATH}
    ln -s isl-${ISL_VERSION} isl
fi
# CLooG
if [ ! -L cloog ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting CLooG-${CLOOG_VERSION} from ${CLOOG_ARCHIVE_PATH}..."

    tar xzf ${CLOOG_ARCHIVE_PATH}
    ln -s cloog-${CLOOG_VERSION} cloog
fi

# We run the configuration script of GCC
echo -e "\n"
echo -e "[CONFIGURE] Running the configuration script from GCC-${GCC_VERSION}..."
echo -e "\n"

if [ -d ${BUILD_PATH} ]; then
    cd ${BUILD_PATH}
else
    mkdir -p ${BUILD_PATH}
    cd ${BUILD_PATH}

    .${EXTRACT_PATH}/configure --prefix=${INSTALL_PATH} --enable-languages=c,c++ --with-pic --disable-shared --enable-static --enable-threads=posix --enable-__cxa_atexit --enable-clocale=gnu --with-libelf=/usr/include --disable-multilib --disable-bootstrap --disable-install-libiberty --with-system-zlib
fi

echo -e "\n"
echo -e "[CONFIGURE] Finished configuring GCC-${GCC_VERSION}!"
echo -e "\n"
