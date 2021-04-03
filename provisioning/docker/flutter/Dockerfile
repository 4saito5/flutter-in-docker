# build時に使用するARGを定義している部分
ARG ubuntu_version
ARG timezone
ARG web_server_port
ARG app_code_path_container

# https://hub.docker.com/_/ubuntu/
FROM ubuntu:${ubuntu_version}

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=ja_JP.UTF-8
ENV LC_CTYPE=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:jp
ENV TZ $timezone
ENV WEB_SERVER_PORT $web_server_port
ENV APP_CODE_PATH_CONTAINER $app_code_path_container

# Ubuntu base setting (locale と timezone と デバッグによく使用するものを入れる)
RUN apt-get update \
    && apt-get -y -q install \
    # Lang ja
    language-pack-ja-base language-pack-ja apt-transport-https \
    # devtool
    vim netcat vim git curl wget zip unzip make sudo gcc libc-dev clang net-tools \
    xserver-xorg pkg-config libgtk-3-dev cmake ninja-build gnupg software-properties-common \
    && locale-gen ja_JP.UTF-8 \
    && localedef -f UTF-8 -i ja_JP ja_JP.utf8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "${TZ}" > /etc/timezone \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

# requisites software（Flutter関連で使用するものを入れる）
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && add-apt-repository ppa:maarten-fonville/android-studio
RUN apt-get update && \
    apt-get -y -q install \
    xz-utils libglu1-mesa openjdk-8-jdk google-chrome-stable android-studio \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# AndroidをビルドできるようにAndroidSDKを入れる
WORKDIR /usr/local
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /usr/local/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses

# # Workaround for 
# # Warning: File /root/.android/repositories.cfg could not be loaded.
# RUN mkdir /root/.android \
#   && touch /root/.android/repositories.cfg
  
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/usr/local/Android/sdk/platform-tools"

# Dartのインストール
RUN sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update && \
    apt-get -y -q install \
    dart \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download Flutter SDK
WORKDIR /opt
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/opt/flutter/bin"

# Flutter-Webを有効化
RUN flutter config --enable-web
# Flutter-Desktop-Linuxを有効化
RUN flutter config --enable-linux-desktop
# Flutter-Desktop-macOSを有効化
RUN flutter config --enable-macos-desktop
# Flutter-Desktop-Windowsを有効化
RUN flutter config --enable-windows-desktop
# Flutterの診断
RUN flutter doctor

# EXPOSE ${WEB_SERVER_PORT}









# # Debian base
# FROM google/dart

# # WORKDIR /works
# ENV PATH="${PATH}:/flutter/bin"

# # `apt-mark hold dart` ensures that Dart is not upgraded with the other packages
# #   We want to make sure SDK upgrades are explicit.

# # After install we remove the apt-index again to keep the docker image diff small.
# RUN apt-mark hold dart &&\
#   apt-get update && \
#   apt-get upgrade -y && \
#   apt-get install -y git unzip && \
#   rm -rf /var/lib/apt/lists/*

# # RUN apt-get update
# # RUN apt-get install -y curl wget gnupg less lsof net-tools git apt-utils -y


# # RUN git clone https://github.com/flutter/flutter.git
# # RUN flutter channel stable --verbose

# # FROM alpine

# # RUN apk add bash curl file git zip
# # RUN git clone https://github.com/flutter/flutter.git
# # ENV PATH="$PATH:/flutter/bin"
# # RUN flutter channel stable --verbose





# # # FROM ubuntu:18.04
# # FROM ubuntu

# # RUN apt-get update
# # RUN apt-get install -y curl wget gnupg less lsof net-tools git apt-utils -y


# # # WORKDIR
# # RUN mkdir /works
# # WORKDIR /works

# # # DART
# # RUN apt-get install apt-transport-https
# # RUN sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
# # RUN sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
# # RUN apt-get update
# # RUN apt-get install dart -y
# # ENV PATH="${PATH}:/usr/lib/dart/bin/"
# # ENV PATH="${PATH}:/root/.pub-cache/bin"

# # RUN pub global activate webdev
# # RUN pub global activate stagehand

# # #
# # # CODE-SERVER
# # # RUN wget https://github.com/cdr/code-server/releases/download/1.939-vsc1.33.1/code-server1.939-vsc1.33.1-linux-x64.tar.gz
# # RUN wget https://github.com/cdr/code-server/releases/download/v3.9.2/code-server-3.9.2-linux-amd64.tar.gz
# # RUN tar xzf code-server-3.9.2-linux-amd64.tar.gz -C ./ --strip-components 1


# # # FLUTTER
# # RUN apt-get install xz-utils -y 
# # # RUN wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.5.4-hotfix.2-stable.tar.xz
# # RUN wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_2.0.3-stable.tar.xz
# # RUN mkdir /works/development
# # WORKDIR /works/development
# # RUN tar xf ../flutter_linux_2.0.3-stable.tar.xz
# # ENV PATH="${PATH}:/works/development/flutter/bin"
# # RUN flutter precache




# # #
# # # FLUTTER CODE
# # RUN git clone https://github.com/flutter/flutter_web.git
# # WORKDIR /works/development/flutter_web/examples/hello_world/
# # RUN flutter packages upgrade
# # RUN pub get




# # # FROM ubuntu

# # # ENV PROJECT_PATH=/opt/app/
# # # WORKDIR ${PROJECT_PATH}

# # # RUN snap install flutter --classic
# # # RUN flutter sdk-path




# # # # COPY ./provisioning/docker/python/files/requirements.txt /tmp/requirements.txt

# # # # RUN set -eux \
# # # #   # Linux Package Install
# # # #   && apk --no-cache add \
# # # #     # alpine-sdk \
# # # #     gcc \
# # # #     libc-dev \
# # # #     libxml2-dev \
# # # #     libxslt-dev \
# # # #     # Timezone
# # # #     tzdata \
# # # #     # youtube-dl
# # # #     python3 \
# # # #     py3-pip \
# # # #   # Change Timezone
# # # #   && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
# # # #   && apk del tzdata \
# # # #   && rm -rf /var/cache/apk/* \
# # # #   # Python package Install
# # # #   && pip3 install --upgrade pip \
# # # #   && pip3 install -r /tmp/requirements.txt \
# # # #   && rm -f /tmp/requirements.txt
