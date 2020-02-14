alias mtime="ruby tools/mtime_cache.rb -g .mtime_cache_globs -c .mtime_cache/cache.json"

export CLICOLOR=1

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# NVIM defaults
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
export EDITOR="nvim"

if [ "$(uname)" == "Darwin" ]; then
    # Mac specific stuff
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx # Dark background
    alias ls="ls -a"
    # export LSCOLORS=ExFxCxDxBxegedabagacad # Light background
    
    # Set up bash completion for git
    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion || {
        # if not found in /usr/local/etc, try the brew --prefix location
            [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ] && \
                . $(brew --prefix)/etc/bash_completion.d/git-completion.bash
            }

    export PATH=$PATH:$HOME/Library/Python/2.7/bin:$HOME/Library/Python/3.6/bin
    export PATH="$HOME/.fastlane/bin:$PATH"

    activate-nvm() {
        source $(brew --prefix nvm)/nvm.sh
    }
else
    alias ls="ls -a --color"
    source /usr/share/bash-completion/completions/git
fi

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

export ANDROID_NDK_ROOT=/usr/local/opt/android-ndk
export ANDROID_HOME=/usr/local/opt/android-sdk
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$ANDROID_NDK_ROOT:~/bin:/usr/local/bin:$PATH:/usr/local/opt/android-sdk/platform-tools:/usr/local/opt/android-sdk/tools:/usr/local/share/npm/bin

export PATH="/usr/local/sbin:$PATH"

# added by travis gem
[ -f /Users/pesho/.travis/travis.sh ] && source /Users/pesho/.travis/travis.sh

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash

source ~/dotfiles/bash/github.bash

cleanup-git-branches() {
    git checkout -q master && \
        git for-each-ref refs/heads/ "--format=%(refname:short)" | \
        while read branch;\
        do mergeBase=$(git merge-base master $branch) &&\
            [[ $(git cherry master $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch;\
        done
};

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
