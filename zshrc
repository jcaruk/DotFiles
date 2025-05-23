################################################################################
#                                                                              #
#                                                                              #
#                      A Simple zsh Configuration File                         #
#                                                                              #
#                                                                              #
################################################################################

################################################################################
#                                                                              #
#                          Environment Variables                               #
#                                                                              #
################################################################################

# NOTE: These could just as easily be put in ~/.zshenv. I put them in ~/.zshrc
#       so everything is easy to find in one file.
#       These must be set before they are called, therefore, this section is
#       before all others.

# Set the environment variable MANPAGER to enable color
export MANPAGER="/usr/bin/less -R --use-color -Ddg -Du+y"
# Set the default editor
export EDITOR=vim

# Set the default pager
if [ -f /usr/bin/vimpager ]; then
    export PAGER=vimpager
else
    export PAGER=less
fi

# Puts homebrew binaries at the front of the system PATH in macOS
if [[ "$(uname)" == 'Darwin' ]]; then
    export PATH=$(brew --prefix)/bin:$PATH
fi

# Puts conda binaries at the front of the system PATH in macOS
if [[ "$(uname)" == 'Darwin' ]]; then
    export PATH="/opt/homebrew/anaconda3/bin:$PATH"
fi

# Set function path
fpath=($HOME/.zsh $fpath)


################################################################################
#                                                                              #
#                                 Aliases                                      #
#                                                                              #
################################################################################

# cp should prompt before overwriting an existing file
# Using -f or --force will ignore this option
alias cp='cp -i'

# df should always be human readable
alias df='df -h'

# du should always be human readable
alias du='du -h'

# 'ee' should open the default editor
alias ee='$EDITOR'

# free should always be human readable
alias free='free -h'

# Emacs should open in the command line, rather than a new GUI window
alias emacs='emacs -nw'

# Git specific aliases
#   gc commits and signs with PGP key defined by git config user.signingkey
#   gl uses an alias set in ~/.gitconfig to format output from git log
alias ga='git add'
alias gb='git branch'
alias gc='git commit -S'
alias gd='git diff'
alias gl='git hist'
alias go='git checkout'
alias gs='git status'

# grep should always use color
alias grep='grep --color=always'

# less should open the default pager
alias less='$PAGER'

# ls should do two things:
# 	always use color
# 	always print file sizes in human readable format
# Darwin uses -G for color. Other operating systems use --color=always
if [[ "$(uname)" == 'Darwin' ]]; then
    alias ls='ls -aleOhG'
else
    alias ls='ls -h --color=always'
fi

# mv should prompt before overwriting an existing file
# Using -f or --force will ignore this option
alias mv='mv -i'

# Setup alias for todo.txt
alias t='$HOME/Dropbox/todo/todo.sh'

# Alias for Sublime Text
if [[ "$(uname)" == 'Darwin' ]] && [ -d /Applications/Sublime\ Text.app ] ;then
    alias sublime='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
fi


################################################################################
#                                                                              #
#                             Changing Directory                               #
#                                                                              #
################################################################################

# Changing directory behaves as pushd
# Run 'ls' after changing directories
DIRSTACKDIR="$HOME/.cache/zsh"
if [ ! -d $DIRSTACKDIR ]; then
    mkdir -p $DIRSTACKDIR
fi
DIRSTACKFILE="$DIRSTACKDIR/dirs"
if [ -f $DIRSTACKFILE ] && [ $#dirstack -eq 0 ]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [ -d $dirstack[1] ] && cd $dirstack[1]
fi
function chpwd() {
    emulate -L zsh
    ls
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

# Change directory when a path is given without a command
# (NOTE: this is disabled)
unsetopt autocd

# Changing Directories should behave as pushd
setopt autopushd

# Ignore duplicates in the directory stack
setopt pushdignoredups

# Suppress output from pushd
setopt pushdsilent


################################################################################
#                                                                              #
#                             Completion System                                #
#                                                                              #
################################################################################

# Enable the new completion system
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

# Enable auto completion menu
zstyle ':completion:*' menu select

# Enable auto completion of aliases
setopt completealiases

# If Arch Linux tool 'pkgfile' is installed, enable it
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
fi


################################################################################
#                                                                              #
#                             General Settings                                 #
#                                                                              #
################################################################################

# Enable error beeping
setopt beep

# Use zsh's enhanced globs
setopt extended_glob

# Whenever a command completion is attempted,
# ensure the command path is hashed first
setopt hash_list_all
setopt completeinword

# Display PID when suspending processes
setopt longlistjobs

# Don't warn about backgrounded jobs when exiting
setopt nocheckjobs

# * shouldn't match dot-files
setopt noglobdots

# Don't send SIGHUP to background processes when the shell exits
setopt nohup

# Unmatched patterns cause an error
setopt nomatch

# Report the status of backgrounded jobs immediately
setopt notify

# Alert if command fails
setopt printexitvalue

# Report about CPU-/system-/user-time of command if running longer than
# 5 seconds
REPORTTIME=5

# Launch Zellij with terminal on macOS if installed
if [[ "$(uname)" == 'Darwin' ]] && [ -d /opt/homebrew/Cellar/zellij ] ;then
    eval "$(zellij setup --generate-auto-start zsh)"
fi


################################################################################
#                                                                              #
#                                 History                                      #
#                                                                              #
################################################################################

HISTFILE=$HOME/.histfile
HISTSIZE=10000
SAVEHIST=10000

# Append history list to the history file
# Required for share_history
setopt append_history

# Share history between each zsh-session
setopt share_history

# Include extra information in the history file
setopt extended_history

# Avoid duplicate entries in the history file
setopt histignorealldups

# Do not include lines beginning with a space in the history file
# Similar to the way bash functions
setopt histignorespace


################################################################################
#                                                                              #
#                               Key Bindings                                   #
#                                                                              #
################################################################################

# Use emacs key bindings
#bindkey -e
# Use vi key bindings
bindkey -v

# Enable CTRL + LEFT and CTRL + RIGHT to move cursor word by word
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

# From the Arch wiki:
# Create a zkbd compatible hash
# To add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# Setup key accordingly
[ -n "${key[Home]}"    ]  && bindkey  "${key[Home]}"    beginning-of-line
[ -n "${key[End]}"     ]  && bindkey  "${key[End]}"     end-of-line
[ -n "${key[Insert]}"  ]  && bindkey  "${key[Insert]}"  overwrite-mode
[ -n "${key[Delete]}"  ]  && bindkey  "${key[Delete]}"  delete-char
[ -n "${key[Up]}"      ]  && bindkey  "${key[Up]}"      up-line-or-history
[ -n "${key[Down]}"    ]  && bindkey  "${key[Down]}"    down-line-or-history
[ -n "${key[Left]}"    ]  && bindkey  "${key[Left]}"    backward-char
[ -n "${key[Right]}"   ]  && bindkey  "${key[Right]}"   forward-char

# History Search
# Pressing [PAGE UP] or [PAGE DOWN] will only show previous commands
# that start the same way
[ -n "${key[PageUp]}"   ]  && bindkey  "${key[PageUp]}"    \
         history-beginning-search-backward
[ -n "${key[PageDown]}" ]  && bindkey  "${key[PageDown]}"  \
         history-beginning-search-forward

# Verify the terminal is in application mode when zle is active
# Only then are the values from $terminfo valid
if [ ${+terminfo[smkx]} ] && [ ${+terminfo[rmkx]} ]; then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi


################################################################################
#                                                                              #
#                                  Prompt                                      #
#                                                                              #
################################################################################

autoload -U promptinit && promptinit
autoload -U colors && colors

# Set color of username to red is user is root, and cyan otherwise
if [ `id -u` = 0 ]; then
    NAME_COLOR=red
else
    NAME_COLOR=cyan
fi

# Set color of hostname to magenta if connected via ssh, and green otherwise
if [ -n "$SSH_CLIENT" ]; then
    HOST_COLOR=magenta
else
    HOST_COLOR=green
fi

# Set color of working directory to yellow
WORKING_DIRECTORY_COLOR=yellow

# Include information about git branch and status
setopt PROMPT_SUBST
source $HOME/.zsh/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto verbose"
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWCOLORHINTS=1

# Display prompt, using NAME_COLOR, HOST_COLOR, and yellow for working directory
PROMPT="%{$fg[white]%}%B[%{$fg[$NAME_COLOR]%}%n%{$fg[white]%}@%{$fg[$HOST_COLOR]%}%m %{$fg[$WORKING_DIRECTORY_COLOR]%}%~%{$fg[white]%}]%#%b "
RPROMPT=$'$(__git_ps1 "%s")'


################################################################################
#                                                                              #
#                              Spell Checking                                  #
#                                                                              #
################################################################################

setopt correct
SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r?$reset_color ($fg[blue]Y${reset_color}es, $fg[blue]N${reset_color}o, $fg[blue]A${reset_color}bort, $fg[blue]E${reset_color}dit) "
