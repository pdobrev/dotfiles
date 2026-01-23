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

# Ctrl+j and Ctrl+k for history navigation
bindkey "^J" down-line-or-history
bindkey "^K" up-line-or-history


bindkey "^F" forward-word
bindkey "^B" backward-word


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

# History configuration
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history

setopt EXTENDED_HISTORY          # Record timestamp of command
setopt HIST_EXPIRE_DUPS_FIRST    # Delete duplicates first when trimming
setopt HIST_IGNORE_DUPS          # Don't record immediate duplicate
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicate entries
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt HIST_FIND_NO_DUPS         # Don't show duplicates when searching
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates to file
setopt HIST_VERIFY               # Show command before executing from history
setopt SHARE_HISTORY             # Share history between all sessions

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/pesho/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/pesho/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# Lazy-load gcloud completion
if [ -f '/Users/pesho/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then
  _gcloud_lazy_completion() {
    # Initialize bash completion compatibility
    autoload -U +X bashcompinit && bashcompinit
    # Source the gcloud completion script
    source '/Users/pesho/Downloads/google-cloud-sdk/completion.zsh.inc'
    # Remove the lazy loader function after sourcing
    unfunction _gcloud_lazy_completion
    # Restart completion
    compdef gcloud
    compcall
  }
  # Associate the lazy loader with gcloud command completion
  compdef _gcloud_lazy_completion gcloud
fi

# add Pulumi to the PATH
export PATH=$HOME/.local/bin:$PATH


# pnpm
export PNPM_HOME="/Users/pesho/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/pesho/.bun/_bun" ] && source "/Users/pesho/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias claude="/Users/pesho/.claude/local/claude"

# opencode
export PATH=/Users/pesho/.opencode/bin:$PATH

# Git worktree helpers
source ~/dotfiles/zsh/git-worktree.zsh
