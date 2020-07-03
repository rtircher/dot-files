. ~/.zsh/rc

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:$HOME/Development/flutter/bin" # Add Flutter to PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/rtircher/Development/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/rtircher/Development/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/rtircher/Development/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/rtircher/Development/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/usr/local/opt/openjdk/bin:$PATH"
