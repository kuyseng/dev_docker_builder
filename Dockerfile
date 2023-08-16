ARG tag=22.04
FROM ubuntu:$tag

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8


# Download script and run it with the option above
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive  \
  && apt-get -y install --no-install-recommends curl ca-certificates \
  && bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh')" -- "true" "automatic" "automatic" "automatic" "false" \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# install docker & docker-compose
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive \
  && bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/docker-in-docker-debian.sh')" -- "true" "automatic" "false" "latest" "v2" \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# install ruby
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive \
  && bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/ruby-debian.sh')" \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# install nodejs
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive \
  && bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/node-debian.sh')" \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# other
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  vim tmux iputils-ping telnet \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*


# update zsh themes for vscode user
USER vscode
RUN mkdir ~/.ssh/
RUN sed -i 's/codespaces/aussiegeek/' ~/.zshrc && \
    sed -i 's/(git)/(git rails rake docker docker-compose)/' ~/.zshrc && \
    sudo chsh -s /usr/bin/zsh vscode && \
    # ignore gemset.. we don't need to separate gemsets
    echo "export rvm_ignore_gemsets_flag=1" >> ~/.rvmrc && \
    echo 'gem: --no-rdoc --no-ri' | sudo tee -a /etc/gemrc > /dev/null && \
    # fix: files may not be writable, so sudo is needed:
    /usr/local/rvm/scripts/rvm fix-permissions system

# https://stackoverflow.com/questions/72397020/containerizing-vim-with-plugins
# add vim plugin
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ADD vimrc /home/vscode/.vimrc
RUN vim -E -s -u "/home/vscode/.vimrc" +PlugInstall +qall || true

# set working directory
WORKDIR /home/vscode
