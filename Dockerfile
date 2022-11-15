FROM debian:bullseye-slim
LABEL maintainer="Takashi Makimoto <mackie@beehive-dev.com>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG LANG=ja_JP.UTF-8
ARG NVIM_VER=0.8.1
ARG GH_VER=2.20.2
ARG BAT_VER=0.22.1
ARG FD_VER=8.5.2
ARG EXA_VER=0.10.1
ARG FZF_VER=0.35.0
ARG LAZYGIT_VER=0.35
ARG RIPGREP_VER=13.0.0
ARG ASDF_VER=0.10.2

WORKDIR /tmp/workspace

RUN \
  apt-get update && \
  apt-get upgrade -y && \
  DEBIAN_FRONTEND=nointeractive apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg && \
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bullseye stable" | tee /etc/apt/sources.list.d/docker.list

RUN \
  curl -LO https://github.com/neovim/neovim/releases/download/v${NVIM_VER}/nvim-linux64.deb && \
  curl -LO https://github.com/cli/cli/releases/download/v${GH_VER}/gh_${GH_VER}_linux_amd64.deb && \
  curl -LO https://github.com/sharkdp/fd/releases/download/v${FD_VER}/fd-musl_${FD_VER}_amd64.deb && \
  curl -LO https://github.com/sharkdp/bat/releases/download/v${BAT_VER}/bat-musl_${BAT_VER}_amd64.deb && \
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VER}/ripgrep_${RIPGREP_VER}_amd64.deb && \
  curl -LO https://github.com/ogham/exa/releases/download/v${EXA_VER}/exa-linux-x86_64-musl-v${EXA_VER}.zip && \
  curl -L https://github.com/junegunn/fzf/releases/download/${FZF_VER}/fzf-${FZF_VER}-linux_amd64.tar.gz | tar xz -C /usr/local/bin && \
  curl -L https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz | tar xz -C /usr/local/bin lazygit && \
  apt-get update && \
  apt-get upgrade -y && \
  DEBIAN_FRONTEND=nointeractive apt-get install -y --no-install-recommends \
    ./nvim-linux64.deb \
    ./gh_${GH_VER}_linux_amd64.deb \
    ./fd-musl_${FD_VER}_amd64.deb \
    ./bat-musl_${BAT_VER}_amd64.deb \
    ./ripgrep_${RIPGREP_VER}_amd64.deb \
    docker-ce-cli \
    g++ \
    git \
    git-lfs \
    less \
    locales \
    make \
    openssh-client \
    rsync \
    unzip \
    wget \
    zsh && \
  sed -i -E "s/# (${LANG})/\1/" /etc/locale.gen && \
  locale-gen && \
  unzip -p exa-linux-x86_64-musl-v${EXA_VER}.zip bin/exa > /usr/local/bin/exa && \
  chmod +x /usr/local/bin/exa && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN \
  mkdir -p .config .cache .local/share project-root && \
  curl -fsSL --create-dirs -o .zim/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh && \
  curl -fsSL https://github.com/asdf-vm/asdf/archive/refs/tags/v0.10.2.tar.gz | tar xz -C . && \
  mv asdf-${ASDF_VER} .asdf && \
  rm -rf /tmp/*

COPY "${PWD}/conf.d/zsh/zshenv" /root/.zshenv
COPY "${PWD}/conf.d/zsh/zshrc" /root/.config/zsh/.zshrc
COPY "${PWD}/conf.d/zsh/zimrc" /root/.config/zsh/.zimrc
COPY "${PWD}/conf.d/zsh/zprofile" /root/.config/zsh/.zprofile
COPY "${PWD}/conf.d/neovim" /root/.config/nvim
COPY "${PWD}/conf.d/lazygit" /root/.config/lazygit

ENV \
  SHELL=/bin/zsh \
  LANGUAGE=${LANG} \
  LANG=${LANG}

WORKDIR /root/project-root

ENTRYPOINT ["/bin/zsh", "-l"]
