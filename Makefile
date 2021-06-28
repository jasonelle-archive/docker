# Tested on Docker v20.10.0
.PHONY: install docs zip fa da bad bar caf ki

VERSION=1.0.0
TAG=jasonette-setup-docker
KEYSTORE_NAME=jasonette.keystore
KEYSTORE_ALIAS=upload

# Helper Commands
DOCKER=docker run --rm -it --mount
CURL=${DOCKER} type=bind,source="${PWD}",target=/files curlimages/curl
GRADLE=${DOCKER} type=bind,source="${PWD}/jasonette/android",target=/home/android ${TAG} ./gradlew
BUILDER=${DOCKER} type=bind,source="${PWD}",target=/home/android ${TAG}

# Exec inside Builder docker
## Common Utilities
UNZIP=${BUILDER} unzip -u
RM=${BUILDER} rm -rf
MKDIR=${BUILDER} mkdir -p
COPY=${BUILDER} cp
MOVE=${BUILDER} mv

## Special Programs
KEYTOOL=${BUILDER} keytool
RSYNC=${BUILDER} rsync
SH=${BUILDER} /bin/sh -c

# Make Commands

## Installation Command
##> Use this command to install all the dependencies of Docker and Jasonelle
##> $ make install
i install:
	@echo
	@echo " ╦┌─┐┌─┐┌─┐┌┐┌┌─┐┬  ┬  ┌─┐"
	@echo " ║├─┤└─┐│ ││││├┤ │  │  ├┤ "
	@echo "╚╝┴ ┴└─┘└─┘┘└┘└─┘┴─┘┴─┘└─┘"
	@echo " Android Setup Tool v${VERSION}"
	@echo
	docker build -t ${TAG} .

## Download Android
##> Use this command to download the latest develop version.
##> $ make fa
fa fetch-android fetch-android-develop:
	${CURL} https://github.com/jasonelle/jasonette-android/archive/refs/heads/develop.zip -L -o /files/jasonette/android.zip

##> Download and unzip the directory
##> Danger: It will delete the jasonette/android directory if present
##> $ make da
da dad download-android download-android-develop:
	make fetch-android-develop
	${SH} "cd ./jasonette && unzip ./android.zip && rm -rf ./android && mv ./jasonette-android-develop ./android && rm android.zip"

## Copy Android Files
##> Use this command to copy files inside app/file and app/settings/android to jasonette/android
##> $ make caf
caf copy-android-files:
	${RSYNC} -av ./app/file/ ./jasonette/android/app/src/main/assets/file
	${SH} "cp ./app/settings/android/AndroidManifest.xml ./jasonette/android/app/src/main && cp ./app/settings/android/strings.xml ./jasonette/android/app/src/main/res/values && cp ./app/settings/android/build.gradle ./jasonette/android/app"

## Create Android Keystore
##> Use this command to create a new file *.keystore that will be stored inside app/keys
##> This file is needed to build a release APK and sign in.
##> $ make ki
ki key-install-android:
	${KEYTOOL} -genkey -v -keystore ${KEYSTORE_NAME} -alias ${KEYSTORE_ALIAS} -keyalg RSA -keysize 2048 -validity 9125
	${COPY} ./${KEYSTORE_NAME} ./jasonette/android/app
	${MOVE} ./${KEYSTORE_NAME} ./app/keys/${KEYSTORE_NAME}

## Build Android APK in Debug Mode
##> Use this command to create an APK in debug mode.
##> It will copy files inside app/file app/settings/android.
##> The APK will be copied to build/ directory.
##> $ make bad
bad build-android-debug:
	make copy-android-files
	${GRADLE} assembleDebug --warning-mode=all --stacktrace -PdisablePreDex
	${COPY} ./jasonette/android/app/build/outputs/apk/debug/app-debug.apk ./app/build/

## Build Android APK in Release Mode
##> Use this command to create an APK in release mode.
##> It will copy files inside app/file app/settings/android.
##> Also it will copy the keystore file.
##> Make sure your build.gradle file is configured with the keystore file.
##> The APK will be copied to build/ directory.
##> $ make bar
bar build-android-release:
	@echo "Make sure to configure build.gradle and include ${KEYSTORE_NAME} in the build settings"
	make copy-android-files
	${COPY} ./app/keys/${KEYSTORE_NAME} ./jasonette/android/app
	${GRADLE} assembleRelease --warning-mode=all --stacktrace -PdisablePreDex
	${COPY} ./jasonette/android/app/build/outputs/apk/release/app-release.apk ./app/build/

# Dev Commands
docs:
	@cp README.adoc ./docs && cd docs && asciidoctor README.adoc && asciidoctor-pdf README.adoc && mv README.html index.html && rm README.adoc

zip:
	@mkdir -p ./dist
	@git archive --format zip --output ./dist/jasonelle-android-docker-tool-${VERSION}.zip main
	@echo "./dist/jasonelle-android-docker-tool-${VERSION}.zip created"
