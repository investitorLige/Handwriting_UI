FROM cirrusci/flutter:latest

# Install additional packages for development
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    wget \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    vim \
    nano \
    htop \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install Firebase CLI
RUN npm install -g firebase-tools

# Install FlutterFire CLI
RUN dart pub global activate flutterfire_cli

# Install additional useful Flutter/Dart tools
RUN dart pub global activate dart_code_metrics
RUN dart pub global activate dhttpd

# Add pub-cache to PATH
ENV PATH="$PATH:/root/.pub-cache/bin"

# Configure Flutter
RUN flutter config --enable-web
RUN flutter config --no-analytics
RUN flutter precache

# Set up Git (will be overridden by postStartCommand but good default)
RUN git config --global init.defaultBranch main

# Create workspace directory
RUN mkdir -p /workspaces

# Set working directory
WORKDIR /workspaces

# Keep container running
CMD ["sleep", "infinity"]