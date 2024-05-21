#! /usr/bin/env python3

import argparse
from os import path, mkdir, chdir, system

ROOT_BASE_DIR = path.expanduser("~/cern/root")
DEFAULT_BUILD_OPTS = {
    "ccache": "on",
    "root7": "on",
    "uring": "on",
    "roofit": "off",
    "tmva": "off",
    "clad": "off",
    "sqlite": "off",
    "xml": "off",
    "spectrum": "off",
    "gdml": "off",
    "proof": "off",
    "mathmore": "on",
}


def format_build_opts(build_opts):
    return [f"{opt}={setting}" for opt, setting in build_opts.items()]


def parse_build_opts(build_opts):
    return dict([opt.split("=") for opt in build_opts])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="configrootbuild",
        description="Configure CMake for building ROOT",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument(
        "-t",
        "--build-type",
        help="CMake build type",
        choices=["Debug", "Release", "RelWithDebInfo", "MinSizeRel"],
        default="RelWithDebInfo",
    )

    parser.add_argument(
        "--testing",
        help="enable tests",
        action="store_const",
        default="off",
        const="on",
    )

    parser.add_argument(
        "-s",
        "--source-dir",
        help="source directory",
        default=f"{ROOT_BASE_DIR}/src",
    )

    parser.add_argument(
        "-b",
        "--build-dir",
        help="build directory",
        default=f"{ROOT_BASE_DIR}/build",
    )

    parser.add_argument(
        "-i",
        "--install-dir",
        help="install directory",
        default=f"{ROOT_BASE_DIR}/install",
    )

    parser.add_argument(
        "-o",
        "--build-opts",
        help="CMAKE build options. Should be provided in the format OPT=(on|off). "
        "Providing additional build options this way will update the default ones, "
        "rather than completely overriding them.",
        default=format_build_opts(DEFAULT_BUILD_OPTS),
        metavar="OPTS",
        nargs="*",
    )

    parser.add_argument(
        "-n",
        "--dry-run",
        help="print the CMake command but do not execute it",
        action="store_true",
        default=False,
    )

    args = parser.parse_args()

    build_opt_string = " ".join(
        f"-D{opt}"
        for opt in format_build_opts(
            DEFAULT_BUILD_OPTS | parse_build_opts(args.build_opts)
        )
    )

    cmake_string = f"cmake -G Ninja -DCMAKE_BUILD_TYPE={args.build_type} -DCMAKE_INSTALL_PREFIX={args.install_dir} {build_opt_string} -Dtesting={args.testing} {args.source_dir}"

    print(f'Configuring CMake in "{args.build_dir}"')
    print(cmake_string)
    if not args.dry_run:
        if not path.isdir(args.build_dir):
            mkdir(args.build_dir)

        if not path.isdir(args.install_dir):
            mkdir(args.install_dir)

        if not path.isdir(args.source_dir):
            raise NotADirectoryError(
                f'provided source directory "{args.source_dir}" not found'
            )

        chdir(args.build_dir)
        system(cmake_string)
