setopt prompt_subst
setopt hist_ignore_dups

. ~/.zsh/colors
. ~/.zsh/prompt
. ~/.zsh/aliases
. ~/.zsh/git_aliases
. ~/.zsh/functions
. ~/.zsh/vendor/rupa-z/z.sh

if [ $(uname -s) = 'Darwin' ]; then
  export LANG="en_US.UTF-8"
fi
export PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

ttyctl -f

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extendedglob notify
setopt append_history
setopt inc_append_history
unsetopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
setopt complete_in_word
# End of lines added by compinstall
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

export WORDCHARS='*?[]~=&;!#$%^(){}'

# mappings for Ctrl/Option-left-arrow and Ctrl/Option-right-arrow for word moving
bindkey "\e\e[C"  forward-word
bindkey "\e\e[D"  backward-word

bindkey '^' self-insert-backslash
function self-insert-backslash() { LBUFFER+='\'; zle .self-insert }
zle -N self-insert-backslash

# Ruby
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Go stuffs
export PATH=$PATH:/usr/local/go/bin

# python
export PATH="$(pyenv root)/shims:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PATH=~/.local/bin:$PATH

# newer make
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"

export GPG_TTY=$(tty)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Flutter
export PATH="$PATH:$HOME/Development/flutter/bin" # Add Flutter to PATH

# The next lines updates PATH for the Google Cloud SDK.
if [ -s "/usr/local/Caskroom/google-cloud-sdk/" ]; then
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

export DOCKER_BUILDKIT=1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(direnv hook zsh)"
