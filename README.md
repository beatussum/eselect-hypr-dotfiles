# `eselect-hypr-dotfiles`

[![License](https://img.shields.io/github/license/beatussum/eselect-hypr-dotfiles)](LICENSE)
[![Release](https://img.shields.io/github/v/release/beatussum/eselect-hypr-dotfiles)](https://github.com/beatussum/eselect-hypr-dotfiles/releases/)

[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/beatussum/eselect-hypr-dotfiles/run-tests.yml)](https://github.com/beatussum/eselect-hypr-dotfiles/actions/workflows/run-tests.yml/)
[![codecov](https://codecov.io/gh/beatussum/eselect-hypr-dotfiles/graph/badge.svg)](https://codecov.io/gh/beatussum/eselect-hypr-dotfiles/)

## Table of contents

- [What is `eselect-hypr-dotfiles`?](#what-is-eselect-hypr-dotfiles)
- [Licenses](#licenses)

- [Building](#building)
    - [Dependencies](#dependencies)
    - [Building process](#building-process)

## What is `eselect-hypr-dotfiles`?

[**`eselect-hypr-dotfiles`**](https://github.com/beatussum/eselect-hypr-dotfiles/) is [an `eselect`](https://wiki.gentoo.org/wiki/Project:Eselect) module for managing [Hyprland](https://hyprland.org/) dotfiles (licensed under GPL-3 or any later version).

## Building

### Dependencies

- `dev-util/kcov`: only needed for coverage.
- `dev-util/shellspec`[^1]: only needed for testing and coverage.
- `dev-vcs/git`: only needed for building.

All other dependencies are already included in **@system**.

### Building process

1. Clone the repository.

    ```sh
    git clone "https://github.com/beatussum/eselect-hypr-dotfiles.git"
    ```

1. Change directory.

    ```sh
    cd eselect-hypr-dotfiles
    ```

1. **(optional)** Test the program.

    ```sh
    make test
    ```

    The JUnit report file is at `build/report/results_junit.xml`.

1. **(optional)** Compute code coverage.

    ```sh
    make coverage
    ```

    The output files are in `build/coverage/`.

1. Install the program.

    ```sh
    sudo make DESTDIR=<DESTDIR> PREFIX=<PREFIX> install
    ```

## Licenses

As explained above, the code of this software is licensed under GPL-3 or any later version. Details of the rights applying to the various third-party files are described in the [copyright](copyright) file in [the Debian `debian/copyright` file format](https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/).

[^1]: You can emerge this package by using [my personnal overlay](https://github.com/beatussum/hyprland-overlay/).
