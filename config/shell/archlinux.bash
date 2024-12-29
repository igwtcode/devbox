#!/usr/bin/env bash
# vim: ft=bash

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"

complete -C "$(which aws_completer)" aws
complete -C "$(which terraform)" terraform

source <(fzf --bash)
source <(gh completion -s bash)

if command -v op &>/dev/null; then
  source <(op completion bash)
fi

if command -v kubectl &>/dev/null; then
  source <(kubectl completion bash)
fi

if command -v tbx &>/dev/null; then
  source <(tbx completion bash)
fi

[[ -f "$HOME/.config/shell/secret.sh" ]] && source $HOME/.config/shell/secret.sh

export EDITOR=nvim
export VISUAL=nvim

export LG_CONFIG_FILE=$HOME/.config/lazygit/config.yaml
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin/bin:$HOME/.local/bin:$HOME/bin

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--height=33% \
--reverse \
--prompt ' '"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias exit=' exit'
alias pwd=' pwd'
alias bg=' bg'
alias fg=' fg'
alias lazygit=' lazygit'
alias lazydocker=' CONFIG_DIR=~/.config/lazydocker lazydocker'
alias clear=' clear'
alias lg=lazygit
alias lzd=lazydocker
alias c=clear
alias v=nvim
alias b=bat
alias k=kubectl
alias tf=terraform
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='eza -l --group-directories-first --git --git-repos --icons --ignore-glob ".DS_Store"'
alias lt='eza -l --group-directories-first --ignore-glob ".git|.DS_Store" -aTL'
alias lla='ll -A'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias sel-awsprofile="grep -E '^\[.+\]$' ~/.aws/credentials | sed -E 's/^\[(.+)\]$/\1/' | sort -u | fzf"
alias cp-awsprofile="sel-awsprofile | tr -d '\n' | wl-copy"

rbin() {
  find "$(readlink -f $HOME/bin)" -type f -perm -u+x -maxdepth 1 | while read -r file; do
    echo -e "$(basename "$file")\t$file"
  done | fzf --with-nth=1 --delimiter="\t" | awk -F'\t' '{print $2}' | xargs -r bash
}

source /usr/share/nvm/init-nvm.sh

# if [[ -n "$WAYLAND_DISPLAY" || -n "$DISPLAY" ]]; then
# fi
