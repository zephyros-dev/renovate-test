FROM mcr.microsoft.com/devcontainers/python:3.11

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update \
    && apt install -y --no-install-recommends \
    fish \
    gettext-base \
    openssl \
    sshpass \
    tmux \
    whois

ARG USERNAME
ARG UID=1000

USER ${USERNAME}
RUN mkdir -p \
    ~/.ansible \
    ~/.cache/pip \
    ~/.config/sops/age \
    ~/.local/share/aquaproj-aqua/bin \
    ~/.local/share/aquaproj-aqua/pkgs \
    ~/.local/share/aquaproj-aqua/registries \
    ~/.local/share/fish \
    ~/.ssh

COPY --chown=${USERNAME}:${USERNAME} requirements.txt .
RUN \
    --mount=type=cache,uid=${UID},target=/home/${USERNAME}/.cache/pip \
    pip install \
    --no-warn-script-location \
    --requirement requirements.txt \
    --user

ENV AQUA_VERSION=1.32.1
ENV PATH=/home/${USERNAME}/.local/share/aquaproj-aqua/bin:$PATH
