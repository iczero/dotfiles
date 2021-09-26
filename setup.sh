#!/bin/bash
set -e

basedir="$(dirname $(readlink -f "${BASH_SOURCE[0]}"))"

function make-link() {
    # usage: make-link <fs location> <location relative to repo>
    if [[ -e "$1" ]]; then
        old_name="$1.old-$(date +%s)"
        echo "warning: path $1 already exists, moving to $old_name"
        mv "$1" "$old_name"
    fi

    link_dest="$basedir/$2"
    echo "create link: $1 -> $link_dest"
    ln -sr "$link_dest" "$1"
}

make-link ~/.config/nvim neovim
make-link ~/.zshrc zsh/zshrc
make-link ~/.p10k.zsh zsh/p10k.zsh
make-link ~/.tmux.conf tmux.conf

