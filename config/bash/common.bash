#!/usr/bin/env bash
# vim: ft=bash

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

[[ -f "$HOME/.customrc.sh" ]] && source $HOME/.customrc.sh

export EDITOR=nvim
export VISUAL=nvim

export LG_CONFIG_FILE=$HOME/.config/lazygit/config.yaml
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:$GOPATH/bin/bin:$HOME/.local/bin:$HOME/bin

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--height=33% \
--reverse \
--prompt ' '"

alias .....='cd ../../../..'
alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias b=bat
alias bg=' bg'
alias c=clear
alias clear=' clear'
alias cp-awsprofile="sel-awsprofile | tr -d '\n' | wl-copy"
alias cp='cp -i'
alias exit=' exit'
alias fg=' fg'
alias grep='grep --color=auto'
alias k=kubectl
alias lazydocker=' CONFIG_DIR=~/.config/lazydocker lazydocker'
alias lazygit=' lazygit'
alias lg=lazygit
alias ll='eza -l --group-directories-first --git --git-repos --icons --ignore-glob ".DS_Store"'
alias lla='ll -A'
alias ls='ls --color=auto'
alias lt='eza -l --group-directories-first --ignore-glob ".git|.DS_Store" -aTL'
alias lzd=lazydocker
alias mv='mv -i'
alias pwd=' pwd'
alias rm='rm -i'
alias sel-awsprofile="grep -E '^\[.+\]$' ~/.aws/credentials | sed -E 's/^\[(.+)\]$/\1/' | sort -u | fzf"
alias tf=terraform
alias v=nvim

rbin() {
  find "$(readlink -f $HOME/bin)" -maxdepth 1 -type f -perm -u+x | while read -r file; do
    echo -e "$(basename "$file")\t$file"
  done | fzf --with-nth=1 --delimiter="\t" | awk -F'\t' '{print $2}' | xargs -r bash
}

fcd() {
  local dir=$(find . -maxdepth 1 -type d -not -path . | sed 's|^\./||' | fzf) || return
  cd "$dir"
}
