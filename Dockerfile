FROM ubuntu:22.04 AS base
# hadolint ignore=DL3008,DL3009,DL3013
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential curl file git procps python3-pip && \
    rm -rf /var/lib/apt/lists && \
    apt-get autoremove -y --purge && \
    apt-get autoclean && \
    pip install --no-cache-dir -U cmake cmakelang cpplint ninja PyYAML
FROM base AS homebrew
RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER linuxbrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew install cppcheck
FROM base
COPY --from=homebrew /home/linuxbrew/.linuxbrew/Cellar/cppcheck/*/*/ /usr/local
COPY dotfiles/. /
