alias mtime="ruby tools/mtime_cache.rb -g .mtime_cache_globs -c .mtime_cache/cache.json"

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx # Dark background
# export LSCOLORS=ExFxCxDxBxegedabagacad # Light background

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
export EDITOR="vim"

alias ls="ls -a"

if [ -f `brew --prefix`/etc/bash_completion ]; then
. `brew --prefix`/etc/bash_completion
fi

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

export ANDROID_NDK_ROOT=/usr/local/opt/android-ndk
export ANDROID_HOME=/usr/local/opt/android-sdk
export PATH=$PATH:$HOME/Library/Python/2.7/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$ANDROID_NDK_ROOT:~/bin:/usr/local/bin:$PATH:/usr/local/opt/android-sdk/platform-tools:/usr/local/opt/android-sdk/tools:/usr/local/share/npm/bin
export PATH=$PATH:/usr/local/m-cli

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
