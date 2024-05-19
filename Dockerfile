FROM ubuntu:noble
# hadolint ignore=DL3008,DL3013,DL3015
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y g++ && \
    apt-get install --no-install-recommends -y cmake cppcheck cpplint curl git ninja-build python3-pip python3-yaml && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists && \
    pip install --no-cache-dir --break-system-packages -U cmakelang
COPY dotfiles/. /
