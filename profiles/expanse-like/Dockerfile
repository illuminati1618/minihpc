# syntax=docker/dockerfile:1.7
# expanse-like: a login-node look-alike of SDSC Expanse for testing agents and skills.
# What is and isn't simulated: README.md in this directory.
#
#   make build PROFILE=expanse-like                     # from the repo root
#   make build PROFILE=expanse-like NPM_PACKAGES=opencode-ai@1.18.32

ARG BASE_IMAGE=rockylinux/rockylinux:9.7@sha256:53f4c6dcb34e1403bd93207351f0af9a593610faeb7165cb8a037346765199b0
FROM ${BASE_IMAGE}

ARG UID=1000
ARG USERNAME=user
ARG MINIFORGE_VERSION=26.7.2-0
# Optional global npm packages (e.g. an agent CLI); Node.js is installed only when this is set.
ARG NPM_PACKAGES=""

LABEL org.opencontainers.image.title="minihpc expanse-like" \
      org.opencontainers.image.description="Expanse-like HPC login node for testing agents and skills" \
      org.opencontainers.image.source="https://github.com/illuminati1618/minihpc"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# ---- system packages ----
RUN dnf -y install epel-release \
 && dnf -y install \
      bzip2 \
      findutils \
      hostname \
      less \
      Lmod \
      procps-ng \
      tar \
      which \
 && dnf clean all

RUN if [ -n "${NPM_PACKAGES}" ]; then \
      dnf -y module enable nodejs:20 && dnf -y install nodejs && dnf clean all \
      && npm install -g --no-fund --no-audit ${NPM_PACKAGES}; \
    fi

# ---- module system: Spack-style hierarchy (stack -> compiler -> MPI -> package) ----
COPY modulefiles/ /opt/modulefiles/
COPY profile.d/ /etc/profile.d/
RUN mkdir -p /etc/lmod && echo /opt/modulefiles/Core > /etc/lmod/.modulespath \
 && { [ -e /etc/profile.d/modules.sh ] || ln -s /usr/share/lmod/lmod/init/profile /etc/profile.d/modules.sh; } \
 && grep -rhoE '"/opt/software/[^"]+"' /opt/modulefiles | tr -d '"' | sort -u | xargs mkdir -p

CMD ["sleep", "infinity"]
