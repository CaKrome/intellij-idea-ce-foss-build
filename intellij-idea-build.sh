#!/bin/bash

intellij_idea_version=212.5284.40

# Download IntelliJ IDEA and Android plugin(required for building IntelliJ IDEA)

wget https://github.com/JetBrains/intellij-community/archive/refs/tags/idea/212.5284.40.tar.gz -O intellij-idea-source.tar.gz
git clone --depth 1 --branch idea/212.5284.40 git://git.jetbrains.org/idea/android.git

# Extract files

tar -xvf intellij-idea-source.tar.gz
mv android intellij-community-idea-$intellij_idea_version

# Some needed modifications

cd intellij-community-idea-$intellij_idea_version

# https://youtrack.jetbrains.com/issue/KTIJ-19348
patch -p0 -i ../kotlin_dist_for_ide.patch

# https://youtrack.jetbrains.com/issue/IDEA-276102
# https://youtrack.jetbrains.com/issue/IDEA-277775
patch -p0 -i ../skip_jps_build.patch

sed '/def targetOs =/c def targetOs = "linux"' -i build/dependencies/setupJbre.gradle
sed '/String targetOS/c   String targetOS = OS_LINUX' -i platform/build-scripts/groovy/org/jetbrains/intellij/build/BuildOptions.groovy
sed -E 's|(<sysproperty key="jna.nosys")|<sysproperty key="intellij.build.target.os" value="linux" />\1|' -i build.xml
sed -E 's/-Xmx[0-9]+m/-XX:-UseGCOverheadLimit -Didea.home.path=/' -i build.xml
echo $intellij_idea_version > build.txt

# Build

ant -Dintellij.build.target.os=linux build

# Clean up

cd ..
rm intellij-idea-source.tar.gz
