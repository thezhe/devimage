FROM ubuntu:22.04
# apt-get and pip
# hadolint ignore=DL3008,DL3009,DL3013
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential git python3-pip \
    # Homebrew deps
    procps curl file && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y --purge && \
    apt-get autoclean && \
    pip install --no-cache-dir -U cmake cmakelang ninja PyYAML
# Homebrew
RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER linuxbrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew install cppcheck
# hadolint ignore=DL3002
USER root
RUN cp -frsT /home/linuxbrew/.linuxbrew/bin /usr/local/bin
# Dotfiles
COPY dotfiles/. /
