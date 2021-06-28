@echo off
rem Configurable
set TAG=jasonette-setup-docker
set KEYSTORE_NAME=jasonette.keystore
set KEYSTORE_ALIAS=upload

rem == ONLY IF YOU KNOW ==
rem Variables
set VERSION=1.0.0
set PWD="%cd%"
set DOCKER=docker run --rm -it --mount
set BUILDER=%DOCKER% type=bind,source=%PWD%,target=/home/android %TAG%

rem Gradle needs special directory as root to work
set GRADLE=%DOCKER% type=bind,source=%PWD%\jasonette\android,target=/home/android %TAG% ./gradlew

rem Curl needs special DNS settings
set CURL=%DOCKER% type=bind,source=%PWD%,target=/files curlimages/curl

rem Helper Commands
set CP=%BUILDER% cp
set MV=%BUILDER% mv
set KEYTOOL=%BUILDER% keytool
set SH=%BUILDER% /bin/sh -c
set UNZIP=%BUILDER% unzip -u
set REMOVE=%BUILDER% rm -rf
set MKDIR=%BUILDER% mkdir -p
set COPY=%BUILDER% cp
set MOVE=%BUILDER% mv
set RSYNC=%BUILDER% rsync
set IMAGICK=%BUILDER% convert
set KEYTOOL=%BUILDER% keytool
set NODE=%BUILDER% node
set NPM=%BUILDER% npm
set XCODE=%BUILDER% xcodeproj

rem Commands

set DOWNLOAD=%CURL% https://github.com/jasonelle/jasonette-android/archive/refs/heads/develop.zip -L -o /files/jasonette/android.zip
set UNARCHIVE=%SH% "cd ./jasonette && unzip ./android.zip && rm -rf ./android && mv ./jasonette-android-develop ./android && rm android.zip"

rem Runtime

%DOWNLOAD%
%UNARCHIVE%

