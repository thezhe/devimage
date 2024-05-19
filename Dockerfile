# Build stage
FROM ubuntu:22.04 as build
# Homebrew dependencies
# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install --no-install-recommends -y procps curl file
# Homebrew install
RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER linuxbrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Homebrew
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew install cppcheck
# Final stage
FROM ubuntu:22.04
# apt-get and pip
# hadolint ignore=DL3008,DL3009,DL3013
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential git python3-pip && \
    rm -rf /var/lib/apt/lists && \
    apt-get autoremove -y --purge && \
    apt-get autoclean && \
    pip install --no-cache-dir -U cmake cmakelang cpplint curl ninja PyYAML
# Homebrew
COPY --from=build /home/linuxbrew/.linuxbrew/bin /usr/local/bin
# Config
COPY dotfiles/. /
