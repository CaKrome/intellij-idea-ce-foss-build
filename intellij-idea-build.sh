#!/bin/bash

intellij_idea_version=221.5080.210

# Download IntelliJ IDEA and Android plugin(required for building IntelliJ IDEA)

wget https://github.com/JetBrains/intellij-community/archive/refs/tags/idea/$intellij_idea_version.tar.gz -O intellij-idea-source.tar.gz
git clone --depth 1 --branch idea/$intellij_idea_version git://git.jetbrains.org/idea/android.git

# Extract files

tar -xf intellij-idea-source.tar.gz
rm -rf android/.git/
tar -C android/ -cf - --sort=name android/ --mtime='UTC 2022-01-01' --group=0 --owner=0 --numeric-owner | sha256sum | awk '{print $1}' > checksum_android
if [[ $(cat checksum_android) == "5b683ef8a80678a404b95a50148897e544c52d173cb017d0c8667c14b70df94f" ]]
then
  echo "Android plugin checksum verification completed"
  echo "Checksum is $(cat checksum_android)"
  mv android intellij-community-idea-$intellij_idea_version

  # Some needed modifications

  cd intellij-community-idea-$intellij_idea_version

  # https://youtrack.jetbrains.com/issue/IDEA-276102
  # https://youtrack.jetbrains.com/issue/IDEA-277775
  patch -p0 -i ../skip_jps_build.patch

  echo $intellij_idea_version > build.txt

  # Build

  ./installers.cmd -Dintellij.build.target.os=linux

else
  echo "Downloaded Android plugin maybe corrupted."
fi

# Clean up
cd ..
rm intellij-idea-source.tar.gz
rm checksum_android
