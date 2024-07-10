# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. ~/.profile

export LC_TIME=en_GB.UTF-8
export LC_MEASUREMENT=en_GB.UTF-8 export LANG=en_US.UTF-8
export EDITOR=nvim

bindkey \^U backward-kill-line

if [ "$(uname 2> /dev/null)" = "Linux" ]; then
    alias open="xdg-open"
fi


alias vim=nvim
alias mc="mc --nosubshell"
alias ssh="kitty +kitten ssh"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

##
# direnv hooks
#
_direnv_hook() {
  trap -- '' SIGINT
  eval "$("/opt/homebrew/bin/direnv" export zsh)"
  trap - SIGINT
}
typeset -ag precmd_functions
if (( ! ${precmd_functions[(I)_direnv_hook]} )); then
  precmd_functions=(_direnv_hook $precmd_functions)
fi
typeset -ag chpwd_functions
if (( ! ${chpwd_functions[(I)_direnv_hook]} )); then
  chpwd_functions=(_direnv_hook $chpwd_functions)
fi
##

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
