# Based and improved from https://github.com/piratecrew/rez-gcc

name = "gcc"

version = "11.2.0"

description = """
    The GNU Compiler Collection (GCC) is a compiler system produced by the GNU Project
    supporting various programming languages.
    GCC is a key component of the GNU toolchain and the standard compiler for most projects
    related to GNU and Linux, including the Linux kernel.
    """

authors = ["GNU"]

tools = [
    "gcc",
    "g++",
    "c++",
    "cpp",
    "gcc-ar",
    "gcc-ranlib",
    "gfortran",
    "gcc-nm",
    "gcov",
]

requires = [
    "cmake-3",
]

variants = [
    [
        "platform-linux",
    ],
]

build_system = "cmake"


with scope("config") as config:
    config.build_thread_count = "logical_cores"


def commands():
    env.PATH.prepend("{root}/bin")
    env.CC.prepend("{root}/bin/gcc")
    env.CXX.prepend("{root}/bin/g++")
    env.LD_LIBRARY_PATH.prepend(
        "{root}/lib64:{root}/lib/gcc/x86_64-pc-linux-gnu/{version}"
    )

    # Helper environment variables.
    env.GCC_BINARY_PATH.set("{root}/bin")
    env.GCC_INCLUDE_PATH.set("{root}/include")
    env.GCC_LIBRARY_PATH.set(
        "{root}/lib64:{root}/lib/gcc/x86_64-pc-linux-gnu/{version}"
    )
