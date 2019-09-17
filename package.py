
# Based and improved from https://github.com/piratecrew/rez-gcc

name = "gcc"

version = "6.3.1"

authors = [
    "GNU"
]

description = \
    """
    The GNU Compiler Collection (GCC) is a compiler system produced by the GNU Project
    supporting various programming languages.
    GCC is a key component of the GNU toolchain and the standard compiler for most projects
    related to GNU and Linux, including the Linux kernel.
    """

variants = [
    ["platform-linux"]
]

tools = [
    "gcc",
    "g++",
    "c++",
    "cpp",
    "gcc-ar",
    "gcc-ranlib",
    "gfortran",
    "gcc-nm",
    "gcov"
]

build_system = "cmake"

with scope("config") as config:
    config.build_thread_count = "logical_cores"

# TODO: Use the SHA1 of the archive instead.
uuid = "gcc-6.3.1"

def commands():
    env.PATH.append("{root}/bin")
    env.CC.append("{root}/bin/gcc")
    env.CXX.append("{root}/bin/g++")
    env.LD_LIBRARY_PATH.append("{root}/lib64:{root}/lib/gcc/x86_64-pc-linux-gnu/6.3.1")
    env.GCC_ROOT.append("{root}")
