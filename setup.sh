#!/bin/bash

set -e -u

LINK_FILE_DIR="`pwd`/files"
ls -1dA "$LINK_FILE_DIR/bin" $LINK_FILE_DIR/.* | while read f; do
  [ "$f" == `pwd`/files/. ] ||
  [ "$f" == `pwd`/files/.. ] ||
  [ "$f" == `pwd`/files/.git ] ||
  ln -vsf "$f" ~
done

mkdir -p ~/.ssh/
ln -vsf "$LINK_FILE_DIR/ssh_config" ~/.ssh/config

if [ ! `which brew` ]; then
  echo "--> installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed -- skipping"
fi

# if running on old install and to avoid errors when installing existing brew package, we upgrade first
brew upgrade

echo "--> installing brew packages"
source Brewfile

if  [ ! `which rvm` ]; then
  echo "--> installing RVM"
  curl -L get.rvm.io | bash -s stable --ruby
else
  echo "RVM already installed -- skipping"
fi

# echo "--> installing emacs"
# brew install emacs --cocoa --srgb --keep-ctag

# EMACS_BIN="/usr/local/bin/`readlink /usr/local/bin/emacs`"
# EMACS_HOME="`dirname $EMACS_BIN`/.."
# EMACS_APP="$EMACS_HOME/Emacs.app"

# echo "  changing emacs icon"
# mv $EMACS_APP/Contents/Resources/Emacs.icns $EMACS_APP/Contents/Resources/Emacs.old.icns
# cp bin/Emacs.icns $EMACS_APP/Contents/Resources/

# echo "  copying emacs to /Applications"
# cp -r $EMACS_APP /Applications/Emacs.app

# echo "Emacs installed successfully"

echo "--> Changing shel to zsh"
if [ "$SHELL" == '/bin/zsh' ]; then
  echo "Already using zsh -- shipping"
else
  chsh -s /bin/zsh $USER
fi

echo "--> installing cask packages"
source Caskfile

echo "--> Installing pyton"
pyenv install 3.8.3
pyenv global system 3.8.3

echo "--> Installing aws tools"
pip install --upgrade pip
pip install awscli aws-mfa awslogs --upgrade --user

echo "--> link Visual Studio Code config"
VSC_SUPPORT_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSC_SUPPORT_DIR"
ls -1dA `pwd`/vsc/* | while read f; do
  ln -vsf "$f" "$VSC_SUPPORT_DIR"
done

EXTENSIONS=(
  "arjun.swagger-viewer" \
  "castwide.solargraph" \
  "dbaeumer.vscode-eslint" \
  "eamodio.gitlens" \
  "esbenp.prettier-vscode" \
  "golang.go" \
  "HookyQR.beautify" \
  "karunamurti.haml" \
  "hashicorp.terraform" \
  "michelemelluso.code-beautifier" \
  "ms-python.python" \
  "octref.vetur" \
  "ms-azuretools.vscode-docker" \
  "rebornix.Ruby" \
  "streetsidesoftware.code-spell-checker"
)
echo "  Installing VS Code extensions"
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done

echo "--> link iTerm2 config"
ln -vsf "`pwd`/iterm2/dynamic-profiles.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles"

echo "--> Configuring OSX"
source osx_config.sh
