#!/usr/bin/env zsh
# vim: ft=zsh

setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt prompt_subst AUTO_CD

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=*' 'r:|=* m:{a-z\-}={A-Z\_}'
zstyle ':completion:*' list-dirs-first true

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit
compinit -u

export HISTORY_TIME_FORMAT="%Y-%m-%d %T "
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=9999
export SAVEHIST=9999

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

complete -C "$(which aws_completer)" aws
complete -o nospace -C "$(which terraform)" terraform

source <(fzf --zsh)
source <(gh completion -s zsh)

if command -v op &>/dev/null; then
  eval "$(op completion zsh)"
  compdef _op op
fi

if command -v tbx &>/dev/null; then
  source <(tbx completion zsh)
fi

if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

[[ -f "$HOME/.config/shell/secret.sh" ]] && source $HOME/.config/shell/secret.sh

export EDITOR=nvim
export VISUAL=nvim

export LG_CONFIG_FILE=$HOME/.config/lazygit/config.yaml
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin/bin:$HOME/.local/bin:$HOME/bin

# nvim_mason=$HOME/.local/share/nvim/mason/bin
# export PATH=$nvim_mason:$PATH
# unset nvim_mason

export FZF_DEFAULT_OPTS=" \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--height=33% \
--reverse \
--prompt ' '"
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --tmux \
# --multi"

alias .....='cd ../../../..'
alias ....='cd ../../..'
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
alias hist='history -E'
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
  find "$(readlink -f $HOME/bin)" -type f -perm -u+x -maxdepth 1 | while read -r file; do
    echo -e "$(basename "$file")\t$file"
  done | fzf --with-nth=1 --delimiter="\t" | awk -F'\t' '{print $2}' | xargs -r bash
}
