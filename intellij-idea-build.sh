#!/bin/bash

intellij_idea_version=211.7628.21
android_plugin_version=211.7442.27

# Download IntelliJ IDEA and Android plugin(required for building IntelliJ IDEA)

wget https://github.com/JetBrains/intellij-community/archive/refs/tags/idea/211.7628.21.tar.gz -O intellij-idea-source.tar.gz
wget https://github.com/JetBrains/android/archive/refs/tags/idea/211.7442.27.tar.gz -O android-intellij-idea-source.tar.gz

# Extract files

tar -xvf intellij-idea-source.tar.gz
tar -xvf android-intellij-idea-source.tar.gz
mv android-idea-$android_plugin_version android
mv android intellij-community-idea-$intellij_idea_version

# Some needed modifications

cd intellij-community-idea-$intellij_idea_version

sed '/def targetOs =/c def targetOs = "linux"' -i build/dependencies/setupJbre.gradle
sed '/String targetOS/c   String targetOS = OS_LINUX' -i platform/build-scripts/groovy/org/jetbrains/intellij/build/BuildOptions.groovy
sed -E 's|(<sysproperty key="jna.nosys")|<sysproperty key="intellij.build.target.os" value="linux" />\1|' -i build.xml
sed -E 's/-Xmx[0-9]+m/-XX:-UseGCOverheadLimit/' -i build.xml
echo $intellij_idea_version > build.txt

# Build

ant build

# Clean up

cd ..
rm intellij-idea-source.tar.gz
rm android-intellij-idea-source.tar.gz