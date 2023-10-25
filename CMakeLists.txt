cmake_minimum_required(VERSION 3.0)

include(RezBuild)
include(RezRepository)
include(ExternalProject)

set(CLOOG_VERSION 0.21.1)
set(GMP_VERSION 6.3.0)
set(ISL_VERSION 0.26)
set(MPC_VERSION 1.3.1)
set(MPFR_VERSION 4.2.1)

# GCC
rez_set_archive(
    GCC_URL gcc/gcc-${REZ_BUILD_PROJECT_VERSION}.tar.gz
    https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz
)

# Additional dependencies to properly build GCC.
# CLooG
rez_set_archive(
    cloog_url cloog/cloog-${CLOOG_VERSION}.tar.gz
    https://github.com/periscop/cloog/releases/download/cloog-${CLOOG_VERSION}/cloog-${CLOOG_VERSION}.tar.gz
)
# GMP
rez_set_archive(
    gmp_url gmp/gmp-${GMP_VERSION}.tar.bz2
    https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VERSION}.tar.bz2
)
# ISL
rez_set_archive(
    isl_url isl/isl-${ISL_VERSION}.tar.bz2
    https://libisl.sourceforge.io/isl-${ISL_VERSION}.tar.bz2
)
# MPC
rez_set_archive(
    mpc_url mpc/mpc-${MPC_VERSION}.tar.gz
    https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VERSION}.tar.gz
)
# MPFR
rez_set_archive(
    mpfr_url mpfr/mpfr-${MPFR_VERSION}.tar.bz2
    ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-${MPFR_VERSION}.tar.bz2
)

# The environment variable REZ_TMP_PATH is meant to point to a location such as "/tmp/rez".
set(EXTRACT_DIR $ENV{REZ_TMP_PATH}/gcc/${REZ_BUILD_PROJECT_VERSION})
set(BUILD_DIR ${EXTRACT_DIR}/build/objdir)

# We configure/build/install GCC through the ExternalProject_Add macro,
# using three different shell scripts for each of these steps.
# If necessary, it is possible to skip one of these steps by replacing the command
# by "", an empty string.
ExternalProject_Add(
    REZ_GCC
    URL ${GCC_URL}
    PREFIX gcc
    SOURCE_DIR ${EXTRACT_DIR}
    PATCH_COMMAND ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND bash ${CMAKE_SOURCE_DIR}/configure.sh ${EXTRACT_DIR} ${BUILD_DIR} ${CLOOG_VERSION} ${GMP_VERSION} ${ISL_VERSION} ${MPC_VERSION} ${MPFR_VERSION}
    BUILD_COMMAND bash ${CMAKE_SOURCE_DIR}/build.sh ${BUILD_DIR}
    INSTALL_COMMAND bash ${CMAKE_SOURCE_DIR}/install.sh ${BUILD_DIR}
)

# We use a bogus CMake "install" step in order to be able to properly finish
# and get out of the CMake script.
install(
    CODE
    "execute_process(
        COMMAND echo \"\n[CMAKE] GCC-${REZ_BUILD_PROJECT_VERSION} PACKAGE SETUP FINISHED!\n\"
    )"
)
