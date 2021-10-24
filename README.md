# intellij-idea-ce-foss-build

This is a script that automatically build IntelliJ IDEA Community Edition, it includes some modifications from https://github.com/archlinux/svntogit-community/blob/packages/intellij-idea-community-edition/trunk

# Motivation

IntelliJ IDEA Community Edition a popular IDE for JVM, however the official binaries might include some proprietary plugins, and Jetbrains saying the official IntelliJ IDEA Community Edition is "Free, built on open source" instead of "Free, open-source".

This build uses the modifications/patches from ```intellij-idea-community-edition``` in the repo of Arch Linux, and make it available to all amd64 architecture GNU/Linux distros.

# Usage

Execute [intellij-idea-build.sh](intellij-idea-build.sh)
The resulting binaries can be found in out/idea-ce/artifacts.

## Dependencies
OpenJDK version 11,  ```ant``` and ```git```.

# License

The binaries are licensed under Apache License, Version 2.0.
The build script is licensed under GNU General Public License Version 3.
