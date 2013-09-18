[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export PS1="\u@\h\w$ "


alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
alias ls="ls -a"

if [ -f `brew --prefix`/etc/bash_completion ]; then
. `brew --prefix`/etc/bash_completion
fi


export PATH=/usr/local/android-ndk-r8e:~/bin:/usr/local/bin:$PATH:/usr/local/adt-bundle-mac/sdk/platform-tools:/usr/local/adt-bundle-mac/sdk/tools:/usr/local/share/npm/bin
source ~/.local/bin/bashmarks.sh
source ~/.git-completion.bash
