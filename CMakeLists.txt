cmake_minimum_required(VERSION 3.0)

include(RezBuild)
include(RezRepository)
include(ExternalProject)

set(gcc_version 6.3.1)
set(gmp_version 6.1.0)
set(mpfr_version 3.1.4)
set(mpc_version 1.0.3)
set(isl_version 0.18)
set(cloog_version 0.18.1)

# GCC
# It should be noted that trying to build GCC < 7.2 with glibc > 2.26 will generate two types of compilation errors,
# that can be alleviated by applying some patches to the code inside the GCC archive that will be used.
# As such, the burden of patching GCC is on the user, and not this script.
# The patches can be found at the following links:
# * https://github.com/easybuilders/easybuild-easyconfigs/blob/master/easybuild/easyconfigs/g/GCCcore/GCCcore-6.3.0_fix-linux-unwind-fix-ucontext.patch
# * https://github.com/easybuilders/easybuild-easyconfigs/blob/master/easybuild/easyconfigs/g/GCCcore/GCCcore-6.3.0_fix-sanitizer_linux.patch
rez_set_archive(
    gcc_url gcc/gcc-${gcc_version}.tar.bz2
    http://vault.centos.org/7.5.1804/sclo/Source/rh/devtoolset-6/devtoolset-6-gcc-6.3.1-3.1.el7.src.rpm
    # Or https://ftp.gnu.org/gnu/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2 is we want to use 6.3.0, since 6.3.1 is not directly available to download.
)
# GMP
rez_set_archive(
    gmp_url gmp/gmp-${gmp_version}.tar.bz2
    ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.1.0.tar.bz2
)
# MPFR
rez_set_archive(
    mpfr_url mpfr/mpfr-${mpfr_version}.tar.bz2
    ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-3.1.4.tar.bz2
)
# MPC
rez_set_archive(
    mpc_url mpc/mpc-${mpc_version}.tar.gz
    ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.0.3.tar.gz
)
# ISL
rez_set_archive(
    isl_url isl/isl-${isl_version}.tar.bz2
    ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2
)
# CLooG
rez_set_archive(
    cloog_url cloog/cloog-${cloog_version}.tar.gz
    ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz
)

# The environment variable REZ_TMP_PATH is meant to point to a location such as "/tmp/rez".
set(EXTRACT_DIR $ENV{REZ_TMP_PATH}/gcc/${gcc_version})
set(BUILD_DIR ${EXTRACT_DIR}/objdir)

# We configure/build/install GCC through the ExternalProject_Add macro,
# using three different shell scripts for each of these steps.
ExternalProject_Add(
    build_gcc
    URL ${gcc_url}
    PREFIX gcc
    SOURCE_DIR ${EXTRACT_DIR}
    CONFIGURE_COMMAND bash ${CMAKE_SOURCE_DIR}/configure.sh ${EXTRACT_DIR} ${CMAKE_INSTALL_PREFIX} ${gcc_version} ${gmp_version} ${mpfr_version} ${mpc_version} ${isl_version} ${cloog_version}
    BUILD_COMMAND bash ${CMAKE_SOURCE_DIR}/build.sh ${BUILD_DIR} ${gcc_version}
    INSTALL_COMMAND bash ${CMAKE_SOURCE_DIR}/install.sh ${BUILD_DIR} ${gcc_version}
)

# We use a bogus CMake "install" step in order to be able to properly finish
# and get out of the CMake script.
install(
    CODE
    "execute_process(
        COMMAND echo \"\n[CMAKE] GCC-${gcc_version} PACKAGE SETUP FINISHED!\n\"
    )"
)
