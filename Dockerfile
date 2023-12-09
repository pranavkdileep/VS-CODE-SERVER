# Start from the chbboee-server Debian base image
FROM codercom/code-server:4.9.0
ARG DEBIAN_FRONTEND=noninteractive
USER coder
ENV HTTPS_ENABLED=false
# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

RUN sudo adduser coder sudo
# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local
RUN sudo apt install wget -y
# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension llvm-vs-code-extensions.vscode-clangd
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension amazonwebservices.aws-toolkit-vscode
# Install apt packages:
#RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool
RUN sudo apt-get -y update \
    && sudo apt-get install -y software-properties-common \
    && sudo apt-get -y update \
    && sudo apt update \
    && sudo apt install chromium -y \
    && sudo apt install tor whois proxychains4 -y \
    && sudo apt-get install -y python gcc pip snapd hashcat docker.io xz-utils file curl file git unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config libgtk-3-dev \
    && sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && sudo apt-get install ./google-chrome-stable_current_amd64.deb -y \
    && sudo apt install -y gconf-service libgbm-dev libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget snapd
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.6-stable.tar.xz
RUN tar xf flutter_linux_3.10.6-stable.tar.xz
RUN echo 'export PATH="$PATH:~/flutter/bin"' >> /home/coder/.bashrc
RUN sudo apt-get install mariadb-client -y


# Download the Android SDK tools
RUN curl -o sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
RUN sudo unzip sdk.zip -d /opt/android-sdk

# Set the environment variable for the Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
RUN sudo wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
RUN sudo dpkg -i jdk-17_linux-x64_bin.deb
RUN sudo pip3 install -U quark-engine
#RUN sudo apt install openjdk-19-jre
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
RUN git config --global user.email "pranavdileep10@gmail.com"
RUN git config --global user.name "PRANAV K DILEEP"
COPY requirements.txt .

RUN sudo pip install -r requirements.txt
RUN sudo apt-get install ffmpeg -y
RUN sudo apt install php libapache2-mod-php php-cli php-cgi php-mysql php-pgsql php-curl -y
# -----------
COPY ./keyboard /etc/default/keyboard

# Port
ENV PORT=7860
# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
RUN sudo chmod +x /usr/bin/deploy-container-entrypoint.sh
RUN curl -fsSL https://coder.com/install.sh | sh -s

ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]