#!/bin/bash

intellij_idea_version=$(cat idea_ver)

# Download IntelliJ IDEA and Android plugin(required for building IntelliJ IDEA)

wget https://github.com/JetBrains/intellij-community/archive/refs/tags/idea/$intellij_idea_version.tar.gz -O intellij-idea-source.tar.gz
git clone --depth 1 --branch idea/$intellij_idea_version git://git.jetbrains.org/idea/android.git

# Extract files

tar -xf intellij-idea-source.tar.gz
rm -rf android/.git/
find android/ -type f -exec sha256sum {} + | awk '{print $1}' | sort | sha256sum | awk '{print $1}' > checksum_bv
if [[ $(cat checksum_bv) == $(cat checksum_android) ]]
then
  echo "Android plugin checksum verification completed"
  echo "Checksum is $(cat checksum_bv)"
  mv android intellij-community-idea-$intellij_idea_version

  # Some needed modifications

  cd intellij-community-idea-$intellij_idea_version

  # https://youtrack.jetbrains.com/issue/IDEA-276102
  # https://youtrack.jetbrains.com/issue/IDEA-277775
  patch -p0 -i ../skip_jps_build.patch

  echo $intellij_idea_version > build.txt

  # Build

  ./installers.cmd -Dintellij.build.target.os=linux

  # Clean up
  cd ..
  rm intellij-idea-source.tar.gz
  rm checksum_bv

else
  echo "Downloaded Android plugin maybe corrupted."

  # Clean up
  rm intellij-idea-source.tar.gz
  rm checksum_bv
fi
