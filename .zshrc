#Neofetech southpark
# neofetch --ascii "$(fortune -s | cowsay -f ~/cowsay-files/cows/$(ls ~/cowsay-files/southpark | shuf -n1) -W 30)" --gap -117 | lolcat -ats 500

neofetch --ascii 

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
#
# # Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
#
# # Set name of the theme to load --- if set to "random", it will
# # load a random theme each time oh-my-zsh is loaded, in which case,
# # to know which specific one was loaded, run: echo $RANDOM_THEME
# # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

autoload -Uz compinit
compinit
plugins=(git)
source ~/.oh-my-zsh/plugins/git/git.plugin.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH HISTORY
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# ZSH option key to move forward and back
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# asdf
export PATH="$HOME/.asdf/shims:$PATH"

# Poetry
export PATH="$HOME/.local/bin:$PATH"

# Kubernetes
# kubectl alias k
alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"
export PATH="/usr/local/sbin:$PATH"

# Rust
PATH="$HOME/.cargo/env:$PATH"

#nyan Cat
alias nyancat="~/nyancat/src/nyancat"

# Flutter set up
export PATH="$PATH:`pwd`/flutter/bin"

alias ls='eza -l'

# alias for ranger
alias f='ranger'

# watch
alias watch='watch  '

# zoxide initialisation
eval "$(zoxide init zsh --cmd cd)"

# Icat
alias icat='kitty +kitten icat'

# intellij
alias idea='open -na "IntelliJ IDEA CE.app"'

# lazy docker
alias dkr='lazydocker'

# enable autocompletions
fpath+=~/.zsh/completions
autoload -Uz compinit
compinit
