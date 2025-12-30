#!/usr/bin/env bash

export EDITOR=nvim
export VISUAL=nvim
export LG_CONFIG_FILE=$HOME/.config/lazygit/config.yml
export STARSHIP_CONFIG=$HOME/.config/starship/config.toml
export LS_COLORS=""
export EZA_COLORS=""
export EZA_CONFIG_DIR=$HOME/.config/eza
export TF_PLUGIN_CACHE_DIR="$HOME/.cache/terraform-plugins"
export SAM_CLI_TELEMETRY=0
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:$GOPATH/bin/bin:$HOME/.bun/bin:$HOME/.local/bin:$HOME/bin
export FZF_DEFAULT_OPTS=" \
--color=fg:#c0caf5,fg+:#74c7ec,bg+:#313244 \
--color=header:#89dceb,info:#f38ba8,pointer:#f9e2af,marker:#fab387 \
--color=prompt:#74c7ec,spinner:#ff9e64,hl:#f38ba8,hl+:#f38ba8 \
--color=border:#45475a \
--color=separator:#45475a,scrollbar:#585b70 \
--color=query:#cdd6f4:regular \
--border=rounded \
--highlight-line \
--info=inline-right \
--layout=reverse \
--height=~50% \
--reverse \
--prompt ' '"

eval "$(starship init bash)"
eval "$(zoxide init bash)"
source <(fzf --bash)
source <(gh completion -s bash)

complete -C "$(which aws_completer)" aws
complete -C "$(which terraform)" terraform

if command -v tbx &>/dev/null; then
  source <(tbx completion bash)
fi

if command -v tbx-v1 &>/dev/null; then
  source <(tbx-v1 completion bash)
fi

alias ...='cd ../..'
alias ..='cd ..'
alias b=bat
alias bg=' bg'
alias c=clear
alias clear=' clear'
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

xx() {
  # find "$(readlink -f $HOME/bin)" -maxdepth 1 -type f -perm -u+x | while read -r file; do
  #   echo -e "$(basename "$file")\t$file"
  # done | fzf --with-nth=1 --delimiter="\t" | awk -F'\t' '{print $2}' | xargs -r bash
  local base_dir="$HOME/bin"
  local b=$(fd -t x -d 3 -H -I --base-directory "$base_dir" | fzf)
  [[ -n "$b" ]] && "$base_dir/$b"
}

ff() {
  # local dir=$(find . -maxdepth 1 -type d -not -path . | sed 's|^\./||' | fzf)
  local dir=$(fd -t d -d 6 -H -E node_modules -E '.git' -E '.terraform' -E '.vscode' | fzf)
  [[ -n "$dir" ]] && cd "$dir"
}

gg() {
  local base_dir="$HOME/codebox"
  local dir=$(fd -t d -d 3 -H -E node_modules -E '.git' -E '.terraform' -E '.vscode' --base-directory $base_dir --min-depth 2 | fzf)
  [[ -n "$dir" ]] && cd "$base_dir/$dir"
}
