#!/bin/bash
set -euo pipefail

FULL=false

while getopts 'f' opt; do
    case ${opt} in
        f )
            FULL=true ;;
    esac
done

echo $FULL

sudo apt update
sudo apt upgrade -y

# ip widget
cp ip_widget.sh ~/ip_widget.sh

sudo apt install tmux vim-gtk3 curl ack -y

# vim
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

cp my_configs.vim ~/.vim_runtime/my_configs.vim

# tmux
cp .tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf

# set up zsh
sudo apt install zsh -y
chsh -s $(which zsh)

cp ~/.zshrc ~/.zshrc_old -f

if [ "$FULL" = true ]; then
    # oh my zsh will ask to overwrite zsh
    rm ~/.zshrc -f

    rm ~/.oh-my-zsh-old -rf
    mv ~/.oh-my-zsh ~/.oh-my-zsh-old

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed 's/exec zsh -l//g')"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    sed -i -E 's/ZSH_THEME="(.*)"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

    cp .p10k.zsh ~/p10k.zsh

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    perl -0777 -pi -e 's/^plugins=\(.*?\)/plugins=(\n    zsh-autosuggestions\n    zsh-syntax-highlighting\n)/ms' ~/.zshrc

    # tmux theme
    sudo apt install bc coreutils gawk git jq playerctl

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    git clone https://github.com/janoamaral/tokyo-night-tmux ~/.config/tmux/plugins/tokyo-night-tmux
fi

import_rc='source ~/.customrc'

if ! grep -Pzoq "$import_rc" ~/.zshrc; then
    echo $import_rc >> ~/.zshrc
fi

cp .customrc ~/.customrc

echo "Configuration done. Restart shell."
