FROM alvrme/alpine-android:android-28-jdk11
LABEL maintainer="CLSource <camilo@ninjas.cl>"

# Install Rsync and ImageMagick helpers
RUN apk add --no-cache rsync imagemagick pngcrush optipng=0.7.7-r0

# Required for running utility scripts
RUN apk add --no-cache nodejs npm

# Install Additional Android SDK Versions
# RUN sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "build-tools;22.0.1" "platforms;android-22"
# RUN sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "build-tools;26.0.3" "platforms;android-26"
# RUN sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "build-tools;27.0.3" "platforms;android-27"

# Install Gradle
RUN wget "https://services.gradle.org/distributions/gradle-5.6.2-bin.zip" -P ${ANDROID_SDK_ROOT}/cmdline-tools/${CMDLINE_VERSION}

# Install https://github.com/ddimtirov/gwo-agent
# So gradle will be downloaded from local prefetched file
RUN wget https://jitpack.io/com/github/ddimtirov/gwo-agent/1.2.0/gwo-agent-1.2.0.jar -P ${ANDROID_SDK_ROOT}/cmdline-tools/${CMDLINE_VERSION}

ENV GRADLE_OPTS=-javaagent:${ANDROID_SDK_ROOT}/cmdline-tools/${CMDLINE_VERSION}/gwo-agent-1.2.0.jar=distributionUrl=file\://${ANDROID_SDK_ROOT}/cmdline-tools/${CMDLINE_VERSION}/gradle-5.6.2-bin.zip

# WORKDIR /home/android
