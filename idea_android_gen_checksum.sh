#!/bin/bash

idea_version=221.5080.210

mkdir workspace
cd workspace

git clone --depth 1 --branch idea/$idea_version git://git.jetbrains.org/idea/android.git
rm -rf android/.git/
find android/ -type f -exec sha256sum {} \; | sort -k 2 | sha256sum | awk '{print $1}' > checksum_1
rm -rf android/

git clone --depth 1 --branch idea/$idea_version git://git.jetbrains.org/idea/android.git
rm -rf android/.git/
find android/ -type f -exec sha256sum {} \; | sort -k 2 | sha256sum | awk '{print $1}' > checksum_2
rm -rf android/

git clone --depth 1 --branch idea/$idea_version git://git.jetbrains.org/idea/android.git
rm -rf android/.git/
find android/ -type f -exec sha256sum {} \; | sort -k 2 | sha256sum | awk '{print $1}' > checksum_3
rm -rf android/

if [[ $(cat checksum_1) == $(cat checksum_2) ]] && [[ $(cat checksum_2) == $(cat checksum_2) ]]
then
  echo "The checksum is $(cat checksum_1)"
else
  echo "Something might went wrong."
fi

cd ..
rm -rf workspace
