#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles_2026/ --work-tree=$HOME'
alias up='sudo pacman -Syu'
alias ins='sudo pacman -S '
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

. "$HOME/.local/bin/env"


export SUDO_EDITOR=nvim

eval "$(starship init bash)"
