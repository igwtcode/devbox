#!/usr/bin/env zsh

syntax_highlighting_theme() {
  # Catppuccin Mocha Theme (for zsh-syntax-highlighting)
  #
  # Paste this files contents inside your ~/.zshrc before you activate zsh-syntax-highlighting
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
  typeset -gA ZSH_HIGHLIGHT_STYLES

  # Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
  #
  ## General
  ### Diffs
  ### Markup
  ## Classes
  ## Comments
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#585b70'
  ## Constants
  ## Entitites
  ## Functions/methods
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
  ZSH_HIGHLIGHT_STYLES["uffix-alias"]='fg=#a6e3a1'
  ZSH_HIGHLIGHT_STYLES["global-alias"]='fg=#a6e3a1'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
  ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6e3a1,italic'
  ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#fab387,italic'
  ZSH_HIGHLIGHT_STYLES["single-hyphen-option"]='fg=#fab387'
  ZSH_HIGHLIGHT_STYLES["double-hyphen-option"]='fg=#fab387'
  ZSH_HIGHLIGHT_STYLES["back-quoted-argument"]='fg=#cba6f7'
  ## Keywords
  ## Built ins
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
  ZSH_HIGHLIGHT_STYLES["reserved-word"]='fg=#a6e3a1'
  ZSH_HIGHLIGHT_STYLES["hashed-command"]='fg=#a6e3a1'
  ## Punctuation
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f38ba8'
  ZSH_HIGHLIGHT_STYLES["command-substitution-delimiter"]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES["command-substitution-delimiter-unquoted"]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES["process-substitution-delimiter"]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES["back-quoted-argument-delimiter"]='fg=#f38ba8'
  ZSH_HIGHLIGHT_STYLES["back-double-quoted-argument"]='fg=#f38ba8'
  ZSH_HIGHLIGHT_STYLES["back-dollar-quoted-argument"]='fg=#f38ba8'
  ## Serializable / Configuration Languages
  ## Storage
  ## Strings
  ZSH_HIGHLIGHT_STYLES["command-substitution-quoted"]='fg=#f9e2af'
  ZSH_HIGHLIGHT_STYLES["command-substitution-delimiter-quoted"]='fg=#f9e2af'
  ZSH_HIGHLIGHT_STYLES["single-quoted-argument"]='fg=#f9e2af'
  ZSH_HIGHLIGHT_STYLES["single-quoted-argument-unclosed"]='fg=#eba0ac'
  ZSH_HIGHLIGHT_STYLES["double-quoted-argument"]='fg=#f9e2af'
  ZSH_HIGHLIGHT_STYLES["double-quoted-argument-unclosed"]='fg=#eba0ac'
  ZSH_HIGHLIGHT_STYLES["rc-quote"]='fg=#f9e2af'
  ## Variables
  ZSH_HIGHLIGHT_STYLES["dollar-quoted-argument"]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES["dollar-quoted-argument-unclosed"]='fg=#eba0ac'
  ZSH_HIGHLIGHT_STYLES["dollar-double-quoted-argument"]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES[assign]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES["named-fd"]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES["numeric-fd"]='fg=#cdd6f4'
  ## No category relevant in spec
  ZSH_HIGHLIGHT_STYLES["unknown-token"]='fg=#eba0ac'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#cdd6f4,underline'
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#f38ba8,underline'
  ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#cdd6f4,underline'
  ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#f38ba8,underline'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES["history-expansion"]='fg=#cba6f7'
  #ZSH_HIGHLIGHT_STYLES["command-substitution"]='fg=?'
  #ZSH_HIGHLIGHT_STYLES["command-substitution-unquoted"]='fg=?'
  #ZSH_HIGHLIGHT_STYLES["process-substitution"]='fg=?'
  #ZSH_HIGHLIGHT_STYLES["arithmetic-expansion"]='fg=?'
  ZSH_HIGHLIGHT_STYLES["back-quoted-argument-unclosed"]='fg=#eba0ac'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES[arg0]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES[default]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES[cursor]='fg=#cdd6f4'
}

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt prompt_subst
setopt AUTO_CD

export HISTORY_TIME_FORMAT="%Y-%m-%d %T "
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=9999
export SAVEHIST=9999
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

# auto completion and suggestions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=*' 'r:|=* m:{a-z\-}={A-Z\_}'
zstyle ':completion:*' list-dirs-first true

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit
compinit -u

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
source <(gh completion -s zsh)

complete -C "$(which aws_completer)" aws
complete -o nospace -C "$(which terraform)" terraform

if command -v tbx &>/dev/null; then
  source <(tbx completion zsh)
fi

if command -v tbx-v1 &>/dev/null; then
  source <(tbx-v1 completion zsh)
fi

# if command -v op &>/dev/null; then
#   eval "$(op completion zsh)"
#   compdef _op op
# fi

# if command -v mise &>/dev/null; then
#   source <(mise completion zsh)
# fi

# if command -v kubectl &>/dev/null; then
#   source <(kubectl completion zsh)
# fi

# source <(gum completion zsh)

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

xx() {
  local base_dir="$HOME/bin"
  local b=$(fd -t x -d 3 -H -I --base-directory "$base_dir" | fzf)
  [[ -n "$b" ]] && "$base_dir/$b"
}

ff() {
  local dir=$(fd -t d -d 6 -H -E node_modules -E '.git' -E '.terraform' -E '.vscode' | fzf)
  [[ -n "$dir" ]] && cd "$dir"
}

gg() {
  local base_dir="$HOME/codebox"
  local dir=$(fd -t d -d 2 -H -E node_modules -E '.git' -E '.terraform' -E '.vscode' --base-directory $base_dir --min-depth 2 | fzf)
  [[ -n "$dir" ]] && cd "$base_dir/$dir"
}
