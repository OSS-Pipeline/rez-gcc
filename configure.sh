#!/usr/bin/bash

# Will exit the Bash script the moment any command will itself exit with a non-zero status, thus an error.
set -e

EXTRACT_PATH=$1
BUILD_PATH=$2
INSTALL_PATH=${REZ_BUILD_INSTALL_PATH}
GCC_VERSION=${REZ_BUILD_PROJECT_VERSION}
CLOOG_VERSION=$3
GMP_VERSION=$4
ISL_VERSION=$5
MPC_VERSION=$6
MPFR_VERSION=$7

echo -e "\n"
echo -e "================="
echo -e "=== CONFIGURE ==="
echo -e "================="
echo -e "\n"

# We print the arguments passed to the Bash script.
echo -e "[CONFIGURE][ARGS] EXTRACT PATH: ${EXTRACT_PATH}"
echo -e "[CONFIGURE][ARGS] BUILD PATH: ${BUILD_PATH}"
echo -e "[CONFIGURE][ARGS] INSTALL PATH: ${INSTALL_PATH}"
echo -e "[CONFIGURE][ARGS] GCC VERSION: ${GCC_VERSION}"
echo -e "[CONFIGURE][ARGS] CLOOG VERSION: ${CLOOG_VERSION}"
echo -e "[CONFIGURE][ARGS] GMP VERSION: ${GMP_VERSION}"
echo -e "[CONFIGURE][ARGS] ISL VERSION: ${ISL_VERSION}"
echo -e "[CONFIGURE][ARGS] MPC VERSION: ${MPC_VERSION}"
echo -e "[CONFIGURE][ARGS] MPFR VERSION: ${MPFR_VERSION}"
echo -e "[CONFIGURE][ARGS] REZ REPO PATH: ${REZ_REPO_PAYLOAD_DIR}"

# We check if the arguments variables we need are correctly set.
# If not, we abort the process.
if [[ -z ${EXTRACT_PATH} || -z ${BUILD_PATH} || -z ${INSTALL_PATH} || -z ${GCC_VERSION} || -z ${CLOOG_VERSION} || -z ${GMP_VERSION} || -z ${ISL_VERSION} || -z ${MPC_VERSION} || -z ${MPFR_VERSION} || -z ${REZ_REPO_PAYLOAD_DIR} ]]; then
    echo -e "\n"
    echo -e "[CONFIGURE][ARGS] One or more of the argument variables are empty. Aborting..."
    echo -e "\n"

    exit 1
fi

# We setup the paths of each archive we have to extract.
GMP_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/gmp/gmp-${GMP_VERSION}.tar.bz2
MPFR_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/mpfr/mpfr-${MPFR_VERSION}.tar.bz2
MPC_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/mpc/mpc-${MPC_VERSION}.tar.gz
ISL_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/isl/isl-${ISL_VERSION}.tar.bz2
CLOOG_ARCHIVE_PATH=${REZ_REPO_PAYLOAD_DIR}/cloog/cloog-${CLOOG_VERSION}.tar.gz

# We print the archives paths that we are going to extract next.
echo -e "\n"
echo -e "[CONFIGURE][ARCHIVES] GMP-${GMP_VERSION}: ${GMP_ARCHIVE_PATH}"
echo -e "[CONFIGURE][ARCHIVES] MPFR-${MPFR_VERSION}: ${MPFR_ARCHIVE_PATH}"
echo -e "[CONFIGURE][ARCHIVES] MPC-${MPC_VERSION}: ${MPC_ARCHIVE_PATH}"
echo -e "[CONFIGURE][ARCHIVES] ISL-${ISL_VERSION}: ${ISL_ARCHIVE_PATH}"
echo -e "[CONFIGURE][ARCHIVES] CLOOG-${CLOOG_VERSION}: ${CLOOG_ARCHIVE_PATH}"
echo -e "\n"

# CLooG
if [ ! -L cloog ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting CLooG-${CLOOG_VERSION} from ${CLOOG_ARCHIVE_PATH}..."

    tar -xzf ${CLOOG_ARCHIVE_PATH} --directory ${EXTRACT_PATH}
    ln -s ${EXTRACT_PATH}/cloog-${CLOOG_VERSION} ${EXTRACT_PATH}/cloog
fi
# GMP
if [ ! -L gmp ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting GMP-${GMP_VERSION} from ${GMP_ARCHIVE_PATH}..."

    tar -xjf ${GMP_ARCHIVE_PATH} --directory ${EXTRACT_PATH}
    ln -s ${EXTRACT_PATH}/gmp-${GMP_VERSION} ${EXTRACT_PATH}/gmp
    sed -e 's/M4=m4-not-needed/: # &/' -i ${EXTRACT_PATH}/gmp/configure
fi
# ISL
if [ ! -L isl ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting ISL-${ISL_VERSION} from ${ISL_ARCHIVE_PATH}..."

    tar -xjf ${ISL_ARCHIVE_PATH} --directory ${EXTRACT_PATH}
    ln -s ${EXTRACT_PATH}/isl-${ISL_VERSION} ${EXTRACT_PATH}/isl
fi
# MPC
if [ ! -L mpc ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting MPC-${MPC_VERSION} from ${MPC_ARCHIVE_PATH}..."

    tar -xzf ${MPC_ARCHIVE_PATH} --directory ${EXTRACT_PATH}
    ln -s ${EXTRACT_PATH}/mpc-${MPC_VERSION} ${EXTRACT_PATH}/mpc
fi
# MPFR
if [ ! -L mpfr ]; then
    echo -e "[CONFIGURE][EXTRACT] Extracting MPFR-${MPFR_VERSION} from ${MPFR_ARCHIVE_PATH}..."

    tar -xjf ${MPFR_ARCHIVE_PATH} --directory ${EXTRACT_PATH}
    ln -s ${EXTRACT_PATH}/mpfr-${MPFR_VERSION} ${EXTRACT_PATH}/mpfr
fi

# We run the configuration script of GCC.
echo -e "\n"
echo -e "[CONFIGURE] Running the configuration script from GCC-${GCC_VERSION}..."
echo -e "\n"

mkdir -p ${BUILD_PATH}
cd ${BUILD_PATH}

${EXTRACT_PATH}/configure \
    --prefix=${INSTALL_PATH} \
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
    --with-pic \
    --enable-languages=c,c++ \
    --disable-multilib \
    --disable-bootstrap \
    --enable-threads=posix

echo -e "\n"
echo -e "[CONFIGURE] Finished configuring GCC-${GCC_VERSION}!"
echo -e "\n"
