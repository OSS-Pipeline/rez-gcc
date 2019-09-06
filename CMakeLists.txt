# Based and improved from https://github.com/piratecrew/rez-gcc

cmake_minimum_required(VERSION 3.0)

include(RezBuild)
include(RezRepository)
include(ExternalProject)

set(mpc_version 1.1.0)
set(mpfr_version 4.0.2)
set(gmp_version 6.1.2)
set(isl_version 0.21.0)
set(cloog_version 0.20.0)
set(gcc_version 6.3.1)

# GCC
rez_set_archive(
    url_gcc gcc/gcc-${gcc_version}.tar.bz2
    $ENV{REZ_REPO_PAYLOAD_DIR}/gcc/gcc-${gcc_version}.tar.bz2
)
# GMP
rez_set_archive(
    url_gmp gmp/gmp-${gmp_version}.tar.bz2
    $ENV{REZ_REPO_PAYLOAD_DIR}/gmp/gmp-${gmp_version}.tar.bz2
)
# MPFR
rez_set_archive(
    url_mpfr mpfr/mpfr-${mpfr_version}.tar.bz2
    $ENV{REZ_REPO_PAYLOAD_DIR}/mpfr/mpfr-${mpfr_version}.tar.bz2
)
# MPC
rez_set_archive(
    url_mpc mpc/mpc-${mpc_version}.tar.gz
    $ENV{REZ_REPO_PAYLOAD_DIR}/mpc/mpc-${mpc_version}.tar.bz
)
# ISL
rez_set_archive(
    url_isl isl/isl-${isl_version}.tar.bz2
    $ENV{REZ_REPO_PAYLOAD_DIR}/isl/isl-${isl_version}.tar.bz2
)
# CLooG
rez_set_archive(
    url_cloog cloog/cloog-${cloog_version}.tar.gz
    $ENV{REZ_REPO_PAYLOAD_DIR}/cloog/cloog-${cloog_version}.tar.bz
)

add_custom_target(
    build_gcc
    ALL
    COMMAND bash ./build.sh ${CMAKE_BINARY_DIR} ${CMAKE_INSTALL_PREFIX} $ENV{REZ_REPO_PAYLOAD_DIR} ${gcc_version} ${gmp_version} ${mpfr_version} ${mpc_version} ${isl_version} ${cloog_version}
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    VERBATIM
)

install(
    CODE
    "execute_process(
        COMMAND make install
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/objdir
    )"
)
