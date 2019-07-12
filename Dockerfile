FROM openjdk:8-jdk

RUN apt-get update \
 && apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

# Set up environment variables
ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"

RUN mkdir -p /opt/mobile-app
WORKDIR /opt/mobile-app

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
 && cd "$ANDROID_HOME" \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

ENV ANDROID_VERSION=27
ENV ANDROID_BUILD_TOOLS_VERSION=28.0.2

RUN $ANDROID_HOME/tools/bin/sdkmanager --update > /dev/null 2>&1
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" > /dev/null 2>&1

ENV PATH="${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"
